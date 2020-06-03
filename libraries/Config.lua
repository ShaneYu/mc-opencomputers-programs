local io = require("io")
local shell = require("shell")
local JSON = require("JSON")
local Class = require("core/Class")

local Config = Class:extend()

function Config:__init(filePath, defaults, errorIfConfigCannotBeLoaded)
  Class.__init(self)
  self.__filePath = filePath

  -- attempt a auto load
  local res, err, errReason = self:reload()

  if errorIfConfigCannotBeLoaded then
    io.stderr:write(err .. ". Reason: " .. errReason)
    return
  end

  if not res and defaults ~= nil then
    self:include(defaults)
  end
end

function Config:reload()
  local file, err = io.open(shell.resolve(self.__filePath), "r")

  if not file then
    return nil, "Config cannot be loaded", err
  end

  local fileContent = file:read("*a")
  local decodedData = JSON:decode(fileContent)

  io.close(file)
  self:include(decodedData)
end

function Config:save()
  local encodedData = JSON:encode_pretty(self)
  local file, err = io.open(shell.resolve(self.__filePath), "w")

  if not file then
    return false, "Config cannot be saved", err
  end

  file:write(encodedData)
  io.close(file)

  return true
end

return Config
