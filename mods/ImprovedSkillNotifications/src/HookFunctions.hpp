#pragma once

#include <bitset>

#include <sdk/RETypeDB.hpp>

#include "Utils/Utils.hpp"

class HookFunctions
{
  public:
    // snow.BitSetFlagBase
    void on_11026(sdk::VMContext *vmctx, ::REManagedObject *obj, uint32_t &flag);
    // snow.BitSetFlagBase
    void off_11027(sdk::VMContext *vmctx, ::REManagedObject *obj, uint32_t &flag);

    // snow.player.PlayerCondition
    void update_old_205404(sdk::VMContext *vmctx, ::REManagedObject *obj);

    // snow.player.Bow
    void calc_timer_259659(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.Bow
    void execute_equip_skill216_259713(sdk::VMContext *vmctx, ::REManagedObject *obj, uint32_t &lv);

    // snow.player.PlayerQuestBase
    void late_update_400432(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void calc_timer_400436(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void set_kitchen_bonds_buff_400571(sdk::VMContext *vmctx, ::REManagedObject *obj, bool is_duplicate);
    // snow.player.PlayerQuestBase
    void damage_vital_400600(sdk::VMContext *vmctx, ::REManagedObject *obj, float &damage, bool is_r_vital, bool is_slip_damage, bool is_guard_damage,
                             bool equip225_enable_damage, bool equip225_change_damage);
    // snow.player.PlayerQuestBase
    void check_damage_calc_damage_400603(sdk::VMContext *vmctx, ::REManagedObject *obj, float &damage, float &heal, ::REManagedObject *dmi, bool is_guard_damage);
    // snow.player.PlayerQuestBase
    void set_condition_400615(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void set_skill_036_400647(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void activate_equip_skill208_400665(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void activate_equip_skill231_400669(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void add_equip_skill232_absorption_400748(sdk::VMContext *vmctx, ::REManagedObject *obj, float &add);
    // snow.player.PlayerQuestBase
    void start_400947(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerQuestBase
    void use_item_401117(sdk::VMContext *vmctx, ::REManagedObject *obj, uint32_t &item_id, bool is_throw);

    // snow.player.PlayerBase
    void calc_total_attack_597536(sdk::VMContext *vmctx, ::REManagedObject *obj);
    // snow.player.PlayerBase
    void calc_total_defence_597545(sdk::VMContext *vmctx, ::REManagedObject *obj);

  private:
    ::REManagedObject *get_player_manager();
    void process_bit_set_flag(::REManagedObject *obj, const uint32_t &flag, const bool is_on);

    enum class OldCondition : uint8_t
    {
        Pl_EquipSkill_003,
        Pl_EquipSkill_004,
        Pl_EquipSkill_024,
        Pl_EquipSkill_042,
        Pl_EquipSkill_090,
        Pl_EquipSkill_091,
        Pl_EquipSkill_105,
        Pl_EquipSkill_204,
        Pl_EquipSkill_208,
        Pl_EquipSkill_216,
        Pl_EquipSkill_229,
        Pl_EquipSkill_231,
        Pl_EquipSkill_232,
        Pl_KitchenSkill_002,
        Pl_KitchenSkill_051,
        Pl_KitchenSkill_054,
        Count,
    };

    enum class PlayerCondition : uint64_t
    {
        Pl_EquipSkill_001 = 1ULL << 0x1E, // 2 Pl_EquipSkill_001 挑戦者 Agitator
        Pl_EquipSkill_002 = 1ULL << 0x1B, // 3 Pl_EquipSkill_002 フルチャージ Peak Performance
        Pl_EquipSkill_008 = 1ULL << 0x1D, // 9 Pl_EquipSkill_008 力の解放 Latent Power
        Pl_EquipSkill_036 = 1ULL << 0x1F, // 37 Pl_EquipSkill_036 攻めの守勢 Offensive Guard
        Pl_EquipSkill_102 = 1ULL << 0x1C, // 103 Pl_EquipSkill_102 龍気活性 Dragonheart
        Pl_EquipSkill_206 = 1ULL << 0x20, // 118 Pl_EquipSkill_206 顕如盤石 Defiance
        Pl_EquipSkill_209 = 1ULL << 0x28, // 121 Pl_EquipSkill_209 煽衛 Embolden
        Pl_EquipSkill_215 = 1ULL << 0x21, // 127 Pl_EquipSkill_215 研磨術【鋭】 Grinder (S)
        Pl_EquipSkill_222 = 1ULL << 0x36, // 134 Pl_EquipSkill_222 状態異常確定蓄積 Status Trigger
        Pl_EquipSkill_226 = 1ULL << 0x39, // 138 Pl_EquipSkill_226 風纏 Wind Mantle
        Pl_EquipSkill_230 = 1ULL << 0x12, // 142 Pl_EquipSkill_230 天衣無崩 Heaven-Sent
    };

    ::REManagedObject *m_player_manager{};

    std::bitset<Utils::enum_cast(OldCondition::Count)> m_old_condition{};
    float m_pre_damage{};
};
