local Mixin = require("shadowrealm/core/mixin")
local Class = Mixin:copy()

function Class:extend(...)
  local instance = {}
  setmetatable(instance, self)
  self.__index = self

  instance.__super = self

  -- force instance to inherit args
  instance:implement(...)

  return instance
end

function Class:implement(...)
  local args = {...}

  for i, v in ipairs(args) do
    for k, v2 in pairs(Class) do
      if v[k] then
        error("Cannot implement '" .. v .. "', reason: 'Class' keys found")
      end
    end

    self:include(v)
  end
end

function Class:__init()
  -- Initialize vars and call super...
end

function Class:new(...)
  local instance = self:extend()
  instance:__init(...)

  return instance
end

function Class:copy(excludePrivates)
  local copy = self.__super:extend()

  Mixin.include(copy, self, excludePrivates)

  return copy
end

function Class:isa(other)
  if self == other then
    return true
  end

  local parent = self.__super
  while parent do
    if parent == other then
      return true
    end
    parent = parent.__super
  end

  -- If super check fails, check for implementation of functions
  if Mixin.hasa(self, other, "function") then
    return true
  end

  return false
end

return Class
