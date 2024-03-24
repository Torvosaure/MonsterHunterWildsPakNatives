#include "HookFunctions.hpp"

#include "ChatManager.hpp"
#include "Namespaces.hpp"

using namespace Namespaces;

void HookFunctions::on_11026(sdk::VMContext * /* vmctx */, ::REManagedObject *obj, uint32_t &flag)
{
    process_bit_set_flag(obj, flag, true);
}

void HookFunctions::off_11027(sdk::VMContext * /* vmctx */, ::REManagedObject *obj, uint32_t &flag)
{
    process_bit_set_flag(obj, flag, false);
}

void HookFunctions::update_old_205404(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    auto *const player_manager = get_player_manager();
    auto *const player_data_array = mhrise::snow::player::PlayerManager::PlayerData_b->get_data(player_manager);
    const auto master_player_id = mhrise::snow::player::PlayerManager::getMasterPlayerID208468->call(vmctx, player_manager);
    auto *const player_data = mhrise::snow::player::PlayerData_Array::Get208192->call(vmctx, player_data_array, master_player_id);

    if (player_data == nullptr || obj != mhrise::snow::player::PlayerData::_condition->get_data(player_data))
    {
        return;
    }

    const auto common = mhrise::snow::player::PlayerCondition::_common->get_data(obj);
    const auto common_old = mhrise::snow::player::PlayerCondition::_commonOld->get_data(obj);

    auto process_condition = [&](const PlayerCondition condition, const uint8_t &id, const bool off_only = false) constexpr -> void {
        const auto flag = Utils::enum_cast(condition);
        const auto common_condition = common & flag;
        const auto old_condition = common_old & flag;

        if (common_condition != old_condition)
        {
            const bool is_on = common_condition == flag;

            if (is_on && off_only)
            {
                return;
            }

            ChatManager::get()->process_skill_e(id, is_on);
        }
    };

    process_condition(PlayerCondition::Pl_EquipSkill_001, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_001->get_data());
    process_condition(PlayerCondition::Pl_EquipSkill_002, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_002->get_data());
    process_condition(PlayerCondition::Pl_EquipSkill_008, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_008->get_data());
    process_condition(PlayerCondition::Pl_EquipSkill_036, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_036->get_data(), true);
    process_condition(PlayerCondition::Pl_EquipSkill_102, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_102->get_data());
    process_condition(PlayerCondition::Pl_EquipSkill_206, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_206->get_data());
    process_condition(PlayerCondition::Pl_EquipSkill_209, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_209->get_data(), true);
    process_condition(PlayerCondition::Pl_EquipSkill_215, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_215->get_data(), true);
    process_condition(PlayerCondition::Pl_EquipSkill_222, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_222->get_data(), true);
    process_condition(PlayerCondition::Pl_EquipSkill_226, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_226->get_data());
    process_condition(PlayerCondition::Pl_EquipSkill_230, mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_230->get_data(), true);
}

void HookFunctions::calc_timer_259659(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    // 128 Pl_EquipSkill_216 刃鱗磨き Bladescale Hone | ON?, OFF

    auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);

    const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_216->get_data();
    const uint32_t lv = 1U;
    if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
    {
        const bool condition = mhrise::snow::player::Bow::EquipSkill216_BottleUpTimer_->get_data(obj) > 0.0F;

        if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_216)))
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_216), condition);

            if (!condition)
            {
                ChatManager::get()->process_skill_e(skill_id, false);
            }
        }
    }
    else
    {
        m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_216));
    }
}

void HookFunctions::execute_equip_skill216_259713(sdk::VMContext *vmctx, ::REManagedObject *obj, uint32_t & /* lv */)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    // 128 Pl_EquipSkill_216 刃鱗磨き Bladescale Hone | ON?

    m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_216));
}

