local io = require("io")
local shell = require("shell")
local filesystem = require("filesystem")
local Class = require("shadowrealm/core/middleclass")
local ObjectStore = require("shadowrealm/objectStore")

local Config = Class("Config")

local function _isArray(tbl)
  local i = 0

  for _ in pairs(tbl) do
    i = i + 1

    if tbl[i] == nil then
      return false
    end
  end

  return true
end

local _cleanTable
_cleanTable = function(tbl)
  if _isArray(tbl) then
    return tbl
  end

  local cleanedTable = {}

  for k, v in pairs(tbl) do
    if k ~= "class" and not k:find("^_") and type(v) ~= "function" then
      if type(v) == "table" then
        cleanedTable[k] = _cleanTable(v)
      else
        cleanedTable[k] = v
      end
    end
  end

  return cleanedTable
end

function Config:initialize(name, defaults, storeDir)
  self._storeName = name
  self._store = ObjectStore:new(storeDir)
  self._defaults = defaults

  self:applyDefaults()

  if not self._store:exists(self._storeName) then
    self._store:save(self._storeName, _cleanTable(self))
  end
end

function Config:applyDefaults()
  if self._defaults ~= nil then
    for k, v in pairs(self._defaults) do
      self[k] = v
    end
  end
end

function Config:load()
  self:applyDefaults()

  local status, obj = self._store:load(self._storeName)

  if not status then
    return false
  end

  if obj ~= nil then
    for k, v in pairs(obj) do
      self[k] = v
    end
  end

  return true
end

function Config:save()
  local status = self._store:save(self._storeName, _cleanTable(self))

  if not status then
    io.stderr:write("Unable to save configuration to file")
    return false
  end

  return true
end

function Config:delete()
  return self._store:delete(self._storeName)
end

return Config
