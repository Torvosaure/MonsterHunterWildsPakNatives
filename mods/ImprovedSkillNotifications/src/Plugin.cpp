#include <reframework/API.hpp>

#include "ChatManager.hpp"
#include "HookManager.hpp"
#include "Namespaces.hpp"

extern "C" __declspec(dllexport) void reframework_plugin_required_version(REFrameworkPluginVersion *version)
{
    version->major = REFRAMEWORK_PLUGIN_VERSION_MAJOR;
    version->minor = REFRAMEWORK_PLUGIN_VERSION_MINOR;
    version->patch = REFRAMEWORK_PLUGIN_VERSION_PATCH;

    version->game_name = "MHRISE";
}

extern "C" __declspec(dllexport) bool reframework_plugin_initialize(const REFrameworkPluginInitializeParam *param)
{
    reframework::API::initialize(param);

    Namespaces::mhrise::initialize();
    ChatManager::initialize();
    HookManager::initialize();

    HookManager::get()->add_hook();

    return true;
}
