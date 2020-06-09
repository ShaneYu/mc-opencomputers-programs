local TableUtils = {}

function TableUtils:isNilOrEmpty(tbl)
  return not tbl or next(tbl) == nil
end

return TableUtils
