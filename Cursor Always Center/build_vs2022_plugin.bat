cmake -G "Visual Studio 17 2022" -A x64 -S . -B build64_plugin
cmake --build build64_plugin --config Release --target cursor_always_center
