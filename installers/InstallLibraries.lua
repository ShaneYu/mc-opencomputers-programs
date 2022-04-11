-- modular code
local application = "ShadowRealm Libraries"
local dlTbl = {
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/core/classify.lua",
    file = "/usr/lib/shadowrealm/core/classify.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/config.lua",
    file = "/usr/lib/shadowrealm/config.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/JSON.lua",
    file = "/usr/lib/JSON.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/stringBuilder.lua",
    file = "/usr/lib/shadowrealm/stringBuilder.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/mixins/serializable.lua",
    file = "/usr/lib/shadowrealm/mixins/serializable.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/mixins/stateful.lua",
    file = "/usr/lib/shadowrealm/mixins/stateful.lua"
  },
  {
    link = "https://raw.githubusercontent.com/ShaneYu/mc-opencomputers-programs/master/libraries/mixins/tableUtils.lua",
    file = "/usr/lib/shadowrealm/mixins/tableUtils.lua"
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
