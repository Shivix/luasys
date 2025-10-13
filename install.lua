function App(app)
    if arg[1] and app.name ~= arg[1] then
        return
    end
    local dir = "/tmp/luasys_install_" .. app.name
    local depth = "--depth=1"
    if app.full_depth then
        depth = "--single-branch"
    end
    local branch = app.branch or "master"
    if os.execute("test -d " .. dir) then
        assert(os.execute(string.format("git -C %q pull", dir)))
    else
        assert(
            os.execute(
                string.format("git clone --branch %q %s %q %q", branch, depth, app.repo, dir)
            )
        )
    end
    if app.diff then
        -- If we provide the filename as an arg, it will try to find the file relative to dir.
        assert(os.execute(string.format("git -C %q apply <%q", dir, app.diff)))
    end
    if app.cargo then
        assert(os.execute(string.format("cargo install --path %q", dir)))
        if not app.make_target then
            return
        end
    end

    local make_cmd = string.format("sudo make %s --directory %q", app.make_target or "install", dir)
    if app.make_args then
        make_cmd = make_cmd .. " " .. app.make_args
    end
    assert(os.execute(make_cmd))
end

dofile("apps.lua")
