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
        win_id = win_id,
    }
end

function M.toggle_window(time_info)
    if tracker_win_id ~= nil then
        vim.api.nvim_win_close(tracker_win_id, true)
        tracker_win_id = nil
        tracker_bufnr = nil
    end
    local window = create_window()
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
    -- TODO set contents to time info
    vim.api.nvim_buf_set_lines(tracker_bufnr, 0, #contents, false, contents)
end

return M
