local popup = require("plenary.popup")

local M = {}

local tracker_win_id = nil
local tracker_bufnr = nil

local function create_window()
    local width = 60
    local height = 10
    local border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = vim.api.nvim_create_buf(false, false)
    local win_id, win = popup.create(bufnr, {
        title = "Time Tracker",
        hightlight = "timeTrackerWindow",
        line = vim.o.lines - height - 5,
        col = vim.o.columns - width - 5,
        minwidth = width,
        minheight = height,
        borderchars = border_chars,
    })
    vim.api.nvim_set_option_value(
        "winhl",
        "Normal:timeTrackerWindow",
        {win = win.border.win_id}
    )
    vim.api.nvim_set_option_value(
        "readonly",
        true,
        {buf = bufnr}
    )
    vim.api.nvim_set_option_value(
        "filetype",
        "time-tracker",
        {buf = bufnr}
    )
    vim.api.nvim_set_option_value(
        "bufhidden",
        "delete",
        {buf = bufnr}
    )
    vim.api.nvim_set_option_value(
        "buftype",
        "nofile",
        {buf = bufnr}
    )
    return {
        bufnr = bufnr,
        win_id = win_id
    }
end

function M.format_time_info(info, sep)
    local result = ""
    if info.yr > 0 then
        result = result .. string.format("yr: %f" .. sep, info.yr)
    end
    if info.week > 0 then
        result = result .. string.format("week: %f" .. sep, info.week)
    end
    if info.day > 0 then
        result = result .. string.format("day: %f" .. sep, info.day)
    end
    if info.hr > 0 then
        result = result .. string.format("hr: %f" .. sep, info.hr)
    end
    if info.min > 0 then
        result = result .. string.format("min: %f" .. sep, info.min)
    end
    if info.sec > 0 then
        result = result .. string.format("sec: %f" .. sep, info.sec)
    end
end

function M.format_contents(time_info, opts)
    local sep = " "
    if opts ~= nil then
        if opts["sep"] ~= nil then
            sep = opts.sep
        end
    end
    local contents = {}
    table.insert(contents, string.format("Total Time: %s", M.format_time_info(time_info.total, sep)))
    table.insert(contents, string.format("Active Time: %s", M.format_time_info(time_info.active, sep)))
    return contents
end

function M.toggle_window(time_info)
    if tracker_win_id ~= nil then
        vim.api.nvim_win_close(tracker_win_id, true)
        tracker_win_id = nil
        tracker_bufnr = nil
        return
    end
    local window = create_window()
    local contents = M.format_time_info(time_info)
    if contents == nil then
        contents = {}
    end
    tracker_win_id = window.win_id
    tracker_bufnr = window.bufnr
    vim.api.nvim_buf_set_keymap(
        tracker_bufnr,
        "n",
        "q",
        "<Cmd>lua require('time-tracker').toggle_window()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        tracker_bufnr,
        "n",
        "<ESC>",
        "<Cmd>lua require('time-tracker').toggle_window()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_lines(tracker_bufnr, 0, #contents, false, contents)
end

return M