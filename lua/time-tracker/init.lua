local proc = require("time-tracker.procedure")
local ui = require("time-tracker.ui")

local namespace = "time-tracker.nvim.namespace"
local autogroup = "time-tracker.nvim.group"

local M = {
    nid = vim.api.nvim_create_namespace(namespace)
}
local main_proc = proc:new()

-- Inspect the time info for debug purposes.
function M.time_info_debug()
    print(vim.inspect(main_proc:time_info()))
end

function M.time_info()
    ui.toggle_window(main_proc:time_info())
end

-- Force an update
function M.update()
    main_proc:update()
end

-- Setup the main functionality of tracking.
-- @param opts This is a table of options.
--      opt["timer_delay"] - customize how long the delay before setting inactive status.
function M.setup(opts)
    if opts ~= nil then
        if opts["timer_delay"] ~= nil then
            main_proc.timer_delay = opts.timer_delay
        end
        if opts["silent"] ~= nil then
            main_proc.silent = opts.silent
        end
    end
    -- listen for every key press so we can debounce the update function
    vim.on_key(function()
        main_proc:debounce_timer()
    end,
    M.nid)
    -- create our autocommand to save off data if we leave vim
    vim.api.nvim_create_augroup(autogroup, {clear = true})
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = autogroup,
        callback = function()
            main_proc:update()
        end
    })
    -- start the timer
    main_proc:debounce_timer()
end

return M
