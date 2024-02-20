includes("..\\..\\deps\\xmake.lua")

add_requires("reframework-api master")

target("CursorAlwaysCenter")
    set_kind("shared")
    add_files("src\\**.cpp")
    add_packages("reframework-api")

    on_package(function(target)
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
