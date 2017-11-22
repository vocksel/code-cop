local run = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

local testRunner = require(script.Parent.TestRunner)

-- A keybinding is one or more keys that are held to perform an action.
local DEFAULT_KEYBINDS = {
  RunTests = { Enum.KeyCode.LeftShift, Enum.KeyCode.T }
}

local toolbar = plugin:CreateToolbar("Test Suite")

local function handleRunButton()
  local button = toolbar:CreateButton("Run",
    "Runs all of the test cases in the game",
    "rbxassetid://1193030998")

  button.Click:Connect(testRunner.run)
end

local function handleKeybindings()
  -- Checks that all the keys of a keybind are held down.
  --
  -- table keybind
  --  Array of `KeyCode` enums. When these are the only keys held, the function
  --  returns true.
  local function isKeybindHeld(keybind)
    local keysPressed = userInput:GetKeysPressed()

    if #keysPressed ~= #keybind then return end

    local matches = 0

    for _, input in ipairs(keysPressed) do
      for _, key in ipairs(keybind) do
        if input.KeyCode == key then
          matches = matches + 1
        end
      end
    end

    return matches == #keysPressed
  end

  userInput.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
      if isKeybindHeld(DEFAULT_KEYBINDS.RunTests) then
        testRunner.run()
      end
    end
  end)
end

handleRunButton()
handleKeybindings()