void HookFunctions::late_update_400432(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);
    auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);

    // 116 Pl_EquipSkill_204 災禍転福 Coalescence | ON?, OFF

    const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_204->get_data();
    const uint32_t lv = 1U;
    if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
    {
        const bool condition = mhrise::snow::player::PlayerData::DisasterTurnPowerUpTimer_->get_data(player_data) > 0.0F;

        if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_204)))
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_204), condition);

            if (!condition)
            {
                ChatManager::get()->process_skill_e(skill_id, false);
            }
        }
    }
    else
    {
        m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_204));
    }
}

void HookFunctions::calc_timer_400436(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);
    auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);

    {
        // 25 Pl_EquipSkill_024 剛刃研磨 Protective Polish | ON?, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_024->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerBase::SharpnessGaugeBoostTimer_->get_data(obj) > 0.0F;

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_024)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_024), condition);

                if (!condition)
                {
                    ChatManager::get()->process_skill_e(mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_024->get_data(), false);
                }
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_024));
        }
    }

    {
        // 43 Pl_EquipSkill_042 滑走強化 Affinity Sliding | ON, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_042->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            auto *const player_manager = get_player_manager();
            auto *const player_user_data_skill_parameter = mhrise::snow::player::PlayerManager::PlayerUserDataSkillParameter_->get_data(player_manager);
            auto *const equip_skill_parameter =
                mhrise::snow::player::PlayerUserDataSkillParameter::EquipSkillParameter_->get_data(player_user_data_skill_parameter);

            if (mhrise::snow::player::EquipSkillParameter::EquipSkill_042_SlidingTime_->get_data(equip_skill_parameter) * 60.0F <=
                mhrise::snow::player::PlayerData::SlidingTimer_->get_data(player_data))
            {
                if (!m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_042)))
                {
                    m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_042));
                    ChatManager::get()->process_skill_e(skill_id, true);
                }
            }
            else
            {
                if (m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_042)) &&
                    mhrise::snow::player::PlayerData::SlidingPowerupTimer_->get_data(player_data) <= 0.0F)
                {
                    m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_042));
                    ChatManager::get()->process_skill_e(skill_id, false);
                }
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_042));
        }
    }

    {
        // 120 Pl_EquipSkill_208 巧撃 Adrenaline Rush | ON?, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_208->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerData::EquipSkill208_AtkUpTimer_->get_data(player_data) > 0.0F;

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_208)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_208), condition);

                if (!condition)
                {
                    ChatManager::get()->process_skill_e(skill_id, false);
                }
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_208));
        }
    }

    {
        // 141 Pl_EquipSkill_229 龍気変換 Dragon Conversion | ON, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_229->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerQuestBase::EquipSkill229UseUpFlg_->get_data(obj);

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_229)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_229), condition);
                ChatManager::get()->process_skill_e(skill_id, condition);
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_229));
        }
    }

    {
        // 143 Pl_EquipSkill_231 狂竜症【翔】 Frenzied Bloodlust | ON?, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_231->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerBase::HunterWireSkill231Num_b->get_data(obj) > 0U;

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_231)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_231), condition);

                if (!condition)
                {
                    ChatManager::get()->process_skill_e(skill_id, false);
                }
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_231));
        }
    }

    {
        // 144 Pl_EquipSkill_232 血氣覚醒 Blood Awakening | ON?, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_232->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerData::EquipSkill232Timer_->get_data(player_data) > 0.0F;

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_232)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_232), condition);

                if (!condition)
                {
                    ChatManager::get()->process_skill_e(skill_id, false);
                }
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_232));
        }
    }
}

void HookFunctions::set_kitchen_bonds_buff_400571(sdk::VMContext *vmctx, ::REManagedObject *obj, bool /* is_duplicate */)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);

    // 55 Pl_KitchenSkill_054 おだんご絆術 Dango Connector | ON?

    const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_054->get_data();
    const auto skill_lv = mhrise::snow::player::PlayerSkillList::getKitchenSkillLv208058->call(vmctx, player_skill_list, skill_id);
    switch (skill_lv)
    {
        case 0x1: [[fallthrough]];
        case 0x2: [[fallthrough]];
        case 0x3: [[fallthrough]];
        case 0x4: {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_KitchenSkill_054));

            break;
        }
    }
}

