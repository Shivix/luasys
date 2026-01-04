App = App
    or function(app)
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
    make_args = "CMAKE_BUILD_TYPE=Release",
}

App {
    name = "zig",
    custom = function()
        local curl <close> = assert(
            io.popen(
                [[curl -fsSL https://ziglang.org/download/index.json | jq -r '.master["x86_64-linux"].tarball']]
            )
        )
        local curl_url = curl:read("*all")
        local untar_dir = "zig_release"
        assert(os.execute(string.format("curl %q -o %q", curl_url, untar_dir)))
        local dir_name = curl_url:match("([^/]+).tar.xz")
        assert(
            os.execute(
                string.format("tar -xJf %q %q/zig --strip-components=1", untar_dir, dir_name)
            )
        )
        assert(
            os.execute(
                string.format("tar -xJf %q %q/lib --strip-components=1", untar_dir, dir_name)
            )
        )
        assert(os.execute("sudo mv -i zig /usr/local/bin/zig"))
        assert(os.execute("sudo mv -i lib /usr/local/lib/zig"))
        assert(os.execute(string.format("rm %q", untar_dir)))
    end,
}

App {
    name = "zls",
    repo = "https://github.com/zigtools/zls.git",
    zig = true,
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
