local TestCase = require(script.Parent.TestCase)
local log = require(script.Parent.Log)

local TestRunner = {}
TestRunner.__index = TestRunner

function TestRunner.new(locations, folderNames)
  local self = {
    Passing = 0,
    Failing = 0,
    Pending = 0,
    TimeSpent = 0,
    Locations = locations,
    FolderNames = folderNames
  }

  return setmetatable(self, TestRunner)
end

function TestRunner:_isTestFolder(instance)
  for _, name in ipairs(self.FolderNames) do
    if instance.Name:lower() == name:lower() and instance:IsA("Folder") then
      return true
    end
  end
end

function TestRunner:_getTestFolders()
  local folders = {}

  for _, location in ipairs(self.Locations) do
    for _, descendant in ipairs(location:GetDescendants()) do
      if self:_isTestFolder(descendant) then
        table.insert(folders, descendant)
      end
    end
  end

  return folders
end

function TestRunner:_getTestModules()
  local folders = self:_getTestFolders()
  local modules = {}

  for _, folder in ipairs(folders) do
    for _, descendant in ipairs(folder:GetDescendants()) do
      if descendant:IsA("ModuleScript") then
        table.insert(modules, descendant)
      end
    end
  end

  return modules
end

function TestRunner:_getAllModules()
  local modules = {}

  for _, location in ipairs(self.Locations) do
    for _, descendant in ipairs(location:GetDescendants()) do
      if descendant:IsA("ModuleScript") then
        table.insert(modules, descendant)
      end
    end
  end

  return modules
end

function TestRunner:GetTotalTests()
  return self.Passing + self.Failing + self.Pending
end

-- Re-creates all of the spec modules.
--
-- This is to get around Studio keeping the modules in memory and reusing them
-- each test.
--
-- Instead of cut/pasting them each time, this does it for you so running your
-- tests always requires the latest module contents.
function TestRunner:RefreshModulesInMemory()
  local modules  = self:_getAllModules()

  for _, module in ipairs(modules) do
    local clone = module:Clone()
    clone.Parent = module.Parent
    module:Destroy()
  end
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function TestRunner:LogResults()
  log("Ran", self:GetTotalTests(), "tests in", round(self.TimeSpent, 3), "seconds")
  log(self.Passing, "passing,", self.Failing, "failing,", self.Pending, "pending")
end

function TestRunner:RunTestCase(module, callback)
  local case = TestCase.new(module, callback)
  local result, message = case:Run()

  if result == "passing" then
    self.Passing = self.Passing + 1
  elseif result == "failing" then
    self.Failing = self.Failing + 1
  elseif result == "pending" then
    self.Pending = self.Pending + 1
  end

  if message then
    warn(message)
  end
end

function TestRunner:Run()
  local start = tick()

  for _, module in ipairs(self:_getTestModules()) do
    local function runTests(tests)
      for name, value in pairs(tests) do
        assert(type(name) == "string", "keys in test modules must be strings")

        -- dealing with a container for test cases
        if type(value) == "table" then
          runTests(value)

        -- dealing with a test case
        elseif type(value) == "function" then
          self:RunTestCase(module, value)
        end
      end
    end

    runTests(require(module))
  end

  self.TimeSpent = tick() - start
end

return TestRunner
