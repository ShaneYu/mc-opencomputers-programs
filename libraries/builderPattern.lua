local Config = require("shadowrealm/config")

local BuilderPattern = Config:extend()

function BuilderPattern:__init(fileName)
  Config.__init(self, fileName, {})
end

local function _validateLayerData(layerData)
  -- TODO: Validate that the layer only contains chars that are in the materials of this pattern

  return false
end

function BuilderPattern:setOutput(itemName)
  self.output = itemName
end

function BuilderPattern:addMaterial(char, itemName)
  self.materials = self.materials or {}

  if self.materials[char] then
    return false, "A material has already been added with the specified char"
  end

  self.materials[char] = itemName
  return true
end

function BuilderPattern:removeMaterial(char)
  if not self.materials then
    return
  end

  self.materials[char] = nil
end

function BuilderPattern:replaceMaterial(char, itemName)
  self:removeMaterial(char)

  local res, _ = self:addMaterial(char, itemName)

  if not res then
    return false, "Material could not be replaced"
  end

  return true
end

function BuilderPattern:clearMaterials()
  self.materials = {}
end

function BuilderPattern:addLayer(layerData)
  self.layers = self.layers or {}
  self.layers[#self.layers + 1] = layerData

  return true
end

function BuilderPattern:removeLayer(layerIndex)
  if not self.layers then
    return true
  end

  if not layerIndex or layerIndex < 1 or layerIndex > #self.layers then
    return false, "The layer index provided is out of bounds"
  end

  table.remove(self.layers, layerIndex)
  return true
end

function BuilderPattern:replaceLayer(layerIndex, newLayerData)
  local res, err = self:removeLayer(layerIndex)

  if not res then
    return false, "Layer could not be replaced. " .. err
  end

  self.layers = self.layers or {}
  table.insert(self.layers, layerIndex, newLayerData)
end

function BuilderPattern:clearLayers()
  self.layers = {}
end

function BuilderPattern:isValid()
  if not self.output then
    return false, "Pattern is missing an output item name"
  end

  if not self.materials or #self.materials < 1 then
    return false, "Pattern is missing materials"
  end

  if not self.layers or #self.layers < 1 then
    return false, "Pattern is missing layers"
  end

  -- TODO: For each layer, check it's data only contains chars in the materials using '_validateLayerData(...)'

  return false
end

return BuilderPattern
