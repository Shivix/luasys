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
        assert(os.execute("sudo mv zig /usr/local/bin/zig"))
        assert(os.execute("sudo mkdir -p /usr/local/lib"))
        assert(os.execute("sudo rm -rf /usr/local/lib/zig"))
        assert(os.execute("sudo mv lib /usr/local/lib/zig"))
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
    extra = "make install-completion",
}

App {
    name = "lus",
    repo = "https://github.com/Shivix/lus.git",
    extra = "make install-skill && make install-completion",
}

App {
    name = "lualib",
    repo = "https://github.com/Shivix/lualib.git",
    -- Lua not searching in /usr/local by default.
    make_args = "PREFIX=/usr"
}

App {
    name = "dwm",
    repo = "https://git.suckless.org/dwm",
    branch = "6.8",
    diff = "diffs/dwm.diff",
    container = true,
}

App {
    name = "dmenu",
    repo = "https://git.suckless.org/dmenu",
    diff = "diffs/dmenu.diff",
    container = true,
}

App {
    name = "sent",
    repo = "https://git.suckless.org/sent",
    diff = "diffs/sent.diff",
    container = true,
}

App {
    name = "prefix",
    repo = "https://github.com/Shivix/prefix.git",
    cargo = true,
    extra = "make install-fish && sudo make install-man",
}

App {
    name = "fp",
    repo = "https://github.com/Shivix/fp.git",
    zig = true,
    extra = "make install-completion",
}

App {
    name = "luarocks",
    custom = function()
        assert(os.execute("curl -fL -o luarocks_out.tar.gz https://luarocks.org/releases/luarocks-3.13.0.tar.gz"))
        assert(os.execute("mkdir -p luarocks_out"))
        assert(os.execute("tar zxpf luarocks_out.tar.gz --strip-components=1 -C luarocks_out"))
        assert(os.execute("cd luarocks_out && ./configure && make && sudo make install"))
        assert(os.execute("rm luarocks_out.tar.gz"))
        assert(os.execute("rm -rf luarocks_out"))
    end,
}

App {
    name = "codex",
    custom = function()
        local archive = "codex.tar.gz"
        local bin_name = "codex-x86_64-unknown-linux-musl"

        local url =
            "https://github.com/openai/codex/releases/latest/download/codex-x86_64-unknown-linux-musl.tar.gz"
        assert(os.execute(string.format("curl -fL %q -o %q", url, archive)))

        assert(os.execute(string.format("tar -xzf %q %q", archive, bin_name)))

        assert(os.execute(string.format("sudo mv %q /usr/local/bin/codex", bin_name)))
        assert(os.execute("sudo chmod +x /usr/local/bin/codex"))

        assert(os.execute(string.format("rm %q", archive)))
    end,
}
