local tracker = require("time-tracker.tracker")
local time = require("time-tracker.time")
local M = {}

-- timer delay set to 2 minute
local timer_delay = 1000 * 60 * 2

-- Create a new procedure object to manage time tracking.
function M:new(o)
    local obj = o or { timer = nil, timer_delay = timer_delay, silent = true }
    self.__index = self
    return setmetatable(obj, self)
end

-- Debounce the timer for setting inactive status.
function M:debounce_timer()
    -- if we are dormant set back to active
    if tracker.dormant then
        tracker.set_active()
    end
    -- check if timer exists
    if self.timer ~= nil then
        -- cancel timer
        self.timer:stop()
    end
    -- (re)create and start timer
    self.timer = vim.defer_fn(function()
        tracker.set_inactive()
        if not self.silent then
            vim.notify("inactive")
        end
    end, self.timer_delay)
end

-- Update the time info and return it.
-- @returns Table with time info
function M:time_info()
    tracker.update()
    return {
        total = time.extract_time_info(tracker.data.total),
        active = time.extract_time_info(tracker.data.active),
        today = {
            total = time.extract_time_info(tracker.data.today.total),
            active = time.extract_time_info(tracker.data.today.active),
        }
    }
end

-- Update and save time info.
function M:update()
    tracker.update()
    tracker.save_data()
end

return M
