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
    local result = os.execute(
        string.format(
            "git clone --single-branch --branch %q %s %q %q",
            branch,
            depth,
            app.repo,
            dir
        )
    )
    if result == nil then
        os.execute(string.format("git -C %q pull", dir))
    end
    if app.diff then
        os.execute(string.format("git -C %q apply <%q ", dir, app.diff))
    end
    local make_cmd = "sudo make install --directory " .. dir
    if app.make_args then
        make_cmd = make_cmd .. " " .. app.make_args
    end
    os.execute(make_cmd)
end

dofile("apps.lua")
