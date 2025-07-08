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
    branch = "master",
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
    branch = "master",
}

App {
    name = "lualib",
    repo = "https://github.com/Shivix/lualib.git",
    branch = "master",
}

App {
    name = "sent",
    repo = "https://git.suckless.org/sent",
    branch = "master",
    diff = "diffs/sent.diff",
}

App {
    name = "farbfeld",
    repo = "https://git.suckless.org/farbfeld",
    branch = "master",
}
