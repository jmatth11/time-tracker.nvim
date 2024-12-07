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

function M.format_time_info(result, info)
    local yr = math.floor(info.yr)
    local week = math.floor(info.week)
    local day = math.floor(info.day)
    local hr = math.floor(info.hr)
    local min = math.floor(info.min)
    local sec = math.floor(info.sec)
    if yr > 0 then
        table.insert(result, string.format("\tyr: %d", yr))
    end
    if week > 0 then
        table.insert(result, string.format("\tweek: %d", week % 52))
    end
    if day > 0 then
        table.insert(result, string.format("\tday: %d", day % 7))
    end
    if hr > 0 then
        table.insert(result, string.format("\thr: %d", hr % 24))
    end
    if min > 0 then
        table.insert(result, string.format("\tmin: %d", min % 60))
    end
    if sec > 0 then
        table.insert(result, string.format("\tsec: %d", sec % 60))
    end
    return result
end

function M.format_contents(time_info, opts)
    local contents = {}
    table.insert(contents, "Total Time:")
    contents = M.format_time_info(contents, time_info.total)
    table.insert(contents, "Active Time:")
    contents = M.format_time_info(contents, time_info.active)
    table.insert(contents, "Today's Total Time:")
    contents = M.format_time_info(contents, time_info.today.total)
    table.insert(contents, "Today's Active Time:")
    contents = M.format_time_info(contents, time_info.today.active)
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
    local contents = M.format_contents(time_info)
    if contents == nil then
        contents = {}
    end
    tracker_win_id = window.win_id
    tracker_bufnr = window.bufnr
    vim.api.nvim_buf_set_keymap(
        tracker_bufnr,
        "n",
        "q",
        "<Cmd>lua require('time-tracker').time_info()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        tracker_bufnr,
        "n",
        "<ESC>",
        "<Cmd>lua require('time-tracker').time_info()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        tracker_bufnr,
        "n",
        "<ENTER>",
        "za",
        { silent = true }
    )
    vim.api.nvim_buf_set_lines(tracker_bufnr, 0, #contents, false, contents)
    vim.api.nvim_set_option_value(
        "readonly",
        true,
        {buf = tracker_bufnr}
    )
    vim.api.nvim_set_option_value(
        "foldmethod",
        "indent",
        {win = tracker_win_id}
    )
    vim.api.nvim_set_option_value(
        "foldlevel",
        0,
        {win = tracker_win_id}
    )
end

return M
