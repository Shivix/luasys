local luasys = require("luasys")
local build = luasys.build

local function prepare_repo_source(app, dir)
    local branch = app.branch or "master"
    local depth = "--depth=1"
    if app.full_depth then
        depth = "--single-branch"
    end
    if os.execute("test -d " .. dir) then
        assert(os.execute(string.format("git -C %q restore .", dir)))
        assert(os.execute(string.format("git -C %q pull", dir)))
    else
        assert(
            os.execute(
                string.format("git clone --branch %q %s %q %q", branch, depth, app.repo, dir)
            )
        )
    end
end

local function prepare_curl_source(app, dir)
    -- TODO: Consider a custom execute command with extra logging? builtin format? lualib?
    local curl = assert(io.popen(string.format("curl -fLO -w '%%{filename_effective}' %q", app.curl)))
    local file = curl:read("*all")
    assert(os.execute(string.format("mkdir -p %q", dir)))
    assert(os.execute(string.format("tar xvf %q --strip-components=1 -C %q", file, dir)))
    assert(os.execute(string.format("rm %q", file)))
end

function App(app)
    if arg[1] and app.name ~= arg[1] then
        return
    end

    -- Consider passing in helpful values, e.g. temp file name
    if app.custom then
        app.custom()
        return
    end

    -- Allow specifying a non temporary path. Useful for things that take a long time to build but support incremental/ cached builds.
    local dir = app.path or ("/tmp/luasys_install_" .. app.name)
    dir = dir:gsub("^~", assert(os.getenv("HOME")))
    if app.repo then
        prepare_repo_source(app, dir)
    end
    if app.curl then
        prepare_curl_source(app, dir)
    end
    if app.diff then
        -- git apply works outside of git repos.
        -- If we provide the filename as an arg, it will try to find the file relative to dir.
        local apply_cmd = string.format("git -C %q apply --check <%q", dir, app.diff)
        if os.execute(apply_cmd) then
            assert(os.execute(string.format("git -C %q apply <%q", dir, app.diff)))
        end
    end

    if app.build == build.cargo then
        assert(os.execute(string.format("cargo install --path %q", dir)))
    -- Only supports make.
    elseif app.build == build.container then
        local container_name = "luasys-" .. app.name .. "-build"
        local build_image = "luasys-void:latest"
        local build_cmd = string.format(
            "podman run --rm --name %q -v %q:/src -v ./out:/out -w /src --entrypoint /bin/sh %q -lc %q",
            container_name,
            dir,
            build_image,
            "make && make install DESTDIR=/out PREFIX=/usr/local"
        )

        assert(os.execute("mkdir -p out"))
        assert(os.execute(build_cmd))

        print("\27[91mThe following will be installed to /usr/local:\27[0m")
        assert(os.execute("tree out/usr/local"))

        assert(os.execute("sudo cp -r out/usr/local/* /usr/local/"))

        assert(os.execute("rm -r out"))
    elseif app.build == build.zig then
        assert(os.execute(string.format("cd %q; zig build -Doptimize=ReleaseFast", dir)))
        assert(
            os.execute(
                -- TODO: zig install? Non binaries?
                string.format("cd %q; sudo mv -i zig-out/bin/* /usr/local/bin/", dir, app.name)
            )
        )
    elseif app.build == build.luarocks then
        -- TODO: Could use --tree for a distdir thing on container.
        assert(os.execute(string.format("luarocks --lua-version=5.5 --tree=/usr/local install %q", app.name)))
    elseif app.build == build.make or app.build == nil then
        -- TODO: CD into dir
        if app.configure then
            assert(os.execute(string.format("%q/configure", dir)))
        end
        local make_cmd =
            string.format("sudo make -j8 install --directory %q", dir)
        if app.make_args then
            make_cmd = make_cmd .. " " .. app.make_args
        end
        assert(os.execute(make_cmd))
    else
        error("invalid build type: ", app.build)
    end

    if app.extra then
        assert(os.execute(string.format("cd %q; " .. app.extra, dir)))
    end
end

dofile("apps.lua")