void HookFunctions::damage_vital_400600(sdk::VMContext *vmctx, ::REManagedObject *obj, float &damage, bool is_r_vital, bool is_slip_damage,
                                        bool /* is_guard_damage */, bool equip225_enable_damage, bool equip225_change_damage)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    if (is_r_vital && !is_slip_damage && !equip225_enable_damage && !equip225_change_damage)
    {
        if (damage + m_pre_damage > 0)
        {
            // 57 Pl_EquipSkill_056 精霊の加護 Divine Blessing | ON
            // 14 Concert_014 精霊王の加護 Divine Protection | ON

            ChatManager::get()->send_damage_reduce_message();
        }
    }
}

void HookFunctions::check_damage_calc_damage_400603(sdk::VMContext *vmctx, ::REManagedObject *obj, float &damage, float & /* heal */, ::REManagedObject *dmi,
                                                    bool is_guard_damage)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    if (damage == 0.0F)
    {
        return;
    }

    float pre_damage_mul = 1.0F;

    const auto calc_pre_damage_mul = [&pre_damage_mul](const float &f, const bool is_percent = false) -> void {
        pre_damage_mul *= is_percent ? 1.0F - static_cast<double>(f) / 100.0F : static_cast<double>(f);
    };

    auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);
    auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);

    auto *const player_manager = get_player_manager();
    auto *const player_user_data_skill_parameter = mhrise::snow::player::PlayerManager::PlayerUserDataSkillParameter_->get_data(player_manager);
    auto *const equip_skill_parameter = mhrise::snow::player::PlayerUserDataSkillParameter::EquipSkillParameter_->get_data(player_user_data_skill_parameter);
    auto *const odango_skill_parameter = mhrise::snow::player::PlayerUserDataSkillParameter::OdangoSkillParameter_->get_data(player_user_data_skill_parameter);

    // 135 Pl_EquipSkill_223 剛心 Intrepid Heart | ?
    if (mhrise::snow::player::PlayerData::EquipSkill223DamageReduce_->get_data(player_data))
    {
        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_223->get_data();
        auto *const player_skill_data = mhrise::snow::player::PlayerSkillList::getSkillData208060->call(vmctx, player_skill_list, skill_id);
        const auto skill_lv = mhrise::snow::player::PlayerSkillData::SkillLv->get_data(player_skill_data);

        auto *const equip_skill_223 = mhrise::snow::player::EquipSkillParameter::EquipSkill_223_->get_data(equip_skill_parameter);

        switch (skill_lv)
        {
            case 0x1: {
                calc_pre_damage_mul(mhrise::snow::player::EquipSkill_223::DamageReduceLv1_->get_data(equip_skill_223), true);
                break;
            }
            case 0x2: {
                calc_pre_damage_mul(mhrise::snow::player::EquipSkill_223::DamageReduceLv2_->get_data(equip_skill_223), true);
                break;
            }
        }
    }

    // 142 Pl_EquipSkill_230 天衣無崩 Heaven-Sent | ?
    if (mhrise::snow::player::PlayerQuestBase::isActiveEquipSkill230400590->call(vmctx, obj) &&
        mhrise::snow::player::PlayerQuestBase::EquipSkill230DamageReduce_->get_data(obj) == false)
    {
        const auto skill_lv = mhrise::snow::player::PlayerQuestBase::EquipSkill230Lv_->get_data(obj);
        if (skill_lv != 0x0 && skill_lv < 0x4)
        {
            calc_pre_damage_mul(mhrise::snow::player::EquipSkillParameter::EquipSkill_230_ReduceDamageRate_->get_data(equip_skill_parameter));
        }
    }

    // 24 Concert_024 音の防壁 Sonic Barrier | ?
    // TODO: This may not be necessary.
    if (mhrise::snow::player::PlayerData::HornMusicDamageReduce_->get_data(player_data))
    {
        const auto flag = mhrise::snow::player::PlayerBase::PlBaseActionFlag::IsHornWallHyperArmor->get_data();
        if (mhrise::snow::BitSetFlagBase::isOn11030->call(vmctx, mhrise::snow::player::PlayerBase::PlBaseActionFlags_b->get_data(obj), flag))
        {
            auto *const player_user_data_quest_common = mhrise::snow::player::PlayerQuestBase::PlayerUserDataQuestCommon_->get_data(obj);

            calc_pre_damage_mul(mhrise::snow::player::PlayerUserDataQuestCommon::HornMusicDamageReduce_->get_data(player_user_data_quest_common), true);
        }
    }

    // 29 Pl_KitchenSkill_028 おだんごふんばり術 Dango Feet | ?
    if (mhrise::snow::player::PlayerDamageInfo::damage_type->get_data(dmi) + ~mhrise::snow::hit::DamageType::None->get_data() < 0x2)
    {
        const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_028->get_data();
        const auto skill_lv = mhrise::snow::player::PlayerSkillList::getKitchenSkillLv208058->call(vmctx, player_skill_list, skill_id);

        switch (skill_lv)
        {
            case 0x3: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_028_Lv3_->get_data(odango_skill_parameter));
                break;
            }
            case 0x4: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_028_Lv4_->get_data(odango_skill_parameter));
                break;
            }
        }
    }

    // 49 Pl_KitchenSkill_048 おだんご防護術 Dango Defender | ?
    if (!is_guard_damage && mhrise::snow::player::PlayerData::IsEnable_KitchenSkill048_Reduce_->get_data(player_data))
    {
        const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_048->get_data();
        const auto skill_lv = mhrise::snow::player::PlayerSkillList::getKitchenSkillLv208058->call(vmctx, player_skill_list, skill_id);

        switch (skill_lv)
        {
            case 0x1: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_048_Lv1_Reduce_->get_data(odango_skill_parameter));
                break;
            }
            case 0x2: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_048_Lv2_Reduce_->get_data(odango_skill_parameter));
                break;
            }
            case 0x3: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_048_Lv3_Reduce_->get_data(odango_skill_parameter));
                break;
            }
            case 0x4: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_048_Lv4_Reduce_->get_data(odango_skill_parameter));
                break;
            }
        }
    }

    // 53 Pl_KitchenSkill_052 おだんご具足術 Dango Guard | ON
    if (mhrise::snow::player::PlayerLobbyBase::isLobbyCommonTag252656->call(vmctx, obj, mhrise::snow::player::Situation::ReceiveKitchen052->get_data()))
    {
        const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_052->get_data();
        const auto skill_lv = mhrise::snow::player::PlayerSkillList::getKitchenSkillLv208058->call(vmctx, player_skill_list, skill_id);

        switch (skill_lv)
        {
            case 0x1: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_052_Lv1_->get_data(odango_skill_parameter));
                break;
            }
            case 0x2: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_052_Lv2_->get_data(odango_skill_parameter));
                break;
            }
            case 0x3: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_052_Lv3_->get_data(odango_skill_parameter));
                break;
            }
            case 0x4: {
                calc_pre_damage_mul(mhrise::snow::player::OdangoSkillParameter::KitchenSkill_052_Lv4_->get_data(odango_skill_parameter));
                break;
            }
        }

        ChatManager::get()->process_skill_k(skill_id, true);
    }

    m_pre_damage = damage * pre_damage_mul;
}

