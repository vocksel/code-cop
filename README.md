# Code Cop

Code Cop is a simple plugin for running unit tests in Roblox.

This is a full replacement for Roblox's built in [TestService](http://wiki.roblox.com/index.php?title=API:Class/TestService), with support for behavior-driven development style test cases.

## Writing Tests

Tests are written similarly to frameworks like [Busted](http://olivinelabs.com/busted/) or [Mocha](http://mochajs.org/), but instead of `describe()` and `it()` functions, tests are written as simple table data structures:

```lua
local hello = require(script.Parent.Parent.Hello)

local tests = {
  ["hello()"] = {
    ["it should greet the whole world by default"] = function()
      assert(hello() == "Hello, World!")
    end,

    ["it should greet a person by name"] = function()
      assert(hello("John") == "Hello, John!")
    end
  }
}

return tests
```

A `describe()` in this case would be a key + table, and an `it()` would be a
key + function.

The built-in `assert` function is overwritten inside each test case. You use it to verify that the condition passed to it is true. If it is, it passes. You can use as many `assert` calls as you like in a test case. If any assertion fails, the case fails too.

Functions are treated as test cases, and tables are treated as containers for test cases. Using tables allows you to break up your test cases based on specific functionality, instead of grouping each case together.

## Structuring Tests

Tests are stored as ModuleScripts under a Folder named `Test` or `Tests` (your choice). It's advised to keep this folder in the same location as the modules being tested. For example:

![An example showing the hierarchy that could be used for test cases](images/example-structure.png)

The `Hello` module contains the code that will be used throughout the game, while `TestHello` contains test cases to make sure it works properly.

## Running Tests

Either click on the plugin's "Run" button, or use Shift+T to run your test cases.

Everything is logged to the output window, so make sure you have that up so you can view the results.

## License

The MIT License (MIT)
Copyright © 2017 David Minnerly

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
