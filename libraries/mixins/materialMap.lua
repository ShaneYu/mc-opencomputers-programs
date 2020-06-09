local MaterialMap = {}

function MaterialMap:included(klass)
  klass.materials = {}
end

function MaterialMap:addMaterial(key, itemName)
  if self.materials[key] then
    return false, "A material has already been added with the specified key"
  end

  self.materials[key] = itemName
  return true
end

function MaterialMap:removeMaterial(key)
  self.materials[key] = nil
end

function MaterialMap:replaceMaterial(key, newItemName)
  self:removeMaterial(key)

  local res, _ = self:addMaterial(key, newItemName)

  if not res then
    return false, "Material could not be replaced"
  end

  return true
end

function MaterialMap:clearMaterials()
  self.materials = {}
end

function MaterialMap:getMaterial(key)
  if self.materials[key] then
    return self.materials[key]
  end

  return nil, "A material does not exist with the specified key"
end

function MaterialMap:getMaterialNames()
  local materialNames = {}

  for _, material in pairs(self.materials) do
    materialNames[#materialNames + 1] = material
  end

  return materialNames
end

return MaterialMap
