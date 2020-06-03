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
