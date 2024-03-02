local tracker = require("time-tracker.tracker")
local time = require("time-tracker.time")
local M = {}

-- timer delay set to 5 minute
local timer_delay = 1000 * 60 * 5

function M:new(o)
    local obj = o or { timer = nil, timer_delay = timer_delay }
    self.__index = self
    return setmetatable(obj, self)
end

function M:debounce_timer()
    -- check if timer exists
    if self.timer ~= nil then
        -- cancel timer
        self.timer:stop()
    end
    -- (re)create and start timer
    self.timer = vim.defer_fn(function()
        tracker.set_inactive()
        vim.notify("inactive")
    end, self.timer_delay)
end

function M:time_info()
    return {
        total = time.extract_time_info(tracker.data.total),
        active = time.extract_time_info(tracker.data.active),
    }
end

function M:update()
    tracker.update()
    tracker.save_data()
end

return M
