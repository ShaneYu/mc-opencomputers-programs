local Class = require("shadowrealm/core/classify")

local StringBuilder = Class("StringBuilder")

function StringBuilder:initialize()
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
