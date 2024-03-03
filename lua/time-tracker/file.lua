local Path = require("plenary.path")

local M = {}

-- tracker file for persisting user data
local tracker_file = "time-tracker.nvim.json"

-- Get the native separate for joining paths
local function native_separator()
    if vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1 then
        return "\\"
    end
    return "/"
end

-- grab the nvim user data directory
M.data_path = vim.fn.stdpath("data")
M.path_sep = native_separator()

-- Grab or creeate the user data file.
-- @returns File object
function M.grab_or_create_file()
    local filepath = M.data_path .. M.path_sep .. tracker_file
    local f = Path:new(filepath)
    if f ~= nil then
        return f
    else
        vim.notify("could not open data file for time-tracker.nvim", vim.log.levels.ERROR)
    end
end

-- Write the given object to the tracker file.
function M.write_to_tracker_file(obj)
    local data = vim.json.encode(obj)
    local f = M.grab_or_create_file()
    if f ~= nil then
        f:write(data)
        f:close()
    end
end

-- Read the user data from the tracker file.
-- @returns Table
function M.read_tracker_file()
    local f = M.grab_or_create_file()
    if f ~= nil then
        local data = f:read()
        -- decode file and change JSON nulls to Lua's nils for objects and arrays
        local obj = nil
        -- data will be empty on initial file creation
        if data ~= "" then
            obj = vim.json.decode(data, {object = true, array = true})
        end
        f:close()
        return obj
    end
end

return M
