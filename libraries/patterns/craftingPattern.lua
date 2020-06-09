local Class = require("shadowrealm/core/classify")
local Config = require("shadowrealm/config")
local MaterialMap = require("shadowrealm/mixins/materialMap")
local TableUtils = require("shadowrealm/mixins/tableUtils")

local CraftingPattern = Class("CraftingPattern", Config):include(MaterialMap)

local function __validatePattern(pattern)
  local res = TableUtils:isNilOrEmpty(pattern)

  if res then
    return false, "Pattern is empty"
  end

  local lastRowLength
  for _, row in ipairs(pattern) do
    if not lastRowLength then
      lastRowLength = #row
    elseif #row ~= lastRowLength then
      return false, "Pattern contains rows of varying lengths"
    end
  end

  return true
end

function CraftingPattern:initialize(fileName, defaults, errorIfPatternCannotBeLoaded)
  Config.initialize(self, fileName, defaults, errorIfPatternCannotBeLoaded)
end

function CraftingPattern:setOutput(itemName)
  self.output = itemName
end

function CraftingPattern:setPattern(pattern)
  local isPatternValid, err = __validatePattern(pattern)
  if not isPatternValid then
    return false, err
  end

  self.pattern = pattern
  return true
end

function CraftingPattern:isValid()
  if not (not tostring(self.output):find("^%s*$")) then
    return false, "Pattern is missing an output item name"
  end

  local isPatternValid, err = __validatePattern(self.pattern)
  if not isPatternValid then
    return false, err
  end

  for _, row in ipairs(self.pattern) do
    for _, materialKey in ipairs(row) do
      if materialKey ~= "" and self:getMaterial(materialKey) == nil then
        return false, "Pattern contains materials that have not been added"
      end
    end
  end

  return true
end

return CraftingPattern
