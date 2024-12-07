local file = require("time-tracker.file")

-- capture time from initial load.
local loaded_time = os.time()

-- setup defaults
local M = {
    data= {
        initial_time = loaded_time,
        total = 0,
        active = 0,
    },
    loaded_time = loaded_time,
    last_active = loaded_time,
    dormant = false,
}

-- Load data from the tracker file
function M.load_data()
    local obj = file.read_tracker_file()
    if obj ~= nil then
        M.data = obj
    end
end

-- Save data to the tracker file
function M.save_data()
    file.write_to_tracker_file(M.data)
end

-- Update time info values.
function M.update()
    M.data.total = M.data.total + (os.difftime(os.time(), M.loaded_time))
    if not M.dormant then
        M.data.active = M.data.active + (os.difftime(os.time(), M.last_active))
    end
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
