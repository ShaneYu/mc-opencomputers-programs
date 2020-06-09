local JSON = require("JSON")

local Serializable = {}

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
    if not k:find("^__") then
      if type(v) == "table" then
        cleanedTable[k] = _cleanTable(v)
      else
        cleanedTable[k] = v
      end
    end
  end

  return cleanedTable
end

function Serializable:toSanitizedTable()
  return _cleanTable(self)
end

function Serializable:serialize()
  local sanitized = self:toSanitizedTable()

  for k, v in pairs(sanitized) do
    print(k, v)
  end

  return JSON:encode_pretty(sanitized)
end

function Serializable:deserialize(serializedData)
  if serializedData then
    self.class:include(JSON:decode(serializedData) or {})
  end
end

return Serializable
