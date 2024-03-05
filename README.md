# time-tracker.nvim

This is a simple plugin for tracking time inside of neovim.

Currently it tracks total and active time. The active status is flipped after 2 minutes of no key presses.

## Install

packer:
```lua
use("jmatth11/time-tracker.nvim")
```

## Usage:

Inside you main lua file (or an init file) place this piece of code to accept all defaults.

```lua
require("time-tracker").setup()
```

For setting custom active timer delay (delay is in milliseconds):

```lua
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

## License

MIT

