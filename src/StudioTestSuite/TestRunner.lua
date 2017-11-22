local TestCase = require(script.Parent.TestCase)

local testRunner = {
  -- Where to look for test cases.
  Locations = {
    game.ServerScriptService,
    game.ServerStorage,
    game.ReplicatedStorage,
    game.StarterPlayer
  },

  -- Names of the folders that contain test cases.
  FolderNames = {
    "Test",
    "Tests"
  }
}

local function isTestFolder(instance)
  for _, name in ipairs(testRunner.FolderNames) do
    if instance.Name == name and instance:IsA("Folder") then
      return true
    end
  end
end

local function getTestFolders()
  local folders = {}

  for _, location in ipairs(testRunner.Locations) do
    for _, descendant in ipairs(location:GetDescendants()) do
      if isTestFolder(descendant) then
        table.insert(folders, descendant)
      end
    end
  end

  return folders
end

local function getTestModules()
  local folders = getTestFolders()
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

-- Re-creates all of the spec modules.
--
-- This is to get around Studio keeping the modules in memory and reusing them
-- each test.
--
-- Instead of cut/pasting them each time, this does it for you so running your
-- tests always requires the latest module contents.
local function refreshModulesInMemory()
  local modules  = getTestModules()

  for _, module in ipairs(modules) do
    local clone = module:Clone()
    clone.Parent = module.Parent
    module:Destroy()
  end
end

local function runTests(module, tests)
  for name, value in pairs(tests) do
    assert(type(name) == "string", "keys in test modules must be strings")

    if type(value) == "table" then
      runTests(module, value)

    elseif type(value) == "function" then
      local case = TestCase.new(module, value)
      case:Run()
    end
  end
end

function testRunner.run()
  refreshModulesInMemory()

  for _, module in ipairs(getTestModules()) do
    local tests = require(module)
    runTests(module, tests)
  end
end

return testRunner
