-- Simple function for logging to the console.
--
-- Uses a prefix so when we display information to the user they know which
-- plugin it's coming from.

local function log(...)
  print("[CodeCop]", ...)
end

return log
