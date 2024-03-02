local file = require("time-tracker.file")

local loaded_time = os.time()

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

function M.load_data()
    local obj = file.read_tracker_file()
    if obj ~= nil then
        M.data = obj
    end
end

function M.save_data()
    file.write_to_tracker_file(M.data)
end

function M.update()
    M.total = M.total + (os.difftime(os.time(), M.loaded_time))
    if not M.dormant then
        M.data.active = M.data.active + (os.difftime(os.time(), M.last_active))
    end
end

function M.set_active()
    M.dormant = false
    M.last_active = os.time()
end

function M.set_inactive()
    M.update()
    M.dormant = true
end

M.load_data()

return M
