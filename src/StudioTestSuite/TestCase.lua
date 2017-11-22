local TestCase = {}
TestCase.__index = TestCase

local function indent(str)
  return "    " .. str
end

--------------------------------------------------------------------------------
-- WARNING: The below is actually the worst code I've ever written in my life.
-- It's simply used by the getFailureMessage() function below to log the name of
-- the test and all its parents, but damn is this easier said than done.

-- Returns true if `value` is anywhere inside `t`, false otherwise.
--
-- This will recurse through the entire table.
local function tableHasValue(t, value, found)
  found = found or false
  for _, v in pairs(t) do
    if v == value then
      found = true
      break
    elseif type(v) == "table" then
      found = tableHasValue(v, value, found)
    end
  end

  return found
end

-- Goes down the list of testCases until it finds the test case with a value of
-- testCallback.
--
-- It returns a list of all the parents that it went down to get to this value
-- (including the key of the value itself). The return value will look something
-- like this:
--
--   { "Array", "Add()", "it should add items to the array" }
local function getTestCaseStack(testCases, testCallback, stack)
  local stack = stack or { }

  for name, value in pairs(testCases) do
    if type(value) == "function" and value == testCallback then
      table.insert(stack, name)
      return stack
    elseif type(value) == "table" then
      if tableHasValue(value, testCallback) then
        -- We're on the right path.
        table.insert(stack, name)
        return getTestCaseStack(value, testCallback, stack)
      else
        -- Keep searching for a group of tests that has the test function.
        stack = getTestCaseStack(value, testCallback, stack)
      end
    end
  end

  return stack
end

-- END WARNING you may now carry on with your business. please forget you saw
-- this... please
--------------------------------------------------------------------------------

function TestCase.new(module, callback)
  local self = {
    Module = module,
    Callback = callback,
    Assertions = 0
  }

  return setmetatable(self, TestCase)
end

function TestCase:GetFailureMessage()
  local template = "Test failed in %s:\n    %s"
  local testStack = getTestCaseStack(require(self.Module), self.Callback)

  return template:format(self.Module.Name, table.concat(testStack, " > "))
end

function TestCase:Run()
  local env = getfenv(self.Callback)
  local failureMessage = self:GetFailureMessage()

  local startingAssertions = self.Assertions

  function env.assert(condition)
    self.Assertions = self.Assertions + 1
    self.Passed = condition
  end

  local success, err = pcall(function()
    self.Callback()
  end)

  if success and self.Passed then
    return "passing"
  elseif self.Assertions == 0 then
    return "pending", failureMessage .. "\n    No assertions found"
  else
    local message = {
      failureMessage,
      indent("Assertion " .. self.Assertions - startingAssertions .. " failed")
    }

    if err then
      table.insert(message, indent(err))
    end

    return "failing", table.concat(message, "\n")
  end
end

return TestCase
