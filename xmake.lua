includes(path.join("deps", "xmake.lua"))

includes("mods\\Cursor Always Center\\xmake.lua")
includes("mods\\Test\\xmake.lua")

set_project(path.filename(os.projectdir()))

set_languages("cxx20")
set_plat("windows")
set_arch("x64")
add_rules("mode.release", "mode.releasedbg","mode.debug")

set_allowedplats("windows")
set_allowedarchs("x64")
set_allowedmodes("release", "releasedbg", "debug")

if is_mode("release") then
    set_strip("all")
    set_symbols("hidden")
    set_optimize("fastest")
    set_runtimes("MD")
    set_policy("build.optimization.lto", true)
    set_warnings("allextra", "error")
elseif is_mode("releasedbg") then
    set_strip("all")
    set_symbols("debug")
    set_optimize("fastest")
    set_runtimes("MDd")
    set_policy("build.optimization.lto", true)
elseif is_mode("debug") then
    set_symbols("debug")
    set_optimize("none")
    set_runtimes("MDd")
    set_policy("build.optimization.lto", false)
end

task("on_package")
    on_run(function(target)
        import("utils.archive")

        local dist_path = path.join(os.projectdir(), "dist", target:name() .. ".zip")

        os.rm(dist_path)

        local tmp_dir = path.join(val("tmpdir"), ".dist")
        local plugins_dir = path.join(tmp_dir, "reframework", "plugins")

        os.mkdir(plugins_dir)
        os.cp(target:targetfile(), plugins_dir)
        archive.archive(dist_path, "reframework", { curdir = tmp_dir, compress = "best" })

        os.rm(tmp_dir)
    end)
task_end()

after_clean(function(target)
    os.tryrm("$(buildir)")
    os.tryrm("$(tmpdir)")
end)
