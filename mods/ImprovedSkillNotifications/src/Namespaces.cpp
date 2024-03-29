#include "Namespaces.hpp"

void Namespaces::mhrise::initialize()
{
    const auto init = []<typename... OuterArgs>(std::string_view type_name, OuterArgs &&...outer_args) constexpr -> void {
        auto *const t = sdk::find_type_definition(type_name);
        assert(t != nullptr);

        const auto process_args = []<typename T, typename... InnerArgs>(auto self, sdk::RETypeDefinition *type_def, std::string_view name, T &dest,
                                                                        InnerArgs &&...inner_args) constexpr -> void {
            if constexpr (std::is_base_of_v<sdk::REField, std::remove_pointer_t<T>>)
            {
                dest = static_cast<T>(type_def->get_field(name));
            }
            else if constexpr (std::is_base_of_v<sdk::REMethodDefinition, std::remove_pointer_t<T>>)
            {
                dest = static_cast<T>(type_def->get_method(name));
            }
            else if constexpr (std::is_base_of_v<VariableDescriptor, std::remove_pointer_t<T>>)
            {
                dest = static_cast<T>(utility::re_type::get_field_desc(type_def->get_type(), name));
            }

            assert(dest != nullptr);

            if constexpr (sizeof...(inner_args) >= 2)
            {
                self(self, type_def, std::forward<InnerArgs>(inner_args)...);
            }
            else if constexpr (sizeof...(inner_args) == 1)
            {
                ((inner_args = type_def), ...);
            }
        };

        process_args(process_args, t, std::forward<OuterArgs>(outer_args)...);
    };

    // clang-format off

    init("snow.gui.COMMON",
         "GUI_COMMON_NOTICE_SIDE_OPEN", snow::gui::COMMON::GUI_COMMON_NOTICE_SIDE_OPEN);

    init("snow.player.EquipSkill_223",
         "_DamageReduceLv1", snow::player::EquipSkill_223::DamageReduceLv1_,
         "_DamageReduceLv2", snow::player::EquipSkill_223::DamageReduceLv2_);

    init("snow.data.DataDef.PlKitchenSkillId",
         "Pl_KitchenSkill_002", snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_002,
         "Pl_KitchenSkill_024", snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_024,
         "Pl_KitchenSkill_048", snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_048,
         "Pl_KitchenSkill_051", snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_051,
         "Pl_KitchenSkill_052", snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_052,
         "Pl_KitchenSkill_054", snow::data::DataDef::PlKitchenSkillId::Pl_KitchenSkill_054);

    init("snow.quest.QuestType",
         "TOUR", snow::quest::QuestType::TOUR,
         "HYAKURYU", snow::quest::QuestType::HYAKURYU);

    init("snow.player.PlayerBase.PlBaseActionFlag",
         "IsWholeBodyTime", snow::player::PlayerBase::PlBaseActionFlag::IsWholeBodyTime,
         "EquipSkill227_TriggerAttack", snow::player::PlayerBase::PlBaseActionFlag::EquipSkill227_TriggerAttack,
         "EquipSkill227_TriggerDamage", snow::player::PlayerBase::PlBaseActionFlag::EquipSkill227_TriggerDamage,
         snow::player::PlayerBase::PlBaseActionFlag::RETypeDefinition);

    init("snow.player.PlayerSkillList.SkillEndFlags",
         "Kitchen_024", snow::player::PlayerSkillList::SkillEndFlags::Kitchen_024,
         "Equip_220", snow::player::PlayerSkillList::SkillEndFlags::Equip_220,
         snow::player::PlayerSkillList::SkillEndFlags::RETypeDefinition);

    init("snow.BitSetFlagBase",
         "isOn(System.UInt32)", snow::BitSetFlagBase::isOn11030);

    init("snow.player.PlayerManager",
         "_PlayerUserDataSkillParameter", snow::player::PlayerManager::PlayerUserDataSkillParameter_,
         "<PlayerData>k__BackingField", snow::player::PlayerManager::PlayerData_b,
         "findMasterPlayer()", snow::player::PlayerManager::findMasterPlayer208467,
         "getMasterPlayerID()", snow::player::PlayerManager::getMasterPlayerID208468);

    init("snow.player.PlayerQuestBase",
         "_EquipSkill_036_Timer", snow::player::PlayerQuestBase::EquipSkill_036_Timer_,
         "_IsGuardPrevFrame", snow::player::PlayerQuestBase::IsGuardPrevFrame_,
         "_EquipSkill229UseUpFlg", snow::player::PlayerQuestBase::EquipSkill229UseUpFlg_,
         "_EquipSkill230Lv", snow::player::PlayerQuestBase::EquipSkill230Lv_,
         "_EquipSkill230DamageReduce", snow::player::PlayerQuestBase::EquipSkill230DamageReduce_,
         "isActiveEquipSkill230()", snow::player::PlayerQuestBase::isActiveEquipSkill230400590);

    init("snow.player.Bow",
         "_EquipSkill216_BottleUpTimer", snow::player::Bow::EquipSkill216_BottleUpTimer_);

    init("snow.player.Situation",
         "ReceiveKitchen052", snow::player::Situation::ReceiveKitchen052);

    init("snow.player.PlayerData",
         "_vitalContext", snow::player::PlayerData::_vitalContext,
         "_r_Vital", snow::player::PlayerData::_r_Vital,
         "_condition", snow::player::PlayerData::_condition,
         "_SlidingTimer", snow::player::PlayerData::SlidingTimer_,
         "_SlidingPowerupTimer", snow::player::PlayerData::SlidingPowerupTimer_,
         "_CounterattackPowerupTimer", snow::player::PlayerData::CounterattackPowerupTimer_,
         "_DieCount", snow::player::PlayerData::DieCount_,
         "_IsEnable_KitchenSkill048_Reduce", snow::player::PlayerData::IsEnable_KitchenSkill048_Reduce_,
         "_KitchenSkill051_AtkUpTimer", snow::player::PlayerData::KitchenSkill051_AtkUpTimer_,
         "_KitchenSkill054_Timer", snow::player::PlayerData::KitchenSkill054_Timer_,
         "_DisasterTurnPowerUpTimer", snow::player::PlayerData::DisasterTurnPowerUpTimer_,
         "_EquipSkill208_AtkUpTimer", snow::player::PlayerData::EquipSkill208_AtkUpTimer_,
         "_EquipSkill223DamageReduce", snow::player::PlayerData::EquipSkill223DamageReduce_,
         "_EquipSkill232Absorption", snow::player::PlayerData::EquipSkill232Absorption_,
         "_EquipSkill232Timer", snow::player::PlayerData::EquipSkill232Timer_);

    init("snow.data.DataShortcut",
         "getName(snow.data.DataDef.PlEquipSkillId)", snow::data::DataShortcut::getName249386,
         "getName(snow.data.DataDef.PlKitchenSkillId)", snow::data::DataShortcut::getName249402);

    init("snow.gui.ChatManager",
         "reqAddChatInfomation(System.String, System.UInt32)", snow::gui::ChatManager::reqAddChatInfomation244588);

    init("snow.player.PlayerSkillList",
         "_SkillEndFlags", snow::player::PlayerSkillList::SkillEndFlags_,
         "hasSkill(snow.data.DataDef.PlEquipSkillId, System.UInt32)", snow::player::PlayerSkillList::hasSkill208056,
         "getKitchenSkillLv(snow.data.DataDef.PlKitchenSkillId)", snow::player::PlayerSkillList::getKitchenSkillLv208058,
         "getSkillData(snow.data.DataDef.PlEquipSkillId)", snow::player::PlayerSkillList::getSkillData208060);

    init("snow.player.EquipSkill_232",
         "_SkillLv1", snow::player::EquipSkill_232::SkillLv1_,
         "_SkillLv2", snow::player::EquipSkill_232::SkillLv2_,
         "_SkillLv3", snow::player::EquipSkill_232::SkillLv3_);

    init("snow.player.PlayerData[]",
         "Get(System.Int32)", snow::player::PlayerData_Array::Get208192);

    init("via.dve.DeviceContext`1<System.Single>",
         "read()", via::dve::DeviceContext_System_Single::read205342);

    init("snow.player.PlayerWeaponType",
         "HeavyBowgun", snow::player::PlayerWeaponType::HeavyBowgun);

    init("snow.player.EquipSkillParameter",
         "_EquipSkill_042_SlidingTime", snow::player::EquipSkillParameter::EquipSkill_042_SlidingTime_,
         "_EquipSkill_223", snow::player::EquipSkillParameter::EquipSkill_223_,
         "_EquipSkill_230_ReduceDamageRate", snow::player::EquipSkillParameter::EquipSkill_230_ReduceDamageRate_,
         "_EquipSkill_232", snow::player::EquipSkillParameter::EquipSkill_232_);

    init("snow.player.PlayerBase",
         "_refPlayerData", snow::player::PlayerBase::_refPlayerData,
         "_refPlayerSkillList", snow::player::PlayerBase::_refPlayerSkillList,
         "_playerWeaponType", snow::player::PlayerBase::_playerWeaponType,
         "_SharpnessGaugeBoostTimer", snow::player::PlayerBase::SharpnessGaugeBoostTimer_,
         "<HunterWireSkill231Num>k__BackingField", snow::player::PlayerBase::HunterWireSkill231Num_b,
         "<PlBaseActionFlags>k__BackingField", snow::player::PlayerBase::PlBaseActionFlags_b,
         "_IsEnableEquipSkill225", snow::player::PlayerBase::IsEnableEquipSkill225_,
         "isMaster()", snow::player::PlayerBase::isMaster597332,
         "isMasterPlayer()", snow::player::PlayerBase::isMasterPlayer597334,
         "isSituationTag(snow.player.Situation)", snow::player::PlayerBase::isSituationTag597339,
         "isPredicamentPowerUp()", snow::player::PlayerBase::isPredicamentPowerUp597588,
         "isDebuffState()", snow::player::PlayerBase::isDebuffState597593,
         "isKitchenSkillPredicamentPowerUp()", snow::player::PlayerBase::isKitchenSkillPredicamentPowerUp597616);

    init("snow.player.PlayerCondition",
         "_common", snow::player::PlayerCondition::_common,
         "_commonOld", snow::player::PlayerCondition::_commonOld);

    init("snow.QuestManager",
         "_ActiveQuestData", snow::QuestManager::ActiveQuestData_,
         "_QuestType", snow::QuestManager::QuestType_);

    init("snow.player.OdangoSkillParameter",
         "_KitchenSkill_048_Lv1_Reduce", snow::player::OdangoSkillParameter::KitchenSkill_048_Lv1_Reduce_,
         "_KitchenSkill_048_Lv2_Reduce", snow::player::OdangoSkillParameter::KitchenSkill_048_Lv2_Reduce_,
         "_KitchenSkill_048_Lv3_Reduce", snow::player::OdangoSkillParameter::KitchenSkill_048_Lv3_Reduce_,
         "_KitchenSkill_048_Lv4_Reduce", snow::player::OdangoSkillParameter::KitchenSkill_048_Lv4_Reduce_,
         "_KitchenSkill_052_Lv1", snow::player::OdangoSkillParameter::KitchenSkill_052_Lv1_,
         "_KitchenSkill_052_Lv2", snow::player::OdangoSkillParameter::KitchenSkill_052_Lv2_,
         "_KitchenSkill_052_Lv3", snow::player::OdangoSkillParameter::KitchenSkill_052_Lv3_,
         "_KitchenSkill_052_Lv4", snow::player::OdangoSkillParameter::KitchenSkill_052_Lv4_);

    init("snow.player.EquipSkill_232_LvParam",
         "_Absorption_Lv1", snow::player::EquipSkill_232_LvParam::Absorption_Lv1_,
         "_Absorption_Lv2", snow::player::EquipSkill_232_LvParam::Absorption_Lv2_);

    init("snow.player.PlayerSkillData",
         "SkillLv", snow::player::PlayerSkillData::SkillLv);

    init("via.gui.message",
         "get(System.Guid)", via::gui::message::get778345,
         "getGuidByName(System.String)", via::gui::message::getGuidByName778372);

    init("snow.data.ContentsIdSystem.ItemId",
         "I_Normal_0010", snow::data::ContentsIdSystem::ItemId::I_Normal_0010,
         "I_Normal_0499", snow::data::ContentsIdSystem::ItemId::I_Normal_0499);

    init("snow.data.DataDef.PlEquipSkillId",
         "Pl_EquipSkill_001", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_001,
         "Pl_EquipSkill_002", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_002,
         "Pl_EquipSkill_003", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_003,
         "Pl_EquipSkill_004", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_004,
         "Pl_EquipSkill_008", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_008,
         "Pl_EquipSkill_009", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_009,
         "Pl_EquipSkill_024", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_024,
         "Pl_EquipSkill_036", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_036,
         "Pl_EquipSkill_042", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_042,
         "Pl_EquipSkill_090", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_090,
         "Pl_EquipSkill_091", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_091,
         "Pl_EquipSkill_102", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_102,
         "Pl_EquipSkill_105", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_105,
         "Pl_EquipSkill_204", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_204,
         "Pl_EquipSkill_206", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_206,
         "Pl_EquipSkill_208", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_208,
         "Pl_EquipSkill_209", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_209,
         "Pl_EquipSkill_215", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_215,
         "Pl_EquipSkill_216", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_216,
         "Pl_EquipSkill_220", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_220,
         "Pl_EquipSkill_222", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_222,
         "Pl_EquipSkill_223", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_223,
         "Pl_EquipSkill_226", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_226,
         "Pl_EquipSkill_227", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_227,
         "Pl_EquipSkill_229", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_229,
         "Pl_EquipSkill_230", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_230,
         "Pl_EquipSkill_231", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_231,
         "Pl_EquipSkill_232", snow::data::DataDef::PlEquipSkillId::Pl_EquipSkill_232);

    init("snow.player.PlayerUserDataSkillParameter",
         "_EquipSkillParameter", snow::player::PlayerUserDataSkillParameter::EquipSkillParameter_,
         "_OdangoSkillParameter", snow::player::PlayerUserDataSkillParameter::OdangoSkillParameter_);

    init("System.String",
         "Format(System.String, System.Object)", System::String::Format722162);

    // clang-format on
}
