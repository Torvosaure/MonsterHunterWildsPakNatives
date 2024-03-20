#include "HookManager.hpp"

#include <reframework/API.hpp>
#include <sstream>

HookManager::HookManager()
{
    functions = std::make_unique<HookFunctions>();
}

void HookManager::initialize()
{
    s_instance = std::make_unique<HookManager>();
}

std::unique_ptr<HookManager> &HookManager::get()
{
    return s_instance;
}

void HookManager::add_hook()
{
    const auto &api = reframework::API::get();
    const auto tdb = api->tdb();

    tdb->find_method("snow.BitSetFlagBase", "on(System.UInt32)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const flag = reinterpret_cast<uint32_t *>(&argv[2]);

                HookManager::get()->functions->on_11026(vmctx, obj, *flag);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.BitSetFlagBase", "off(System.UInt32)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const flag = reinterpret_cast<uint32_t *>(&argv[2]);

                HookManager::get()->functions->off_11027(vmctx, obj, *flag);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerCondition", "updateOld()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->update_old_205404(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.Bow", "calcTimer()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->calc_timer_259659(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.Bow", "executeEquipSkill216(System.UInt32)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const lv = reinterpret_cast<uint32_t *>(&argv[2]);

                HookManager::get()->functions->execute_equip_skill216_259713(vmctx, obj, *lv);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "onDestroy()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->on_destroy_400430(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "lateUpdate()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->late_update_400432(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "calcTimer()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->calc_timer_400436(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "setKitchenBondsBuff(System.Boolean)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const is_duplicate = reinterpret_cast<bool *>(&argv[2]);

                HookManager::get()->functions->set_kitchen_bonds_buff_400571(vmctx, obj, *is_duplicate);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase",
                     "damageVital(System.Single, System.Boolean, System.Boolean, System.Boolean, System.Boolean, System.Boolean)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const damage = reinterpret_cast<float *>(&argv[2]);
                auto *const is_r_vital = reinterpret_cast<bool *>(&argv[3]);
                auto *const is_slip_damage = reinterpret_cast<bool *>(&argv[4]);
                auto *const is_guard_damage = reinterpret_cast<bool *>(&argv[5]);
                auto *const equip225_enable_damage = reinterpret_cast<bool *>(&argv[6]);
                auto *const equip225_change_damage = reinterpret_cast<bool *>(&argv[7]);

                HookManager::get()->functions->damage_vital_400600(vmctx, obj, *damage, *is_r_vital, *is_slip_damage, *is_guard_damage, *equip225_enable_damage,
                                                                   *equip225_change_damage);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "checkDamage_calcDamage(System.Single, System.Single, snow.player.PlayerDamageInfo, System.Boolean)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const damage = reinterpret_cast<float *>(&argv[2]);
                auto *const heal = reinterpret_cast<float *>(&argv[3]);
                auto *const dmi = static_cast<REManagedObject *>(argv[4]);
                auto *const is_guard_damage = reinterpret_cast<bool *>(&argv[5]);

                HookManager::get()->functions->check_damage_calc_damage_400603(vmctx, obj, *damage, *heal, dmi, *is_guard_damage);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "setCondition()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->set_condition_400615(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "setSkill_036()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->set_skill_036_400647(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "activateEquipSkill208()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->activate_equip_skill208_400665(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "activateEquipSkill231()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->activate_equip_skill231_400669(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "addEquipSkill232Absorption(System.Single)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const add = reinterpret_cast<float *>(&argv[2]);

                HookManager::get()->functions->add_equip_skill232_absorption_400748(vmctx, obj, *add);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerQuestBase", "useItem(snow.data.ContentsIdSystem.ItemId, System.Boolean)")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);
                auto *const item_id = reinterpret_cast<uint32_t *>(&argv[2]);
                auto *const is_throw = reinterpret_cast<bool *>(&argv[3]);

                HookManager::get()->functions->use_item_401117(vmctx, obj, *item_id, *is_throw);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerBase", "calcTotalAttack()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->calc_total_attack_597536(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);

    tdb->find_method("snow.player.PlayerBase", "calcTotalDefence()")
        ->add_hook(
            [](int /* argc */, void **argv, REFrameworkTypeDefinitionHandle * /* arg_tys */, unsigned long long /* ret_addr */) -> int {
                auto *const vmctx = static_cast<sdk::VMContext *>(argv[0]);
                auto *const obj = static_cast<REManagedObject *>(argv[1]);

                HookManager::get()->functions->calc_total_defence_597545(vmctx, obj);

                return REFRAMEWORK_HOOK_CALL_ORIGINAL;
            },
            [](void ** /* ret_val */, REFrameworkTypeDefinitionHandle /* ret_ty */, unsigned long long /* ret_addr */) -> void {}, false);
}
