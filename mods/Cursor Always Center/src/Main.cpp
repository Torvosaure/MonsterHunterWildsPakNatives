#include <bit>
#include <reframework/API.hpp>

int pre_fn(int argc, void **argv, REFrameworkTypeDefinitionHandle *arg_tys, unsigned long long ret_addr)
{
    auto vm_context = reframework::API::get()->get_vm_context();

    const auto scene_manager = reframework::API::get()->get_native_singleton("via.SceneManager");
    const auto scene_manager_type = reframework::API::get()->tdb()->find_type("via.SceneManager");

    const auto get_main_view = scene_manager_type->find_method("get_MainView()");
    const auto main_view = get_main_view->call<reframework::API::ManagedObject *>(vm_context, scene_manager);

    auto get_window_size_invoke_result = main_view->invoke("get_WindowSize()", {});
    float *size_invoke = (float *)&get_window_size_invoke_result;

    long x = std::bit_cast<long>(size_invoke[0] / 2);
    long y = std::bit_cast<long>(size_invoke[1] / 2);

    long long xy = (static_cast<long long>(y) << 0x20) | (x & 0xFFFFFFFF);

    const auto obj = (reframework::API::ManagedObject *)argv[1];
    *obj->get_field<long long>("_mos_BackupViewCursorPosition") = xy;
    *obj->get_field<bool>("_mos_Backup_isMouseCursor") = true;

    return REFRAMEWORK_HOOK_SKIP_ORIGINAL;
}

void post_fn(void **ret_val, REFrameworkTypeDefinitionHandle ret_ty, unsigned long long ret_addr)
{
}

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
    reframework::API::get()
        ->tdb()
        ->find_method("snow.StmInputManager.InGameInputDevice", "backupMouseCursorPosition()")
        ->add_hook(pre_fn, post_fn, false);

    return true;
}
