# time-tracker.nvim

This is a simple plugin for tracking time inside of neovim. I wanted an offline solution for tracking time so I decided to create this plugin.

Currently it tracks overall total and active time and the current day's total and active time. The active status is flipped after 2 minutes of no key presses.

## Install

packer:
```lua
-- plenary is a used so is currently a requirement
use("nvim-lua/plenary.nvim")

use("jmatth11/time-tracker.nvim")
```

## Usage:

Inside you main lua file (or an init file) place this piece of code to accept all defaults.

```lua
require("time-tracker").setup()
```

For setting custom active timer delay (delay is in milliseconds):

```lua
-- set inactivity to 5 seconds after no key presses
require("time-tracker").setup({timer_delay = 1000 * 5 })
```

To toggle the display of the time info panel.

```lua
require("time-tracker").time_info()
```

## Preview


https://github.com/jmatth11/time-tracker.nvim/assets/5776125/19dad0c9-bdb6-4b30-a6da-840c7c681a1b


## TODOs

- [ ] Add ability to track activity per file.
- [ ] Make UI prettier
  - [ ] Make time info on an indented line under each section
  - [ ] Add foldable sections for readability

## License

MIT

