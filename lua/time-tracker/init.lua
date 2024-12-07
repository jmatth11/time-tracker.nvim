local proc = require("time-tracker.procedure")

local M = {
    nid = vim.api.nvim_create_namespace("time-tracker.nvim.namespace")
}
local main_proc = proc:new()

vim.on_key(function()
    main_proc:debounce_timer()
end,
M.nid)

function M.time_info()
    print(vim.inspect(main_proc:time_info()))
end

function M.update()
    main_proc:update()
end

return M