void HookFunctions::set_condition_400615(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);
    auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);

    {
        // 4 Pl_EquipSkill_003 逆恨み Resentment | ON, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_003->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            auto *const vital_context = mhrise::snow::player::PlayerData::_vitalContext->get_data(player_data);
            const bool condition = static_cast<int32_t>(mhrise::via::dve::DeviceContext_System_Single::read205342->call(vmctx, vital_context)) <
                                       mhrise::snow::player::PlayerData::_r_Vital->get_data(player_data) ||
                                   mhrise::snow::player::PlayerBase::IsEnableEquipSkill225_->get_data(obj);

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_003)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_003), condition);
                ChatManager::get()->process_skill_e(skill_id, condition);
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_003));
        }
    }

    {
        // 5 Pl_EquipSkill_004 死中に活 Resuscitate | ON, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_004->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerBase::isDebuffState597593->call(vmctx, obj);

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_004)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_004), condition);
                ChatManager::get()->process_skill_e(skill_id, condition);
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_004));
        }
    }

    {
        // 91 Pl_EquipSkill_090 火事場力 Heroics | ON, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_090->get_data();
        if (mhrise::snow::player::PlayerSkillList::getSkillData208060->call(vmctx, player_skill_list, skill_id) != nullptr)
        {
            const bool condition = mhrise::snow::player::PlayerBase::isPredicamentPowerUp597588->call(vmctx, obj) &&
                                   mhrise::snow::player::PlayerBase::isKitchenSkillPredicamentPowerUp597616->call(vmctx, obj) == false;

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_090)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_090), condition);
                ChatManager::get()->process_skill_e(skill_id, condition);
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_090));
        }
    }

    {
        // 106 Pl_EquipSkill_105 逆襲 Counterstrike | ON, OFF

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_105->get_data();
        const uint32_t lv = 1U;
        if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
        {
            const bool condition = mhrise::snow::player::PlayerData::CounterattackPowerupTimer_->get_data(player_data) > 0.0F;

            if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_105)))
            {
                m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_105), condition);
                ChatManager::get()->process_skill_e(skill_id, condition);
            }
        }
        else
        {
            m_old_condition.reset(Utils::enum_cast(OldCondition::Pl_EquipSkill_105));
        }
    }

    {
        // 3 Pl_KitchenSkill_002 おだんご火事場力 | ON, OFF

        const bool condition = mhrise::snow::player::PlayerBase::isKitchenSkillPredicamentPowerUp597616->call(vmctx, obj);

        if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_KitchenSkill_002)))
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_KitchenSkill_002), condition);

            const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_002->get_data();
            ChatManager::get()->process_skill_k(skill_id, condition);
        }
    }
}

