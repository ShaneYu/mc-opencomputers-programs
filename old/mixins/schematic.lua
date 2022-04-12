local Schematic = {}

function Schematic:setLayers(layers)
  self.layers = layers
end

function Schematic:addLayer(layer)
  self.layers = self.layers or {}
  self.layers[#self.layers + 1] = layer

  return true
end

function Schematic:removeLayer(layerIndex)
  if not self.layers then
    return true
  end

  if not layerIndex or layerIndex < 1 or layerIndex > #self.layers then
    return false, "The layer index provided is out of bounds"
  end

  table.remove(self.layers, layerIndex)
  return true
end

function Schematic:replaceLayer(layerIndex, newLayer)
  local res, err = self:removeLayer(layerIndex)

  if not res then
    return false, "Layer could not be replaced. " .. err
  end

  self.layers = self.layers or {}
  table.insert(self.layers, layerIndex, newLayer)
end

function Schematic:clearLayers()
  self.layers = {}
end

return Schematic
