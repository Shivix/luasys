local M = {}

local build = {
    make = 1,
    container = 2,
    cargo = 3,
    zig = 4,
    luarocks = 5,
}

M.build = build

return M
