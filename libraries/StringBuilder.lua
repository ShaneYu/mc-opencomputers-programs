local Class = require("shadowrealm/core/class")
local StringBuilder = Class:extend()

function StringBuilder:__init()
  Class.__init(self)
  self.buffer = {}
end

function StringBuilder:append(str)
  self.buffer[#self.buffer + 1] = str
end

function StringBuilder:appendLine(str)
  if str then
    self:append(str)
  end

  self:append("\n")
end

function StringBuilder:appendFormat(...)
  self:append(string.format(...))
end

function StringBuilder:clear()
  self.buffer = {}
end

function StringBuilder:toString()
  return table.concat(self.buffer, "")
end

return StringBuilder
