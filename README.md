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

Currently I haven't implemented displaying the time info in a great format so it can be displayed in a debug format.

```lua
require("time-tracker").time_info_debug()
```

## TODOs

- [ ] Display time info in a useful format.
- [ ] Incorporate plenary to display time info.
- [ ] Add ability to track activity per file.

## License

MIT

