#include <reframework/API.hpp>

using namespace reframework;

extern "C" __declspec(dllexport) void reframework_plugin_required_version(REFrameworkPluginVersion *version)
{
    version->major = REFRAMEWORK_PLUGIN_VERSION_MAJOR;
    version->minor = REFRAMEWORK_PLUGIN_VERSION_MINOR;
    version->patch = REFRAMEWORK_PLUGIN_VERSION_PATCH;

    version->game_name = "MHRISE";
}

extern "C" __declspec(dllexport) bool reframework_plugin_initialize(const REFrameworkPluginInitializeParam *param)
{
    API::initialize(param);

    API::get()
        ->tdb()
        ->find_method("snow.StmInputManager.InGameInputDevice", "backupMouseCursorPosition()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                const auto &api = API::get();
                auto *const tdb = api->tdb();

                auto *const vmctx = static_cast<API::VMContext *>(argv[0]);
                auto *const obj = static_cast<API::ManagedObject *>(argv[1]);

                static auto *const this_t = obj->get_type_definition();
                static auto *backup_view_cursor_position_f = this_t->find_field("_mos_BackupViewCursorPosition");
                static auto *backup_is_mouse_cursor_f = this_t->find_field("_mos_Backup_isMouseCursor");

                static auto *const scene_manager_t = tdb->find_type("via.SceneManager");
                static auto *const get_main_view_m = scene_manager_t->find_method("get_MainView()");

                static auto *const scene_view_t = tdb->find_type("via.SceneView");
                static auto *const get_window_size_m = scene_view_t->find_method("get_WindowSize()");

                auto *const main_view = get_main_view_m->call<API::ManagedObject *>(vmctx);

                std::array<float, 2> window_size{};
                get_window_size_m->call(&window_size, vmctx, main_view);

                std::array<float, 2> pos{};
                pos[0] = window_size[0] / 2.0F;
                pos[1] = window_size[1] / 2.0F;

                backup_view_cursor_position_f->get_data<std::array<float, 2>>(obj) = pos;
                backup_is_mouse_cursor_f->get_data<bool>(obj) = true;

                return REFRAMEWORK_HOOK_SKIP_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    return true;
}
