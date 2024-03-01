
local M = {}

local function native_separator()
    if vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1 then
        return "\\"
    end
    return "/"
end

M.data_path = vim.fn.stdpath("data")
M.path_sep = native_separator()

function M.grab_or_create_file()
    local f = io.open(M.data_path .. M.path_sep .. "tmp_file", "r+")
    if f ~= nil then
        return f
    else
        vim.notify("could not open data file for nvim-time-tracker", vim.log.levels.ERROR)
    end
end

return M
