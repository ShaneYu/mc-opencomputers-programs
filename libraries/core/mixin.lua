local Mixin = {}

function Mixin:include(other)
  for k, v in pairs(other) do
    self[k] = v
  end
end

function Mixin:copy()
  local copy = {}

  for k, v in pairs(self) do
    copy[k] = v
  end

  return copy
end

function Mixin:toSanitizedTable()
  local cleaned = {}

  local function isArray(tbl)
    local i = 0

    for _ in pairs(tbl) do
      i = i + 1
      if tbl[i] == nil then
        return false
      end
    end

    return true
  end

  local function cleanTable(tbl)
    if isArray(tbl) then
      return tbl
    end

    local clean_tbl = {}

    for k, v in pairs(tbl) do
      if not k:find("^__") then
        if type(v) == "table" then
          clean_tbl[k] = cleanTable(v)
        else
          clean_tbl[k] = v
        end
      end
    end

    return clean_tbl
  end

  return cleanTable(self)
end

function Mixin:hasa(other, ...)
  if self == other then
    return true
  end

  local args = {...}

  -- If there are filters
  if args[1] then
    -- no filters
    -- loop through keys in other
    for k, v in pairs(other) do
      -- filter
      for k2, v2 in ipairs(args) do
        if type(other[k]) == v2 then
          -- check if key exists
          if not self[k] then
            return false
          end
        end
      end
    end
  else
    -- loop through keys in other
    for k, v in pairs(other) do
      -- check if key exists
      if not self[k] then
        return false
      end
    end
  end

  return true
end

return Mixin
