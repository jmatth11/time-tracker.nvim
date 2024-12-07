local proc = require("time-tracker.nvim.procedure")

local M = {
    nid = vim.api.nvim_create_namespace("time-tracker.nvim.namespace")
}
local main_proc = proc:new()

vim.on_key(function()
    main_proc:debounce_timer()
end,
M.nid)

return M
