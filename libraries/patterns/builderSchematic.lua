local PatternBase = require("shadowrealm/patterns/patternBase")
local BuilderSchematic = PatternBase:extend()

function BuilderSchematic:__init(fileName, defaults, errorIfSchematicCannotBeLoaded)
  PatternBase.__init(self, fileName, defaults, errorIfSchematicCannotBeLoaded)
end

function BuilderSchematic:addLayer(layer)
  self.layers = self.layers or {}
  self.layers[#self.layers + 1] = layer

  return true
end

function BuilderSchematic:removeLayer(layerIndex)
  if not self.layers then
    return true
  end

  if not layerIndex or layerIndex < 1 or layerIndex > #self.layers then
    return false, "The layer index provided is out of bounds"
  end

  table.remove(self.layers, layerIndex)
  return true
end

function BuilderSchematic:replaceLayer(layerIndex, newLayer)
  local res, err = self:removeLayer(layerIndex)

  if not res then
    return false, "Layer could not be replaced. " .. err
  end

  self.layers = self.layers or {}
  table.insert(self.layers, layerIndex, newLayer)
end

function BuilderSchematic:clearLayers()
  self.layers = {}
end

function BuilderSchematic:isValid()
  for _, layer in ipairs(self.layers) do
    for _, layerRow in ipairs(layer) do
      for _, materialKey in ipairs(layerRow) do
        if materialKey ~= "" and self:getMaterial(materialKey) == nil then
          return false, "Schematic layers contain materials that have not been added"
        end
      end
    end
  end

  local isValid, err = self.__super:isValid()
  return isValid, err:gsub("Pattern", "Schematic")
end

return BuilderSchematic
