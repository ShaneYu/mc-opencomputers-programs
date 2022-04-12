local filesystem = require("filesystem")
local JSON = require("json")

local function _ensureFilePathDirectoryExists(filePath)
  local directory = filesystem.path(filePath)

  if not filesystem.exists(directory) then
    filesystem.makeDirectory(directory)
  end
end

local function serialize(obj)
  return JSON:encode_pretty(obj)
end

local function serializeToFile(filePath, obj)
  _ensureFilePathDirectoryExists(filePath)

  local file, err = io.open(filePath, "w")

  if not file then
    return false, err
  end

  file:write(serialize(obj))
  io.close()

  return true
end

local function deserialize(str)
  return JSON:decode(str)
end

local function deserializeFromFile(filePath)
  local file, err = io.open(filePath, "r")

  if not file then
    return false, {}, err
  end

  local fileContent = file:read("*a")
  io.close()

  return true, deserialize(fileContent)
end

local function clone(obj)
  return deserialize(serialize(obj))
end

return {
  serialize = serialize,
  serializeToFile = serializeToFile,
  deserialize = deserialize,
  deserializeFromFile = deserializeFromFile,
  clone = clone
}
