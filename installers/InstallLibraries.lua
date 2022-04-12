-- modular code
local application = "ShadowRealm Libraries"
local dlTbl = {
  -- Core
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/core/middleclass.lua",
    file = "/usr/lib/shadowrealm/core/middleclass.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/core/stateful.lua",
    file = "/usr/lib/shadowrealm/core/stateful.lua"
  },

  -- Utils
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/config.lua",
    file = "/usr/lib/shadowrealm/config.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/json.lua",
    file = "/usr/lib/json.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/stringBuilder.lua",
    file = "/usr/lib/shadowrealm/stringBuilder.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/serializer.lua",
    file = "/usr/lib/shadowrealm/serializer.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/objectStore.lua",
    file = "/usr/lib/shadowrealm/objectStore.lua"
  },

  -- Mixins
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/mixins/tableUtils.lua",
    file = "/usr/lib/shadowrealm/mixins/tableUtils.lua"
  },

  -- UI
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/ui/gui.lua",
    file = "/usr/lib/shadowrealm/ui/gui.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/ui/buttons.lua",
    file = "/usr/lib/shadowrealm/ui/buttons.lua"
  }
}

-- internal

local component = require("component")
local fs = require("filesystem")
local term = require("term")

if not component.isAvailable("internet") then
  io.stderr:write("Missing an internet card!")
  return
end

local internet = require("internet")

local function writeFile(data, name)
  if fs.exists(name) then
    fs.remove(name)
  else
    local path = fs.path(name)

    if path then
      local pSeg = fs.segments(path)
      local pCur = "/"

      for _, seg in pairs(pSeg) do
        pCur = fs.concat(pCur, seg)

        if not fs.exists(pCur) then
          fs.makeDirectory(pCur)
        end
      end
    end
  end

  local file = io.open(name, "wb")

  if not file then
    return false
  end

  file:write(data)
  file:close()

  return true
end

print("Downloading " .. application)

local termW, termH, _, _, _, termY = term.getViewport()
term.setCursor(1, termY)

if termY + 5 >= termH then
  termY = termH - 5

  for _ = 1, 5 do
    print("")
  end
end

local step = 100 / #dlTbl
local percent = 0
local barMlen = (termW - 8)
local cstep = barMlen / 100

term.setCursor(1, termY + 2)
term.write(string.format("% 5.1f%% ", percent) .. string.rep("░", barMlen))

for _, pk in pairs(dlTbl) do
  term.setCursor(1, termY + 3)
  term.clearLine()
  term.write(pk.file)

  local webData = internet.request(pk.link)

  if not webData then
    term.setCursor(1, termY + 5)
    io.stderr:write("Error while downloading " .. pk.link)

    return
  end

  local content = ""

  for chunk in webData do
    content = content .. chunk
  end

  if not writeFile(content, pk.file) then
    term.setCursor(1, termY + 5)
    io.stderr:write("Error while writing " .. pk.file)

    return
  end

  percent = percent + step
  term.setCursor(1, termY + 2)

  local barLen = math.floor(percent * cstep + 0.5)
  term.write(string.format("%5.1f%% ", percent) .. string.rep("█", barLen) .. string.rep("░", barMlen - barLen))
end

term.setCursor(1, termY + 5)
print("Done")
