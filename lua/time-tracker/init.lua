local proc = require("time-tracker.procedure")

local M = {
    nid = vim.api.nvim_create_namespace("time-tracker.nvim.namespace")
}
local main_proc = proc:new()

function M.time_info()
    print(vim.inspect(main_proc:time_info()))
end

function M.update()
    main_proc:update()
end

function M.setup(opts)
    if opts ~= nil then
        if opts["timer_delay"] ~= nil then
            main_proc.timer_delay = opts.timer_delay
        end
    end
    vim.on_key(function()
        main_proc:debounce_timer()
    end,
    M.nid)
end

return M
