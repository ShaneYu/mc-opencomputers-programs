local io = require("io")
local shell = require("shell")
local filesystem = require("filesystem")
local Class = require("shadowrealm/core/classify")
local Serializable = require("shadowrealm/mixins/serializable")

local Config = Class("Config"):include(Serializable)

local function _autoLoad(self, errorIfLoadFails)
  local res, err, errReason = self:reload()

  if not res and errorIfLoadFails then
    io.stderr:write(err .. ". Reason: " .. errReason)
  end
end

local function _ensureFilePathDirectoryExists(filePath)
  local directory = filesystem.path(filePath)

  if not filesystem.exists(directory) then
    filesystem.makeDirectory(directory)
  end
end

function Config:initialize(fileName, defaults, errorIfLoadFilesOnInitialise)
  self._filePath = shell.resolve(fileName)

  if defaults ~= nil then
    self:include(defaults)
  end

  _autoLoad(self, errorIfLoadFilesOnInitialise)
end

function Config:reload()
  local file, err = io.open(shell.resolve(self._filePath), "r")

  if not file then
    return nil, "Config cannot be loaded", err
  end

  local fileContent = file:read("*a")
  self:deserialize(fileContent)
  io.close(file)
end

function Config:save()
  _ensureFilePathDirectoryExists(self._filePath)

  local file, err = io.open(self._filePath, "w")

  if not file then
    return false, "Config cannot be saved", err
  end

  file:write(self:serialize())
  io.close(file)

  return true
end

return Config
