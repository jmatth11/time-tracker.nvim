local M = {}

local tracker_file = "time-tracker.nvim.json"

local function native_separator()
    if vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1 then
        return "\\"
    end
    return "/"
end

M.data_path = vim.fn.stdpath("data")
M.path_sep = native_separator()

function M.grab_or_create_file()
    local f = io.open(M.data_path .. M.path_sep .. tracker_file, "r+")
    if f ~= nil then
        return f
    else
        vim.notify("could not open data file for nvim-time-tracker", vim.log.levels.ERROR)
    end
end

function M.write_to_tracker_file(obj)
    local data = vim.json.encode(obj)
    local f = M.grab_or_create_file()
    if f ~= nil then
        f:write(data)
        f:close()
    end
end

function M.read_tracker_file()
    local f = M.grab_or_create_file()
    if f ~= nil then
        local data = f:read("*a")
        -- decode file and change JSON nulls to Lua's nils for objects and arrays
        local obj = nil
        if data ~= "" then
            obj = vim.json.decode(data, {object = true, array = true})
        end
        f:close()
        return obj
    end
end

return M
