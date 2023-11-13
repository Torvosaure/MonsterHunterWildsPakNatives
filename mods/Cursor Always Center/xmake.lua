set_project("Cursor Always Center")

set_languages("cxx20")
set_plat("windows")
set_arch("x64")

set_strip("all")
set_symbols("hidden")
set_optimize("fastest")
set_runtimes("MD")

target("CursorAlwaysCenter")
    set_kind("shared")
    add_files("src/**.cpp")
    add_includedirs("../../deps/REFramework/include")
