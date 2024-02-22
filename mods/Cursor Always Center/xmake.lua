add_requires("reframework-api master")

target("CursorAlwaysCenter")
    set_kind("shared")
    add_files("src\\**.cpp")
    add_packages("reframework-api")

    on_package(function(target)
        import("core.project.task").run("on_package", {}, target)
    end)
