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

after_clean(function(target)
    os.tryrm("$(buildir)")
    os.tryrm("$(tmpdir)")
end)
