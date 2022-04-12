local io = require("io")
local shell = require("shell")
local filesystem = require("filesystem")
local Class = require("shadowrealm/core/middleclass")
local serializer = require("shadowrealm/serializer")

local ObjectStore = Class("ObjectStore")

local function _ensureFilePathDirectoryExists(filePath)
  local directory = filesystem.path(filePath)

  if not filesystem.exists(directory) then
    filesystem.makeDirectory(directory)
  end
end

function ObjectStore:initialize(storeDir)
  self._storeDir = shell.resolve(storeDir or "/home/data")
end

function ObjectStore:load(name)
  return serializer.deserializeFromFile(self._storeDir .. "/" .. name)
end

function ObjectStore:save(name, obj)
  return serializer.serializeToFile(self._storeDir .. "/" .. name, obj)
end

function ObjectStore:delete(name)
  filesystem.remove(self._storeDir .. "/" .. name)
end

function ObjectStore:exists(name)
  return filesystem.exists(self._storeDir .. "/" .. name)
end

return ObjectStore
