local M = {}

-- Safe gaurd against divide by zero
local function safe_divide(value, div)
    if value >= 1 then
        return value/div
    end
    return 0
end

-- Convert time elapsed into useful time info.
-- @params Time elapsed in seconds
-- @returns Table
--      {
--          sec,
--          min,
--          hr,
--          day,
--          week,
--          yr
--      }
function M.extract_time_info(t)
    local sec = t
    local min = safe_divide(sec, 60)
    local hr = safe_divide(min, 60)
    local day = safe_divide(hr, 24)
    local week = safe_divide(day, 7)
    local yr = safe_divide(week, 52)
    return {
        sec = sec,
        min = min,
        hr = hr,
        day = day,
        week = week,
        yr = yr,
    }
end

return M
