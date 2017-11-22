# Studio Test Suite Spec

Studio Test Suite (STS) is a simple UI for running unit tests in Roblox.

This is a full replacement for Roblox's built in [TestService](), with support for behavior-driven development style test cases.

## Writing Tests

Tests are written similarly to frameworks like [Busted](http://olivinelabs.com/busted/) or [Mocha](http://mochajs.org/), but instead of `describe()` and `it()` functions, we just use tables and key/value pairs. For example:

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
key + function. All Spec modules follow this structure for definning tests.

## Structuring Tests

Tests are stored as ModuleScripts under a Folder named `Test` or `Tests` (your choice). This Folder will usually live in the same location as the modules being tested. For example:

![An example showing the hierarchy that could be used for test cases](images/example-structure.png)

The Hello module contains the code that will be used throughout the game, while TestHello contains test cases to make sure it works properly.

## Running Tests

Either click on the plugin's "Run" button, or use Shift+T to run your test cases.

Everything is logged to the output window, so make sure you have that up so you can view the results.

## License

The MIT License (MIT)
Copyright © 2017 David Minnerly

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
