local BuilderPattern = require("shadowrealm/builderPattern")
local testPattern = BuilderPattern:new("patterns/egg.json")

testPattern:setOutput("minecraft:egg")
testPattern:addMaterial("d", "minecraft:dirt")
testPattern:addMaterial("c", "minecraft:cobblestone")
testPattern:addLayer({"d", "c", "d"})
testPattern:addLayer({"c", "d", "c"})
testPattern:addLayer({"d", "c", "d"})
testPattern:save()

print("Is pattern valid: " .. testPattern:isValid())