void HookFunctions::set_skill_036_400647(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    // 37 Pl_EquipSkill_036 攻めの守勢 Offensive Guard | ON

    if (mhrise::snow::player::PlayerBase::_playerWeaponType->get_data(obj) != mhrise::snow::player::PlayerWeaponType::HeavyBowgun->get_data() &&
        mhrise::snow::player::PlayerQuestBase::IsGuardPrevFrame_->get_data(obj) &&
        mhrise::snow::player::PlayerQuestBase::EquipSkill_036_Timer_->get_data(obj) > 0.0F)
    {
        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_036->get_data();
        ChatManager::get()->process_skill_e(skill_id, true);
    }
}

void HookFunctions::activate_equip_skill208_400665(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    // 120 Pl_EquipSkill_208 巧撃 Adrenaline Rush | ON?

    m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_208));
}

void HookFunctions::activate_equip_skill231_400669(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    // 143 Pl_EquipSkill_231 狂竜症【翔】 Frenzied Bloodlust | ON?

    m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_231));
}

void HookFunctions::add_equip_skill232_absorption_400748(sdk::VMContext *vmctx, ::REManagedObject *obj, float &add)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    // 144 Pl_EquipSkill_232 血氣覚醒 Blood Awakening | ON?

    if (!m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_232)))
    {
        auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);
        auto *const player_manager = get_player_manager();
        auto *const player_user_data_skill_parameter = mhrise::snow::player::PlayerManager::PlayerUserDataSkillParameter_->get_data(player_manager);
        auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);
        auto *const equip_skill_parameter =
            mhrise::snow::player::PlayerUserDataSkillParameter::EquipSkillParameter_->get_data(player_user_data_skill_parameter);
        auto *const equip_skill_232 = mhrise::snow::player::EquipSkillParameter::EquipSkill_232_->get_data(equip_skill_parameter);

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_232->get_data();
        auto *const skill_data = mhrise::snow::player::PlayerSkillList::getSkillData208060->call(vmctx, player_skill_list, skill_id);
        const auto skill_lv = mhrise::snow::player::PlayerSkillData::SkillLv->get_data(skill_data);

        REManagedObject *lv_param{};

        switch (skill_lv)
        {
            case 0x1: {
                lv_param = mhrise::snow::player::EquipSkill_232::SkillLv1_->get_data(equip_skill_232);
                break;
            }
            case 0x2: {
                lv_param = mhrise::snow::player::EquipSkill_232::SkillLv2_->get_data(equip_skill_232);
                break;
            }
            case 0x3: {
                lv_param = mhrise::snow::player::EquipSkill_232::SkillLv3_->get_data(equip_skill_232);
                break;
            }
        }

        const auto equip_skill232_absorption = mhrise::snow::player::PlayerData::EquipSkill232Absorption_->get_data(player_data) + add;

        if (mhrise::snow::player::EquipSkill_232_LvParam::Absorption_Lv1_->get_data(lv_param) <= equip_skill232_absorption ||
            mhrise::snow::player::EquipSkill_232_LvParam::Absorption_Lv2_->get_data(lv_param) <= equip_skill232_absorption)
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_232));
        }
    }
}

