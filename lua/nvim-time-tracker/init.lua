local time = require("nvim-time-tracker.time")

local start_time = os.time()

local function get_time_diff()
    local current_time = os.time()
    local time_info = time.extract_time_info(os.difftime(current_time, start_time))
    print(vim.inspect(time_info))
end

return {
    get_time_diff = get_time_diff
}
