local file = require("time-tracker.file")

-- capture time from initial load.
local loaded_time = os.time()

-- setup defaults
local M = {
    data= {
        initial_time = loaded_time,
        total = 0,
        active = 0,
        today = {
            initial_time = loaded_time,
            total = 0,
            active = 0,
        }
    },
    last_total = loaded_time,
    last_active = loaded_time,
    dormant = false,
}

local function compare_date(d1, d2)
    d1 = os.date("*t", d1)
    return d1.day == d2.day and d1.month == d2.month and d1.year == d2.year
end

local function check_today_tracker(today)
    local time = os.time()
    local now = os.date("*t", time)
    local obj = today or {
        initial_time = time,
        total = 0,
        active = 0,
    }
    -- reset day if it's a different day
    if not compare_date(obj.initial_time, now) then
        obj.initial_time = time
        obj.total = 0
        obj.active = 0
    end
    return obj
end

-- Load data from the tracker file
function M.load_data()
    local obj = file.read_tracker_file()
    if obj ~= nil then
        M.data = obj
        M.data.today = check_today_tracker(M.data.today)
    end
end

-- Save data to the tracker file
function M.save_data()
    file.write_to_tracker_file(M.data)
end

-- Update time info values.
function M.update()
    local now = os.time()
    M.data.total = M.data.total + (os.difftime(now, M.last_total))
    M.data.today.total = M.data.today.total + (os.difftime(now, M.last_total))
    if not M.dormant then
        M.data.active = M.data.active + (os.difftime(now, M.last_active))
        M.data.today.active = M.data.today.active + (os.difftime(now, M.last_active))
    end
    -- set times to new "last updated"
    M.last_total = now
    M.last_active = now
end

-- Set the active status and set last active.
function M.set_active()
    M.dormant = false
    M.last_active = os.time()
end

-- Set the inactive status.
function M.set_inactive()
    M.update()
    M.dormant = true
end

-- load all data
M.load_data()

return M