void HookFunctions::start_400947(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMaster597332->call(vmctx, obj) == false)
    {
        return;
    }

    m_old_condition.reset();
}

void HookFunctions::use_item_401117(sdk::VMContext *vmctx, ::REManagedObject *obj, uint32_t &item_id, bool /* is_throw */)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    if (item_id == mhrise::snow::data::ContentsIdSystem::ItemId::I_Normal_0010->get_data() ||
        item_id == mhrise::snow::data::ContentsIdSystem::ItemId::I_Normal_0499->get_data())
    {
        auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);

        // 25 Pl_EquipSkill_024 剛刃研磨 Protective Polish | ON

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_024->get_data();
        if (mhrise::snow::player::PlayerSkillList::getSkillData208060->call(vmctx, player_skill_list, skill_id) != nullptr)
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_024));
            ChatManager::get()->process_skill_e(skill_id, true);
        }
    }
}

void HookFunctions::calc_total_attack_597536(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    static auto *const quest_manager = sdk::get_managed_singleton<REManagedObject>("snow.QuestManager");
    const auto quest_type = mhrise::snow::QuestManager::QuestType_->get_data(quest_manager);
    auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);

    {
        // 92 Pl_EquipSkill_091 不屈 Fortify | ON, OFF

        bool condition = false;

        const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_091->get_data();
        if (quest_type != mhrise::snow::quest::QuestType::TOUR->get_data() && quest_type != mhrise::snow::quest::QuestType::HYAKURYU->get_data())
        {
            auto *const quest_data = mhrise::snow::QuestManager::ActiveQuestData_->get_data(quest_manager);

            if (quest_data != nullptr)
            {
                auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(obj);

                const uint32_t lv = 1U;
                if (mhrise::snow::player::PlayerSkillList::hasSkill208056->call(vmctx, player_skill_list, skill_id, lv))
                {
                    if (mhrise::snow::player::PlayerData::DieCount_->get_data(player_data) != 0)
                    {
                        condition = true;
                    }
                }
            }
        }

        if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_EquipSkill_091)))
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_EquipSkill_091), condition);
            ChatManager::get()->process_skill_e(skill_id, condition);
        }
    }

    {
        // 52 Pl_KitchenSkill_051 おだんご逃走術 Dango Hunter | ON, OFF

        const bool condition = mhrise::snow::player::PlayerData::KitchenSkill051_AtkUpTimer_->get_data(player_data) > 0.0F;

        if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_KitchenSkill_051)))
        {
            m_old_condition.set(Utils::enum_cast(OldCondition::Pl_KitchenSkill_051), condition);

            const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_051->get_data();
            ChatManager::get()->process_skill_k(skill_id, condition);
        }
    }
}

