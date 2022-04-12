----------------------------------------------------------------------
-------------------- [ Crafting Pattern Example ] --------------------
----------------------------------------------------------------------

local CraftingPattern = require("shadowrealm/patterns/craftingPattern")
local pickaxePattern = CraftingPattern:new("patterns/crafting.json")

pickaxePattern:setOutput("minecraft:egg")

if not pickaxePattern.materials then
  pickaxePattern:addMaterial("s", "minecraft:stick")
  pickaxePattern:addMaterial("c", "minecraft:cobblestone")
end

if not pickaxePattern.pattern then
  pickaxePattern:setPattern(
    {
      {"c", "c", "c"},
      {"", "s", ""},
      {"", "s", ""}
    }
  )
end

pickaxePattern:save()

local isValid, err = pickaxePattern:isValid()

print(string.format("Is pickaxe crafting pattern valid: %s%s", isValid, err and ", " .. err or ""))

----------------------------------------------------------------------
-------------------- [ Builder Pattern Example ] --------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
-------------------- [ Builder Schematic Example ] --------------------
----------------------------------------------------------------------
