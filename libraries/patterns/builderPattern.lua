local BuilderSchematic = require("shadowrealm/patterns/uilderSchematic")
local BuilderPattern = BuilderSchematic:extend()

function BuilderPattern:__init(fileName, defaults, errorIfPatternCannotBeLoaded)
  BuilderSchematic.__init(self, fileName, defaults, errorIfPatternCannotBeLoaded)
end

function BuilderPattern:setOutput(itemName)
  self.output = itemName
end

function BuilderPattern:isValid()
  if not self.output or self.output:gsub("%s+", ""):len() == 0 then
    return false, "Pattern is missing an output item name"
  end

  local isValid, err = self.__super:isValid()
  if not isValid then
    return false, err:gsub("Schematic", "Pattern schematic")
  end

  return true
end

return BuilderPattern