void HookFunctions::calc_total_defence_597545(sdk::VMContext *vmctx, ::REManagedObject *obj)
{
    if (mhrise::snow::player::PlayerBase::isMasterPlayer597334->call(vmctx, obj) == false)
    {
        return;
    }

    auto *const player_data = mhrise::snow::player::PlayerBase::_refPlayerData->get_data(obj);

    // 55 Pl_KitchenSkill_054 おだんご絆術 Dango Connector | OFF

    const bool condition = mhrise::snow::player::PlayerData::KitchenSkill054_Timer_->get_data(player_data) > 0.0F;

    if (condition != m_old_condition.test(Utils::enum_cast(OldCondition::Pl_KitchenSkill_054)))
    {
        m_old_condition.set(Utils::enum_cast(OldCondition::Pl_KitchenSkill_054), condition);

        if (!condition)
        {
            const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_054->get_data();
            ChatManager::get()->process_skill_k(skill_id, false);
        }
    }
}

::REManagedObject *HookFunctions::get_player_manager()
{
    if (m_player_manager == nullptr)
    {
        m_player_manager = sdk::get_managed_singleton<REManagedObject>("snow.player.PlayerManager");
    }

    return m_player_manager;
}

void HookFunctions::process_bit_set_flag(::REManagedObject *obj, const uint32_t &flag, const bool is_on)
{
    auto *const t = utility::re_managed_object::get_type_definition(obj);

    if (t->is_generic_type() == false)
    {
        return;
    }

    const auto generic_types = t->get_generic_argument_types();

    const auto get_master_player = [&]() -> ::REManagedObject * {
        auto *const player_manager = get_player_manager();
        auto *const master_player = mhrise::snow::player::PlayerManager::findMasterPlayer208467->call(sdk::get_thread_context(), player_manager);

        return master_player;
    };

    if (generic_types[0]->is_a(mhrise::snow::player::PlayerBase::PlBaseActionFlag::RETypeDefinition))
    {
        const auto is_master_player = [&obj, &get_master_player]() -> bool {
            return obj == mhrise::snow::player::PlayerBase::PlBaseActionFlags_b->get_data(get_master_player());
        };

        // 10 Pl_EquipSkill_009 渾身 Maximum Might | ON, OFF
        if (flag == static_cast<uint32_t>(mhrise::snow::player::PlayerBase::PlBaseActionFlag::IsWholeBodyTime->get_data()))
        {
            if (is_master_player())
            {
                const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_009->get_data();
                ChatManager::get()->process_skill_e(skill_id, is_on);
            }
        }
        // 139 Pl_EquipSkill_227 粉塵纏 Powder Mantle | ON
        else if (is_on && (flag == static_cast<uint32_t>(mhrise::snow::player::PlayerBase::PlBaseActionFlag::EquipSkill227_TriggerAttack->get_data()) ||
                           flag == static_cast<uint32_t>(mhrise::snow::player::PlayerBase::PlBaseActionFlag::EquipSkill227_TriggerDamage->get_data())))
        {
            if (is_master_player())
            {
                const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_227->get_data();
                ChatManager::get()->process_skill_e(skill_id, true);
            }
        }
    }
    else if (generic_types[0]->is_a(mhrise::snow::player::PlayerSkillList::SkillEndFlags::RETypeDefinition))
    {
        const auto is_master_player = [&obj, &get_master_player]() -> bool {
            auto *const player_skill_list = mhrise::snow::player::PlayerBase::_refPlayerSkillList->get_data(get_master_player());

            return obj == mhrise::snow::player::PlayerSkillList::SkillEndFlags_->get_data(player_skill_list);
        };

        // 25 Pl_KitchenSkill_024 おだんごド根性 Dango Moxie | ON
        if (is_on && flag == static_cast<uint32_t>(mhrise::snow::player::PlayerSkillList::SkillEndFlags::Kitchen_024->get_data()))
        {
            if (is_master_player())
            {
                const auto skill_id = mhrise::snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_024->get_data();
                ChatManager::get()->process_skill_k(skill_id, true);
            }
        }
        // 132 Pl_EquipSkill_220 根性 Guts | ON
        else if (is_on && flag == static_cast<uint32_t>(mhrise::snow::player::PlayerSkillList::SkillEndFlags::Equip_220->get_data()))
        {
            if (is_master_player())
            {
                const auto skill_id = mhrise::snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_220->get_data();
                ChatManager::get()->process_skill_e(skill_id, true);
            }
        }
    }
}
