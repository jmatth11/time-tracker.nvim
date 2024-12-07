local tracker = require("time-tracker.tracker")
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
    self.timer = vim.defer_fn(tracker.set_inactive, self.timer_delay)
end

return M
