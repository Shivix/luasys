App = App or function(app)
    local env = { app = app }
    setmetatable(env, {
        __index = _ENV,
    })
    local func = assert(load(table.concat(arg, " "), "chunk", "t", env))
    func(app)
end

App {
    name = "neovim",
    repo = "https://github.com/neovim/neovim.git",
    full_depth = true,
    make_args = "CMAKE_BUILD_TYPE=RelWithDebInfo",
}

App {
    name = "zua",
    repo = "https://github.com/Shivix/zua.lua.git",
    branch = "simple",
}

App {
    name = "lus",
    repo = "https://github.com/Shivix/lus.git",
}

App {
    name = "lualib",
    repo = "https://github.com/Shivix/lualib.git",
}

App {
    name = "dwm",
    repo = "https://git.suckless.org/dwm",
    diff = "diffs/dwm.diff",
}

App {
    name = "dmenu",
    repo = "https://git.suckless.org/dmenu",
    diff = "diffs/dmenu.diff",
}

App {
    name = "sent",
    repo = "https://git.suckless.org/sent",
    diff = "diffs/sent.diff",
}

App {
    name = "farbfeld",
    repo = "https://git.suckless.org/farbfeld",
}

App {
    name = "prefix",
    repo = "https://github.com/Shivix/prefix.git",
    cargo = true,
    make_target = "install-fish",
}
