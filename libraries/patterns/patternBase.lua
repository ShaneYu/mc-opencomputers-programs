local Config = require("shadowrealm/config")
local MaterialMap = require("shadowrealm/mixins/materialMap")

local PatternBase = Config:extend(MaterialMap)

function PatternBase:__init(fileName, defaults)
  Config.__init(self, fileName, defaults)
end

function PatternBase.__isNilOrEmpty(tbl)
  return not tbl or next(tbl) == nil
end

function PatternBase:isValid()
  if self.__isNilOrEmpty(self.materials) then
    return false, "Pattern is missing materials"
  end

  return true
end

return PatternBase
