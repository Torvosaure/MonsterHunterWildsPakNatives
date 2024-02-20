package("reframework-api")
    add_urls("https://github.com/praydog/REFramework.git")

    on_install(function(package)
        os.cp(path.join("include", "*"), package:installdir("include"))
    end)
package_end()

package("reframework-sdk-mhrise")
    add_urls("https://github.com/praydog/REFramework.git")

    add_deps("cmake", { private = true })

    on_load(function(package)
        package:add("deps", "glm bf71a834948186f4097caa076cd2663c69a10e1e")
        package:add("deps", "reframework-api " .. package:version_str())
        package:add("deps", "reframework-utility " .. package:version_str())
        package:add("deps", "spdlog 069a2e8fc947f63855d770fdc3c3eb427f19988f", { configs = { header_only = false } })

        package:add("defines", "MHRISE", "REENGINE_AT", "REENGINE_PACKED")
    end)

    on_install(function(package)
        if package:config("vs_runtime"):startswith("MD") then
            io.replace("cmake.toml", "set(CMAKE_MSVC_RUNTIME_LIBRARY \"MultiThreaded$<$<CONFIG:Debug>:Debug>\")", "set(CMAKE_MSVC_RUNTIME_LIBRARY \"MultiThreaded$<$<CONFIG:Debug>:Debug>DLL\")", { plain = true })
        end

        local config = package:debug() and "Debug" or "Release"

        import("package.tools.cmake").build(package, configs, { target = "MHRISESDK", config = config, cmake_generator = "Visual Studio 17 2022", cmake_build = true })

        os.cp("shared\\sdk\\**.hpp", package:installdir("include"), { rootdir = "shared" })
        os.cp(path.join(package:buildir(), config, "MHRISESDK.*"), package:installdir("lib"))
    end)
package_end()

package("reframework-utility")
    add_urls("https://github.com/praydog/REFramework.git")

    add_deps("cmake", { private = true })

    on_load(function(package)
        package:add("deps", "kananlib main")
        package:add("deps", "minhook 98b74f1fc12d00313d91f10450e5b3e0036175e3")
        package:add("deps", "spdlog 069a2e8fc947f63855d770fdc3c3eb427f19988f", { configs = { header_only = false } })
    end)

    on_install(function(package)
        if package:config("vs_runtime"):startswith("MD") then
            io.replace("cmake.toml", "set(CMAKE_MSVC_RUNTIME_LIBRARY \"MultiThreaded$<$<CONFIG:Debug>:Debug>\")", "set(CMAKE_MSVC_RUNTIME_LIBRARY \"MultiThreaded$<$<CONFIG:Debug>:Debug>DLL\")", { plain = true })
        end

        local config = package:debug() and "Debug" or "Release"

        import("package.tools.cmake").build(package, configs, { target = "utility", config = config, cmake_generator = "Visual Studio 17 2022", cmake_build = true })

        os.cp("shared\\utility\\**.hpp", package:installdir("include"), { rootdir = "shared" })
        os.cp(path.join(package:buildir(), config, "utility.*"), package:installdir("lib"))
    end)
package_end()

package("kananlib")
    add_urls("https://github.com/cursey/kananlib.git")

    add_deps("cmake", { private = true })

    on_load(function(package)
        package:add("deps", "bddisasm v1.34.10")

        package:add("syslinks", "shlwapi")
    end)

    on_install(function(package)
        local config = package:debug() and "Debug" or "Release"

        local configs = {}

        import("package.tools.cmake").build(package, configs, { config = config, cmake_generator = "Visual Studio 17 2022", cmake_build = true })

        os.cp(path.join("include", "*"), package:installdir("include"))
        os.cp(path.join(package:buildir(), config, "kananlib*.*"), package:installdir("lib"))
    end)
package_end()

package("bddisasm")
    set_urls("https://github.com/bitdefender/bddisasm.git")

    add_deps("cmake", { private = true })
    add_deps("ninja", { private = true })

    on_install(function(package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        import("package.tools.cmake").install(package, configs, { cmake_generator = "Ninja" })

        os.mv(package:installdir("include", "bddisasm", "*"), package:installdir("include"))
        os.rm(package:installdir("include", "bddisasm"))
    end)
package_end()
