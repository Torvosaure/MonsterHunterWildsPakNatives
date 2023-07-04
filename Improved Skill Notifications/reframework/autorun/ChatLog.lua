local function set_rgb_color_to_string(str, r, g, b)
    return ("<COLOR %02X%02X%02X>%s</COLOR>"):format(r, g, b, str)
end

local function set_color_name_to_string(str, color_name)
    return ("<COL %s>%s</COL>"):format(color_name, str)
end

local function get_player_manager()
    return sdk.get_managed_singleton("snow.player.PlayerManager")
end
local function get_master_player_id(player_manager)
    return player_manager:call("getMasterPlayerID()")
end
local function get_player_base(player_manager)
    return player_manager:call("findMasterPlayer()")
end
local function get_player_data(player_manager, master_player_id)
    return player_manager:get_field("<PlayerData>k__BackingField")[master_player_id]
end
local function get_player_skill_list(player_manager, master_player_id)
    return player_manager:get_field("<PlayerSkill>k__BackingField")[master_player_id]
end

local function get_gui_manager()
    return sdk.get_managed_singleton("snow.gui.GuiManager")
end
local function get_gui_hud(gui_manager)
    return gui_manager:get_field("<refGuiHud>k__BackingField")
end
local function get_player_info(gui_hud)
    return gui_hud:get_field("PlayerInfo")
end

local function get_quest_manager()
    return sdk.get_managed_singleton("snow.QuestManager")
end

local function get_chat_manager()
    return sdk.get_managed_singleton("snow.gui.ChatManager")
end

local get_message_language = sdk.find_type_definition("via.gui.GUISystem"):get_method("get_MessageLanguage()")
local message_language_index = get_message_language:call(nil)
local function is_changed_language()
    local pre_index = get_message_language:call(nil)
    if message_language_index ~= pre_index then
        message_language_index = pre_index
        return true
    end
end

local player_equip_skill_id = sdk.find_type_definition("snow.data.DataDef.PlEquipSkillId")
local function get_player_equip_skill_id(enum)
    return player_equip_skill_id:get_field(enum):get_data(nil)
end
local function get_equip_skill_data(player_skill_list)
    local t = {}
    if player_skill_list then
        for i = 1, #player_equip_skill_id:get_fields() do
            t[i] = player_skill_list:call("getSkillData(snow.data.DataDef.PlEquipSkillId)", i)
        end
    end
    return t
end

local player_kitchen_skill_id = sdk.find_type_definition("snow.data.DataDef.PlKitchenSkillId")
local function get_player_kitchen_skill_id(enum)
    return player_kitchen_skill_id:get_field(enum):get_data(nil)
end
local function get_kitchen_skill_data(player_skill_list)
    local t = {}
    if player_skill_list then
        for i = 1, #player_kitchen_skill_id:get_fields() do
            t[i] = player_skill_list:call("getKitchenSkillData(snow.data.DataDef.PlKitchenSkillId)", i)
        end
    end
    return t
end

local get_guid_by_name = sdk.find_type_definition("via.gui.message"):get_method("getGuidByName(System.String)")
local get_message      = sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)")
local function get_message_by_name(name)
    return get_message:call(nil, get_guid_by_name:call(nil, name))
end

local player_quest_define = sdk.find_type_definition("snow.player.PlayerQuestDefine")
local function get_skill_data(player_manager)
    local equip_skill_parameter  = player_manager:get_field("_PlayerUserDataSkillParameter"):get_field("_EquipSkillParameter")
    local odango_skill_parameter = player_manager:get_field("_PlayerUserDataSkillParameter"):get_field("_OdangoSkillParameter")
    return {
        EquipSkill = {
            _001 = {
                Enum      = "Pl_EquipSkill_001",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_001"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { player_quest_define:get_field("SkillChallengeTime"):get_data(nil) }
            },
            _002 = {
                Enum      = "Pl_EquipSkill_002",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_002"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _003 = {
                Enum      = "Pl_EquipSkill_003",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_003"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _004 = {
                Enum      = "Pl_EquipSkill_004",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_004"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _008 = {
                Enum      = "Pl_EquipSkill_008",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_008"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _009 = {
                Enum      = "Pl_EquipSkill_009",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_009"),
                Notice    = { true, true },
                Condition = { false, false, false },
                Param     = { 120 }
            },
            _023 = {
                Enum      = "Pl_EquipSkill_023",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_023"),
                Notice    = { true, false },
                Condition = {},
                Param     = {}
            },
            _036 = {
                Enum      = "Pl_EquipSkill_036",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_036"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { 720 }
            },
            _042 = {
                Enum      = "Pl_EquipSkill_042",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_042"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { equip_skill_parameter:get_field("_EquipSkill_042_CtlAddTime") * 60 }
            },
            _089 = {
                Enum      = "Pl_EquipSkill_089",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_089"),
                Notice    = { true, false },
                Condition = {},
                Param     = {}
            },
            _090 = {
                Enum      = "Pl_EquipSkill_090",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_090"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { 0.35 }
            },
            _091 = {
                Enum      = "Pl_EquipSkill_091",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_091"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { 0 }
            },
            _102 = {
                Enum      = "Pl_EquipSkill_102",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_102"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv2"),
                    equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv2"),
                    equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv4"),
                    equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv4"),
                    equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv5")
                }
            },
            _105 = {
                Enum      = "Pl_EquipSkill_105",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_105"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { 1800 }
            },
            _204 = {
                Enum      = "Pl_EquipSkill_204",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_204"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { 1800 }
            },
            _206 = {
                Enum      = "Pl_EquipSkill_206",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_206"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _208 = {
                Enum      = "Pl_EquipSkill_208",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_208"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_208_Lv1_Duration") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_208_Lv2_Duration") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_208_Lv3_Duration") * 60
                }
            },
            _209 = {
                Enum      = "Pl_EquipSkill_209",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_209"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _210 = {
                Enum      = "Pl_EquipSkill_210",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_210"),
                Notice    = { true, false },
                Condition = { false },
                Param     = {}
            },
            _215 = {
                Enum      = "Pl_EquipSkill_215",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_215"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_215_Lv1"):get_field("_Time") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_215_Lv2"):get_field("_Time") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_215_Lv3"):get_field("_Time") * 60
                }
            },
            _216 = {
                Enum      = "Pl_EquipSkill_216",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_216"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_216_Lv1"):get_field("_Bow_Duration") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_216_Lv2"):get_field("_Bow_Duration") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_216_Lv3"):get_field("_Bow_Duration") * 60
                }
            },
            _220 = {
                Enum      = "Pl_EquipSkill_220",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_220"),
                Notice    = { true, false },
                Condition = { false },
                Param     = {}
            },
            _222 = {
                Enum      = "Pl_EquipSkill_222",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_222"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_222_Lv1"),
                    equip_skill_parameter:get_field("_EquipSkill_222_Lv2"),
                    equip_skill_parameter:get_field("_EquipSkill_222_Lv3")
                }
            },
            _223 = {
                Enum      = "Pl_EquipSkill_223",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_223"),
                Notice    = { true, false },
                Condition = { false },
                Param     = { {
                    (100 - equip_skill_parameter:get_field("_EquipSkill_223"):get_field("_DamageReduceLv1")) / 100,
                    (100 - equip_skill_parameter:get_field("_EquipSkill_223"):get_field("_DamageReduceLv2")) / 100
                }, {
                    equip_skill_parameter:get_field("_EquipSkill_223"):get_field("_AccumulatorMax")
                } }
            },
            _024 = {
                Enum      = "Pl_EquipSkill_024",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_024"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_024_Lv1") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_024_Lv2") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_024_Lv3") * 60
                }
            },
            _226 = {
                Enum      = "Pl_EquipSkill_226",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_226"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _227 = {
                Enum      = "Pl_EquipSkill_227",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_227"),
                Notice    = { true, false },
                Condition = { false },
                Param     = {}
            },
            _229 = {
                Enum      = "Pl_EquipSkill_229",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_229"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _230 = {
                Enum      = "Pl_EquipSkill_230",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_230"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {}
            },
            _231 = {
                Enum      = "Pl_EquipSkill_231",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_231"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    equip_skill_parameter:get_field("_EquipSkill_231_Lv1_WpOn_Timer") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_231_Lv2_WpOn_Timer") * 60,
                    equip_skill_parameter:get_field("_EquipSkill_231_Lv3_WpOn_Timer") * 60
                }
            },
            _232 = {
                Enum      = "Pl_EquipSkill_232",
                Id        = get_player_equip_skill_id("Pl_EquipSkill_232"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { {
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv1"):get_field("_Absorption_Lv1"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv2"):get_field("_Absorption_Lv1"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv3"):get_field("_Absorption_Lv1")
                }, {
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv1"):get_field("_Absorption_Lv2"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv2"):get_field("_Absorption_Lv2"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv3"):get_field("_Absorption_Lv2")
                }, {
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv1"):get_field("_ActivationTime_Lv1"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv2"):get_field("_ActivationTime_Lv1"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv3"):get_field("_ActivationTime_Lv1")
                }, {
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv1"):get_field("_ActivationTime_Lv2"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv2"):get_field("_ActivationTime_Lv2"),
                    equip_skill_parameter:get_field("_EquipSkill_232"):get_field("_SkillLv3"):get_field("_ActivationTime_Lv2")
                } }
            }
        },
        KitchenSkill = {
            _002 = {
                Enum      = "Pl_KitchenSkill_002",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_002"),
                Notice    = { true, true },
                Condition = { false },
                Param     = {
                    odango_skill_parameter:get_field("_KitchenSkill_002_Lv1"):get_field("_EnableHP"),
                    odango_skill_parameter:get_field("_KitchenSkill_002_Lv2"):get_field("_EnableHP"),
                    odango_skill_parameter:get_field("_KitchenSkill_002_Lv3"):get_field("_EnableHP"),
                    odango_skill_parameter:get_field("_KitchenSkill_002_Lv4"):get_field("_EnableHP")
                }
            },
            _024 = {
                Enum      = "Pl_KitchenSkill_024",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_024"),
                Notice    = { true, false },
                Condition = { false },
                Param     = {}
            },
            _027 = {
                Enum      = "Pl_KitchenSkill_027",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_027"),
                Notice    = { true, true },
                Condition = {},
                Param     = {}
            },
            _030 = {
                Enum      = "Pl_KitchenSkill_030",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_030"),
                Notice    = { true, false },
                Condition = {},
                Param     = {}
            },
            _031 = {
                Enum      = "Pl_KitchenSkill_031",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_031"),
                Notice    = { true, false },
                Condition = {},
                Param     = {}
            },
            _048 = {
                Enum      = "Pl_KitchenSkill_048",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_048"),
                Notice    = { true, false },
                Condition = { false },
                Param     = { {
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv1_Damage"),
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv2_Damage"),
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv3_Damage"),
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv4_Damage")
                }, {
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv1_Reduce"),
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv2_Reduce"),
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv3_Reduce"),
                    odango_skill_parameter:get_field("_KitchenSkill_048_Lv4_Reduce")
                } }
            },
            _051 = {
                Enum      = "Pl_KitchenSkill_051",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_051"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { odango_skill_parameter:get_field("_KitchenSkill_051_Lv4_AtkDuration") * 60 }
            },
            _054 = {
                Enum      = "Pl_KitchenSkill_054",
                Id        = get_player_kitchen_skill_id("Pl_KitchenSkill_054"),
                Notice    = { true, true },
                Condition = { false },
                Param     = { odango_skill_parameter:get_field("_KitchenSkill_054_Time") * 60 }
            }
        }
    }
end

local function get_ui()
    return {
        OnMenu = {
            name        = set_rgb_color_to_string("Improved Skill Notifications", 0x00, 0xFF, 0xFF),
            description = ""
        },
        Slider = {
            label             = { set_rgb_color_to_string("R", 0xFF, 0x00, 0x00), set_rgb_color_to_string("G", 0x00, 0xFF, 0x00), set_rgb_color_to_string("B", 0x00, 0x00, 0xFF) },
            curValue          = {},
            min               = 0x0,
            max               = 0xFF,
            toolTip           = "",
            isImmediateUpdate = false,
            wasChanged        = nil,
            newValue          = nil
        },
        Options = {
            Selector = {
                label             = get_message_by_name("Comn_TargetSelect_00"),
                curValue          = 1,
                optionNames       = { get_message_by_name("FacilityCommonMenu_14"), get_message_by_name("CharMakeMsg_Me_193") },
                optionMessages    = "",
                toolTip           = "",
                isImmediateUpdate = false,
                wasChanged        = nil,
                newIndex          = nil
            },
            EquipSkills = {
                label             = get_message_by_name("CharMakeMsg_Me_166"),
                curValue          = 1,
                optionNames       = { get_message_by_name("COMN_ITEMFILTER_01"), get_message_by_name("COMN_SkillDetail_03") },
                optionMessages    = "",
                toolTip           = "",
                isImmediateUpdate = false,
                wasChanged        = nil,
                newIndex          = nil,
                isFilter          = false
            },
            SkillSettings = {
                label             = "",
                curValue          = {},
                optionNames       = {},
                optionMessages    = "",
                toolTip           = "",
                isImmediateUpdate = false,
                wasChanged        = nil,
                newIndex          = nil,
                msg               = {
                    get_message_by_name("STM_ASE_Menu_005"),
                    set_color_name_to_string(get_message_by_name("Option_Me_Item_107_01_MR"), "YEL"),
                    set_color_name_to_string(get_message_by_name("Option_Me_Item_107_02_MR"), "RED"),
                    set_color_name_to_string(get_message_by_name("ChatMenu_LogMenu_16"), "GRAY")
                }
            },
            COLOR = {
                label             = {},
                curValue          = {},
                optionNames       = { get_message_by_name("CharMakeMsg_Me_100"), get_message_by_name("CharMakeMsg_Me_101") },
                optionMessages    = "",
                toolTip           = "",
                isImmediateUpdate = false,
                wasChanged        = nil,
                newIndex          = nil
            }
        },
        Header = {
            EquipSkill = {
                text = get_message_by_name("FacilityCommonMenu_14")
            },
            KitchenSkill = {
                text = get_message_by_name("COMN_SkillDetailTab_04")
            }
        },
        Label = {
            label = get_message_by_name("DialogMsg_System_NSW_DataLoad_NG"),
            displayValue = "",
            toolTip = get_message_by_name("StartMenu_System_Common_GrayOut")
        },
        MSG = {
            Pl = {
                get_message_by_name("ChatLog_Pl_Skill_01"),
                get_message_by_name("ChatLog_Pl_Skill_02")
            },
            Ot = {
                get_message_by_name("ChatLog_Ot_Skill_01"),
                get_message_by_name("ChatLog_Ot_Skill_02"),
                get_message_by_name("ChatLog_Ot_Skill_03")
            },
            Co = {
                get_message_by_name("ChatLog_Co_Skill_01")
            }
        }
    }
end
local UI                           = get_ui()

local get_equip_skill_name         = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
local get_kitchen_skill_name       = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlKitchenSkillId)")
local GUI_COMMON_MEAL_SKILL_NOTICE = sdk.find_type_definition("snow.gui.COMMON"):get_field("GUI_COMMON_MEAL_SKILL_NOTICE"):get_data(nil)
local function AddChatInfomation(type, skill_id, is_skill_active)
    local chat_manager, post_message
    if not chat_manager then chat_manager = get_chat_manager() end

    local get_skill_name = {
        get_equip_skill_name,
        get_kitchen_skill_name
    }
    local pre_message = {
        UI.MSG.Pl[1],
        UI.MSG.Pl[2],
        UI.MSG.Co[1]
    }

    if type == 1 or type == 2 then
        post_message = pre_message[is_skill_active and 1 or 2]:gsub("{0}", get_skill_name[type](nil, skill_id))
    elseif type == 3 then
        post_message = pre_message[type]
    end

    chat_manager:call("reqAddChatInfomation(System.String, System.UInt32)", post_message, GUI_COMMON_MEAL_SKILL_NOTICE)
end

-- local isEquipSkill091
-- sdk.hook(sdk.find_type_definition("snow.player.PlayerBase"):get_method("isEquipSkill091()"),
--     function(args)
--     end,
--     function(retval)
--         if sdk.to_int64(retval) == 1 then
--             isEquipSkill091 = true
--         else
--             isEquipSkill091 = false
--         end

--         return retval
--     end)

local end_flow_type = sdk.find_type_definition("snow.QuestManager.EndFlow")
local Pl, Sd, St
local player_manager, master_player_id, player_base, player_data, player_skill_list, gui_manager, gui_hud, player_info, quest_manager
sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("update()"),
    function(args)
        if not player_manager then player_manager = get_player_manager() end
        if not player_manager then return end

        if not master_player_id then master_player_id = get_master_player_id(player_manager) end
        if not master_player_id then return end

        if not player_base then player_base = get_player_base(player_manager) end
        if not player_base then return end

        if not player_data then player_data = get_player_data(player_manager, master_player_id) end
        if not player_data then return end

        if not player_skill_list then player_skill_list = get_player_skill_list(player_manager, master_player_id) end
        if not player_skill_list then return end

        if not gui_manager then gui_manager = get_gui_manager() end
        if not gui_manager then return end

        if not gui_hud then gui_hud = get_gui_hud(gui_manager) end
        if not gui_hud then return end

        if not player_info then player_info = get_player_info(gui_hud) end
        if not player_info then return end

        if not quest_manager then quest_manager = get_quest_manager() end
        if not quest_manager then return end

        if not Pl then Pl = get_skill_data(player_manager) end

        Sd = {
            EquipSkill   = get_equip_skill_data(player_skill_list),
            KitchenSkill = get_kitchen_skill_data(player_skill_list)
        }

        St = {
            playerHealth                    = player_data:call("get_vital()"),
            playerMaxHealth                 = player_base:call("getVitalMax()"),
            playerRawRedHealth              = player_data:get_field("_r_Vital"),
            playerRedHealth                 = player_base:call("getRedVital()"),
            playerStamina                   = player_data:get_field("_stamina"),
            playerMaxStamina                = player_data:get_field("_staminaMax"),

            _ChallengeTimer                 = player_data:get_field("_ChallengeTimer"),
            isDebuffState                   = player_base:call("isDebuffState()"),
            _PowerFreedomTimer              = player_base:get_field("_PowerFreedomTimer"),
            _WholeBodyTimer                 = player_data:get_field("_WholeBodyTimer"),
            _SharpnessGaugeBoostTimer       = player_base:get_field("_SharpnessGaugeBoostTimer"),
            _EquipSkill_036_Timer           = player_data:get_field("_EquipSkill_036_Timer"),
            _SlidingPowerupTimer            = player_data:get_field("_SlidingPowerupTimer"),
            isEquipSkill091                 = player_base:call("isEquipSkill091()"),
            _DieCount                       = player_data:get_field("_DieCount"),
            _CounterattackPowerupTimer      = player_data:get_field("_CounterattackPowerupTimer"),
            _DisasterTurnPowerUpTimer       = player_data:get_field("_DisasterTurnPowerUpTimer"),
            _FightingSpiritTimer            = player_data:get_field("_FightingSpiritTimer"),
            _EquipSkill208_AtkUpTimer       = player_data:get_field("_EquipSkill208_AtkUpTimer"),
            _BrandNewSharpnessAdjustUpTimer = player_data:get_field("_BrandNewSharpnessAdjustUpTimer"),
            _EquipSkill216_BottleUpTimer    = player_base:get_field("_EquipSkill216_BottleUpTimer"),
            isHaveSkillGuts                 = player_info:get_field("isHaveSkillGuts"),
            _EquipSkill222_Timer            = player_data:get_field("_EquipSkill222_Timer"),
            _EquipSkill223Accumulator       = player_data:get_field("_EquipSkill223Accumulator"),
            isHateTarget                    = player_base:call("isHateTarget()"),
            _IsEquipSkill226Enable          = player_base:get_field("_IsEquipSkill226Enable"),
            _EquipSkill227State             = player_data:get_field("_EquipSkill227State"),
            get_IsEnableEquipSkill225       = player_base:call("get_IsEnableEquipSkill225()"),
            _EquipSkill229UseUpFlg          = player_base:get_field("_EquipSkill229UseUpFlg"),
            isActiveEquipSkill230           = player_base:call("isActiveEquipSkill230()"),
            _EquipSkill231_WireNumTimer     = player_data:get_field("_EquipSkill231_WireNumTimer"),
            _EquipSkill231_WpOffTimer       = player_data:get_field("_EquipSkill231_WpOffTimer"),
            _EquipSkill232Absorption        = player_data:get_field("_EquipSkill232Absorption"),
            _EquipSkill232Timer             = player_data:get_field("_EquipSkill232Timer"),

            isHaveKitchenGuts               = player_info:get_field("isHaveKitchenGuts"),
            _KitchenSkill048_Damage         = player_data:get_field("_KitchenSkill048_Damage"),
            _KitchenSkill051_AtkUpTimer     = player_data:get_field("_KitchenSkill051_AtkUpTimer"),
            _KitchenSkill054_Timer          = player_data:get_field("_KitchenSkill054_Timer"),

            _EndFlow                        = quest_manager:get_field("_EndFlow"),
            Flows                           = {
                [end_flow_type:get_field("WaitFadeCameraDemo"):get_data(nil)] = true,
                [end_flow_type:get_field("LoadCameraDemo"):get_data(nil)]     = true,
                [end_flow_type:get_field("LoadWaitCameraDemo"):get_data(nil)] = true,
                [end_flow_type:get_field("StartCameraDemo"):get_data(nil)]    = true,
                [end_flow_type:get_field("CameraDemo"):get_data(nil)]         = true,
                [end_flow_type:get_field("Stamp"):get_data(nil)]              = true,
                [end_flow_type:get_field("WaitFadeOut"):get_data(nil)]        = true
            }
        }

        if St.Flows[St._EndFlow] then return end

        if is_changed_language() then UI = get_ui() end

        -- 0 Pl_EquipSkill_None
        -- 1 Pl_EquipSkill_000 攻撃
        -- 2 Pl_EquipSkill_001 挑戦者
        if Sd.EquipSkill[Pl.EquipSkill._001.Id] then
            if not Pl.EquipSkill._001.Condition[1] and St._ChallengeTimer == Pl.EquipSkill._001.Param[1] then
                Pl.EquipSkill._001.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._001.Id, Pl.EquipSkill._001.Condition[1])
            elseif Pl.EquipSkill._001.Condition[1] and St._ChallengeTimer == 0 then
                Pl.EquipSkill._001.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._001.Id, Pl.EquipSkill._001.Condition[1])
            end
        end
        -- 3 Pl_EquipSkill_002 フルチャージ
        if Sd.EquipSkill[Pl.EquipSkill._002.Id] then
            if not Pl.EquipSkill._002.Condition[1] and St.playerHealth == St.playerMaxHealth then
                Pl.EquipSkill._002.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._002.Id, Pl.EquipSkill._002.Condition[1])
            elseif Pl.EquipSkill._002.Condition[1] and St.playerHealth < St.playerMaxHealth then
                Pl.EquipSkill._002.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._002.Id, Pl.EquipSkill._002.Condition[1])
            end
        end
        -- 4 Pl_EquipSkill_003 逆恨み
        if Sd.EquipSkill[Pl.EquipSkill._003.Id] then
            if not Pl.EquipSkill._003.Condition[1] then
                if St.get_IsEnableEquipSkill225 or St.playerRedHealth > 0 then
                    Pl.EquipSkill._003.Condition[1] = true
                    AddChatInfomation(1, Pl.EquipSkill._003.Id, Pl.EquipSkill._003.Condition[1])
                end
            elseif Pl.EquipSkill._003.Condition[1] and not St.get_IsEnableEquipSkill225 and St.playerHealth == St.playerRawRedHealth and St.playerRedHealth == 0 then
                Pl.EquipSkill._003.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._003.Id, Pl.EquipSkill._003.Condition[1])
            end
        end
        -- 5 Pl_EquipSkill_004 死中に活
        if Sd.EquipSkill[Pl.EquipSkill._004.Id] then
            if not Pl.EquipSkill._004 and St.isDebuffState then
                Pl.EquipSkill._004 = true
                AddChatInfomation(1, Pl.EquipSkill._004.Id, Pl.EquipSkill._004)
            elseif Pl.EquipSkill._004 and not St.isDebuffState then
                Pl.EquipSkill._004 = false
                AddChatInfomation(1, Pl.EquipSkill._004.Id, Pl.EquipSkill._004)
            end
        end
        -- 6 Pl_EquipSkill_005 見切り
        -- 7 Pl_EquipSkill_006 超会心
        -- 8 Pl_EquipSkill_007 弱点特効
        -- 9 Pl_EquipSkill_008 力の解放
        if Sd.EquipSkill[Pl.EquipSkill._008.Id] then
            if not Pl.EquipSkill._008.Condition[1] and St._PowerFreedomTimer == Pl.EquipSkill._001.Param[1] then
                Pl.EquipSkill._008.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._008.Id, Pl.EquipSkill._008.Condition[1])
            elseif Pl.EquipSkill._008.Condition[1] and St._PowerFreedomTimer == 0 then
                Pl.EquipSkill._008.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._008.Id, Pl.EquipSkill._008.Condition[1])
            end
        end
        -- 10 Pl_EquipSkill_009 渾身
        if Sd.EquipSkill[Pl.EquipSkill._009.Id] then
            if not Pl.EquipSkill._009.Condition[1] and not Pl.EquipSkill._009.Condition[2] and St.playerStamina == St.playerMaxStamina and St._WholeBodyTimer > Pl.EquipSkill._009.Param[1] then
                Pl.EquipSkill._009.Condition[2] = true
            elseif Pl.EquipSkill._009.Condition[2] and St.playerStamina < St.playerMaxStamina then
                Pl.EquipSkill._009.Condition[2] = false
            elseif Pl.EquipSkill._009.Condition[2] and St._WholeBodyTimer == 0 then
                Pl.EquipSkill._009.Condition[1] = true
                Pl.EquipSkill._009.Condition[2] = false
                AddChatInfomation(1, Pl.EquipSkill._009.Id, Pl.EquipSkill._009.Condition[1])
            elseif Pl.EquipSkill._009.Condition[1] and not Pl.EquipSkill._009.Condition[3] and St.playerStamina < St.playerMaxStamina and St._WholeBodyTimer == 0 then
                Pl.EquipSkill._009.Condition[3] = true
            elseif Pl.EquipSkill._009.Condition[1] and Pl.EquipSkill._009.Condition[3] and St.playerStamina < St.playerMaxStamina and St._WholeBodyTimer == 0 then
                Pl.EquipSkill._009.Condition[1] = false
                Pl.EquipSkill._009.Condition[3] = false
                AddChatInfomation(1, Pl.EquipSkill._009.Id, Pl.EquipSkill._009.Condition[1])
            end
        end
        -- 11 Pl_EquipSkill_010 会心撃【属性】
        -- 12 Pl_EquipSkill_011 達人芸
        -- 13 Pl_EquipSkill_012 火属性攻撃強化
        -- 14 Pl_EquipSkill_013 水属性攻撃強化
        -- 15 Pl_EquipSkill_014 氷属性攻撃強化
        -- 16 Pl_EquipSkill_015 雷属性攻撃強化
        -- 17 Pl_EquipSkill_016 龍属性攻撃強化
        -- 18 Pl_EquipSkill_017 毒属性強化
        -- 19 Pl_EquipSkill_018 麻痺属性強化
        -- 20 Pl_EquipSkill_019 睡眠属性強化
        -- 21 Pl_EquipSkill_020 爆破属性強化
        -- 22 Pl_EquipSkill_021 匠
        -- 23 Pl_EquipSkill_022 業物
        -- 24 Pl_EquipSkill_023 弾丸節約

        -- 25 Pl_EquipSkill_024 剛刃研磨
        if Sd.EquipSkill[Pl.EquipSkill._024.Id] then
            if St._SharpnessGaugeBoostTimer == Pl.EquipSkill._024.Param[Sd.EquipSkill[Pl.EquipSkill._024.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._024.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._024.Id, Pl.EquipSkill._024.Condition[1])
            elseif Pl.EquipSkill._024.Condition[1] and St._SharpnessGaugeBoostTimer == 0 then
                Pl.EquipSkill._024.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._024.Id, Pl.EquipSkill._024.Condition[1])
            end
        end
        -- 26 Pl_EquipSkill_025 心眼
        -- 27 Pl_EquipSkill_026 弾導強化
        -- 28 Pl_EquipSkill_027 鈍器使い
        -- 29 Pl_EquipSkill_028 弓溜め段階解放
        -- 30 Pl_EquipSkill_029 集中
        -- 31 Pl_EquipSkill_030 強化持続
        -- 32 Pl_EquipSkill_031 ランナー
        -- 33 Pl_EquipSkill_032 体術
        -- 34 Pl_EquipSkill_033 スタミナ急速回復
        -- 35 Pl_EquipSkill_034 ガード性能
        -- 36 Pl_EquipSkill_035 ガード強化
        -- 37 Pl_EquipSkill_036 攻めの守勢
        if Sd.EquipSkill[Pl.EquipSkill._036.Id] then
            if St._EquipSkill_036_Timer == Pl.EquipSkill._036.Param[1] then
                Pl.EquipSkill._036.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._036.Id, Pl.EquipSkill._036.Condition[1])
            elseif Pl.EquipSkill._036.Condition[1] and St._EquipSkill_036_Timer == 0 then
                Pl.EquipSkill._036.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._036.Id, Pl.EquipSkill._036.Condition[1])
            end
        end
        -- 38 Pl_EquipSkill_037 抜刀術【技】
        -- 39 Pl_EquipSkill_038 抜刀術【力】
        -- 40 Pl_EquipSkill_039 納刀術
        -- 41 Pl_EquipSkill_040 ＫＯ術
        -- 42 Pl_EquipSkill_041 スタミナ奪取
        -- 43 Pl_EquipSkill_042 滑走強化
        if Sd.EquipSkill[Pl.EquipSkill._042.Id] then
            if not Pl.EquipSkill._042.Condition[1] and St._SlidingPowerupTimer == Pl.EquipSkill._042.Param[1] then
                Pl.EquipSkill._042.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._042.Id, Pl.EquipSkill._042.Condition[1])
            elseif Pl.EquipSkill._042.Condition[1] and St._SlidingPowerupTimer == 0 then
                Pl.EquipSkill._042.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._042.Id, Pl.EquipSkill._042.Condition[1])
            end
        end
        -- 44 Pl_EquipSkill_043 笛吹き名人
        -- 45 Pl_EquipSkill_044 砲術
        -- 46 Pl_EquipSkill_045 砲弾装填
        -- 47 Pl_EquipSkill_046 特殊射撃強化
        -- 48 Pl_EquipSkill_047 通常弾・連射矢強化
        -- 49 Pl_EquipSkill_048 貫通弾・貫通矢強化
        -- 50 Pl_EquipSkill_049 散弾・拡散矢強化
        -- 51 Pl_EquipSkill_050 装填拡張
        -- 52 Pl_EquipSkill_051 装填速度
        -- 53 Pl_EquipSkill_052 反動軽減
        -- 54 Pl_EquipSkill_053 ブレ抑制
        -- 55 Pl_EquipSkill_054 速射強化
        -- 56 Pl_EquipSkill_055 防御
        -- 57 Pl_EquipSkill_056 精霊の加護
        -- 58 Pl_EquipSkill_057 体力回復量ＵＰ
        -- 59 Pl_EquipSkill_058 回復速度
        -- 60 Pl_EquipSkill_059 早食い
        -- 61 Pl_EquipSkill_060 耳栓
        -- 62 Pl_EquipSkill_061 風圧耐性
        -- 63 Pl_EquipSkill_062 耐震
        -- 64 Pl_EquipSkill_063 泡沫の舞
        -- 65 Pl_EquipSkill_064 回避性能
        -- 66 Pl_EquipSkill_065 回避距離ＵＰ
        -- 67 Pl_EquipSkill_066 火耐性
        -- 68 Pl_EquipSkill_067 水耐性
        -- 69 Pl_EquipSkill_068 氷耐性
        -- 70 Pl_EquipSkill_069 雷耐性
        -- 71 Pl_EquipSkill_070 龍耐性
        -- 72 Pl_EquipSkill_071 属性やられ耐性
        -- 73 Pl_EquipSkill_072 毒耐性
        -- 74 Pl_EquipSkill_073 麻痺耐性
        -- 75 Pl_EquipSkill_074 睡眠耐性
        -- 76 Pl_EquipSkill_075 気絶耐性
        -- 77 Pl_EquipSkill_076 泥雪耐性
        -- 78 Pl_EquipSkill_077 爆破やられ耐性
        -- 79 Pl_EquipSkill_078 植生学
        -- 80 Pl_EquipSkill_079 地質学
        -- 81 Pl_EquipSkill_080 破壊王
        -- 82 Pl_EquipSkill_081 捕獲名人
        -- 83 Pl_EquipSkill_082 剥ぎ取り名人
        -- 84 Pl_EquipSkill_083 幸運
        -- 85 Pl_EquipSkill_084 砥石使用高速化
        -- 86 Pl_EquipSkill_085 ボマー
        -- 87 Pl_EquipSkill_086 キノコ大好き
        -- 88 Pl_EquipSkill_087 アイテム使用強化
        -- 89 Pl_EquipSkill_088 広域化
        -- 90 Pl_EquipSkill_089 満足感

        -- 91 Pl_EquipSkill_090 火事場力
        if Sd.EquipSkill[Pl.EquipSkill._090.Id] then
            if not Pl.EquipSkill._090.Condition[1] and not Pl.KitchenSkill._002.Condition[1] and St.playerHealth <= St.playerMaxHealth * Pl.EquipSkill._090.Param[1] then
                Pl.EquipSkill._090.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._090.Id, Pl.EquipSkill._090.Condition[1])
            elseif Pl.EquipSkill._090.Condition[1] and St.playerHealth > St.playerMaxHealth * Pl.EquipSkill._090.Param[1] then
                Pl.EquipSkill._090.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._090.Id, Pl.EquipSkill._090.Condition[1])
            end
        end
        -- 92 Pl_EquipSkill_091 不屈
        if St.isEquipSkill091 then
            if Sd.EquipSkill[Pl.EquipSkill._091.Id] then
                if St._DieCount - Pl.EquipSkill._091.Param[1] > 0 or (St._DieCount > 0 and not Pl.EquipSkill._091.Condition[1]) then
                    Pl.EquipSkill._091.Param[1] = St._DieCount
                    Pl.EquipSkill._091.Condition[1] = true
                    AddChatInfomation(1, Pl.EquipSkill._091.Id, Pl.EquipSkill._091.Condition[1])
                elseif Pl.EquipSkill._091.Condition[1] and St._DieCount - Pl.EquipSkill._091.Param[1] < 0 then
                    Pl.EquipSkill._091.Condition[1] = false
                    AddChatInfomation(1, Pl.EquipSkill._091.Id, Pl.EquipSkill._091.Condition[1])
                end
            elseif not Sd.EquipSkill[Pl.EquipSkill._091.Id] and Pl.EquipSkill._091.Condition[1] then
                Pl.EquipSkill._091.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._091.Id, Pl.EquipSkill._091.Condition[1])
            end
        end
        -- 93 Pl_EquipSkill_092 ひるみ軽減
        -- 94 Pl_EquipSkill_093 ジャンプ鉄人
        -- 95 Pl_EquipSkill_094 剥ぎ取り鉄人
        -- 96 Pl_EquipSkill_095 腹減り耐性
        -- 97 Pl_EquipSkill_096 飛び込み
        -- 98 Pl_EquipSkill_097 陽動
        -- 99 Pl_EquipSkill_098 乗り名人
        -- 100 Pl_EquipSkill_099 霞皮の恩恵
        -- 101 Pl_EquipSkill_100 鋼殻の恩恵
        -- 102 Pl_EquipSkill_101 炎鱗の恩恵
        -- 103 Pl_EquipSkill_102 龍気活性
        if Sd.EquipSkill[Pl.EquipSkill._102.Id] then
            if not Pl.EquipSkill._102.Condition[1] and St.playerHealth <= St.playerMaxHealth * Pl.EquipSkill._102.Param[Sd.EquipSkill[Pl.EquipSkill._102.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._102.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._102.Id, Pl.EquipSkill._102.Condition[1])
            elseif Pl.EquipSkill._102.Condition[1] and St.playerHealth > St.playerMaxHealth * Pl.EquipSkill._102.Param[Sd.EquipSkill[Pl.EquipSkill._102.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._102.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._102.Id, Pl.EquipSkill._102.Condition[1])
            end
        end
        -- 104 Pl_EquipSkill_103 翔蟲使い
        -- 105 Pl_EquipSkill_104 壁面移動
        -- 106 Pl_EquipSkill_105 逆襲
        if Sd.EquipSkill[Pl.EquipSkill._105.Id] then
            if St._CounterattackPowerupTimer == Pl.EquipSkill._105.Param[1] then
                Pl.EquipSkill._105.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._105.Id, Pl.EquipSkill._105.Condition[1])
            elseif Pl.EquipSkill._105.Condition[1] and St._CounterattackPowerupTimer == 0 then
                Pl.EquipSkill._105.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._105.Id, Pl.EquipSkill._105.Condition[1])
            end
        end
        -- 107 Pl_EquipSkill_106 高速変形
        -- 108 Pl_EquipSkill_107 鬼火纏
        -- 109 Pl_EquipSkill_108 風紋の一致
        -- 110 Pl_EquipSkill_109 雷紋の一致
        -- 111 Pl_EquipSkill_110 風雷合一
        -- 112 Pl_EquipSkill_200 血氣
        -- 113 Pl_EquipSkill_201 伏魔響命
        -- 114 Pl_EquipSkill_202 激昂
        -- 115 Pl_EquipSkill_203 業鎧【修羅】
        -- 116 Pl_EquipSkill_204 災禍転福
        if Sd.EquipSkill[Pl.EquipSkill._204.Id] then
            if not Pl.EquipSkill._204.Condition[1] and St._DisasterTurnPowerUpTimer == Pl.EquipSkill._204.Param[1] then
                Pl.EquipSkill._204.Condition[1] = true
            elseif Pl.EquipSkill._204.Condition[1] and St._DisasterTurnPowerUpTimer == 0 then
                Pl.EquipSkill._204.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._204.Id, Pl.EquipSkill._204.Condition[1])
            end
        end
        -- 117 Pl_EquipSkill_205 狂竜症【蝕】
        -- 118 Pl_EquipSkill_206 顕如盤石
        if Sd.EquipSkill[Pl.EquipSkill._206.Id] then
            if not Pl.EquipSkill._206.Condition[1] and St._FightingSpiritTimer == Pl.EquipSkill._001.Param[1] then
                Pl.EquipSkill._206.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._206.Id, Pl.EquipSkill._206.Condition[1])
            elseif Pl.EquipSkill._206.Condition[1] and St._FightingSpiritTimer == 0 then
                Pl.EquipSkill._206.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._206.Id, Pl.EquipSkill._206.Condition[1])
            end
        end
        -- 119 Pl_EquipSkill_207 闇討ち
        -- 120 Pl_EquipSkill_208 巧撃
        if Sd.EquipSkill[Pl.EquipSkill._208.Id] then
            if St._EquipSkill208_AtkUpTimer == Pl.EquipSkill._208.Param[Sd.EquipSkill[Pl.EquipSkill._208.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._208.Condition[1] = true
            elseif Pl.EquipSkill._208.Condition[1] and St._EquipSkill208_AtkUpTimer == 0 then
                Pl.EquipSkill._208.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._208.Id, Pl.EquipSkill._208.Condition[1])
            end
        end
        -- 121 Pl_EquipSkill_209 煽衛
        if Sd.EquipSkill[Pl.EquipSkill._209.Id] then
            if not Pl.EquipSkill._209.Condition[1] and St.isHateTarget then
                Pl.EquipSkill._209.Condition[1] = true
            elseif Pl.EquipSkill._209.Condition[1] and not St.isHateTarget then
                Pl.EquipSkill._209.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._209.Id, Pl.EquipSkill._209.Condition[1])
            end
        end
        -- 122 Pl_EquipSkill_210 合気
        -- 123 Pl_EquipSkill_211 供応
        -- 124 Pl_EquipSkill_212 チャージマスター
        -- 125 Pl_EquipSkill_213 攻勢
        -- 126 Pl_EquipSkill_214 チューンアップ
        -- 127 Pl_EquipSkill_215 研磨術【鋭】
        if Sd.EquipSkill[Pl.EquipSkill._215.Id] then
            if St._BrandNewSharpnessAdjustUpTimer == Pl.EquipSkill._215.Param[Sd.EquipSkill[Pl.EquipSkill._215.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._215.Condition[1] = true
            elseif Pl.EquipSkill._215.Condition[1] and St._BrandNewSharpnessAdjustUpTimer == 0 then
                Pl.EquipSkill._215.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._215.Id, Pl.EquipSkill._215.Condition[1])
            end
        end
        -- 128 Pl_EquipSkill_216 刃鱗磨き
        if Sd.EquipSkill[Pl.EquipSkill._216.Id] then
            if St._EquipSkill216_BottleUpTimer == Pl.EquipSkill._216.Param[Sd.EquipSkill[Pl.EquipSkill._216.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._216.Condition[1] = true
            elseif Pl.EquipSkill._216.Condition[1] and St._EquipSkill216_BottleUpTimer == 0 then
                Pl.EquipSkill._216.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._216.Id, Pl.EquipSkill._216.Condition[1])
            end
        end
        -- 129 Pl_EquipSkill_217 壁面移動【翔】
        -- 130 Pl_EquipSkill_218 弱点特効【属性】
        -- 131 Pl_EquipSkill_219 連撃
        -- 132 Pl_EquipSkill_220 根性
        if Sd.EquipSkill[Pl.EquipSkill._220.Id] and not Pl.EquipSkill._220.Condition[1] and St.isHaveSkillGuts then
            Pl.EquipSkill._220.Condition[1] = true
        elseif not Sd.EquipSkill[Pl.EquipSkill._220.Id] and Pl.EquipSkill._220.Condition[1] and not St.isHaveSkillGuts then
            AddChatInfomation(1, Pl.EquipSkill._220.Id, Pl.EquipSkill._220.Condition[1])
            Pl.EquipSkill._220.Condition[1] = false
        end
        -- 133 Pl_EquipSkill_221 疾之息吹
        -- 134 Pl_EquipSkill_222 状態異常確定蓄積
        if Sd.EquipSkill[Pl.EquipSkill._222.Id] then
            if St._EquipSkill222_Timer == Pl.EquipSkill._222.Param[Sd.EquipSkill[Pl.EquipSkill._222.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._222.Condition[1] = true
            elseif Pl.EquipSkill._222.Condition[1] and St._EquipSkill222_Timer == 0 then
                Pl.EquipSkill._222.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._222.Id, Pl.EquipSkill._222.Condition[1])
            end
        end
        -- 135 Pl_EquipSkill_223 剛心
        if Sd.EquipSkill[Pl.EquipSkill._223.Id] then
            if not Pl.EquipSkill._223.Condition[1] and St._EquipSkill223Accumulator == Pl.EquipSkill._223.Param[2][1] then
                Pl.EquipSkill._223.Condition[1] = true
            end
        end
        -- 136 Pl_EquipSkill_224 蓄積時攻撃強化
        -- 137 Pl_EquipSkill_225 狂化
        -- 138 Pl_EquipSkill_226 風纏
        if Sd.EquipSkill[Pl.EquipSkill._226.Id] then
            if not Pl.EquipSkill._226.Condition[1] and St._IsEquipSkill226Enable then
                Pl.EquipSkill._226.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._226.Id, Pl.EquipSkill._226.Condition[1])
            elseif Pl.EquipSkill._226.Condition[1] and not St._IsEquipSkill226Enable then
                Pl.EquipSkill._226.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._226.Id, Pl.EquipSkill._226.Condition[1])
            end
        end
        -- 139 Pl_EquipSkill_227 粉塵纏
        if Sd.EquipSkill[Pl.EquipSkill._227.Id] then
            if not Pl.EquipSkill._227.Condition[1] and St._EquipSkill227State ~= 0 then
                Pl.EquipSkill._227.Condition[1] = true
            elseif Pl.EquipSkill._227.Condition[1] and St._EquipSkill227State == 0 then
                AddChatInfomation(1, Pl.EquipSkill._227.Id, Pl.EquipSkill._227.Condition[1])
                Pl.EquipSkill._227.Condition[1] = false
            end
        end
        -- 140 Pl_EquipSkill_228 冰気錬成
        -- 141 Pl_EquipSkill_229 龍気変換
        if Sd.EquipSkill[Pl.EquipSkill._229.Id] then
            if not Pl.EquipSkill._229.Condition[1] and St._EquipSkill229UseUpFlg then
                Pl.EquipSkill._229.Condition[1] = true
                AddChatInfomation(1, Pl.EquipSkill._229.Id, Pl.EquipSkill._229.Condition[1])
            elseif Pl.EquipSkill._229.Condition[1] and not St._EquipSkill229UseUpFlg then
                Pl.EquipSkill._229.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._229.Id, Pl.EquipSkill._229.Condition[1])
            end
        end
        -- 142 Pl_EquipSkill_230 天衣無崩
        if Sd.EquipSkill[Pl.EquipSkill._230.Id] then
            if not Pl.EquipSkill._230.Condition[1] and St.isActiveEquipSkill230 then
                Pl.EquipSkill._230.Condition[1] = true
            elseif Pl.EquipSkill._230.Condition[1] and not St.isActiveEquipSkill230 then
                Pl.EquipSkill._230.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._230.Id, Pl.EquipSkill._230.Condition[1])
            end
        end
        -- 143 Pl_EquipSkill_231 狂竜症【翔】
        if Sd.EquipSkill[Pl.EquipSkill._231.Id] then
            if not Pl.EquipSkill._231.Condition[1] and St._EquipSkill231_WireNumTimer == Pl.EquipSkill._231.Param[Sd.EquipSkill[Pl.EquipSkill._231.Id]:get_field("SkillLv")] then
                Pl.EquipSkill._231.Condition[1] = true
            elseif Pl.EquipSkill._231.Condition[1] and St._EquipSkill231_WpOffTimer == 0 then
                Pl.EquipSkill._231.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._231.Id, Pl.EquipSkill._231.Condition[1])
            end
        end
        -- 144 Pl_EquipSkill_232 血氣覚醒
        if Sd.EquipSkill[Pl.EquipSkill._232.Id] then
            if not Pl.EquipSkill._232.Condition[1] then
                if St._EquipSkill232Absorption >= Pl.EquipSkill._232.Param[1][Sd.EquipSkill[Pl.EquipSkill._232.Id]:get_field("SkillLv")] and St._EquipSkill232Timer == Pl.EquipSkill._232.Param[3][Sd.EquipSkill[Pl.EquipSkill._232.Id]:get_field("SkillLv")] then
                    Pl.EquipSkill._232.Condition[1] = true
                elseif St._EquipSkill232Absorption >= Pl.EquipSkill._232.Param[2][Sd.EquipSkill[Pl.EquipSkill._232.Id]:get_field("SkillLv")] and St._EquipSkill232Timer == Pl.EquipSkill._232.Param[4][Sd.EquipSkill[Pl.EquipSkill._232.Id]:get_field("SkillLv")] then
                    Pl.EquipSkill._232.Condition[1] = true
                end
            elseif Pl.EquipSkill._232.Condition[1] and St._EquipSkill232Timer == 0 then
                Pl.EquipSkill._232.Condition[1] = false
                AddChatInfomation(1, Pl.EquipSkill._232.Id, Pl.EquipSkill._232.Condition[1])
            end
        end
        -- 145 Pl_EquipSkill_233 奮闘
        -- 146 Pl_EquipSkill_234 緩衝
        -- 147 Pl_EquipSkill_235 激励
        -- 148 Pl_EquipSkill_236
        -- 149 Pl_EquipSkill_237
        -- 150 Pl_EquipSkill_238
        -- 151 Pl_EquipSkill_239
        -- 152 Pl_EquipSkill_240
        -- 153 Pl_EquipSkill_241
        -- 154 Pl_EquipSkill_242
        -- 155 Pl_EquipSkill_243
        -- 156 Pl_EquipSkill_244
        -- 157 Pl_EquipSkill_245
        -- 158 Pl_EquipSkill_246
        -- 159 Pl_EquipSkill_247
        -- 160 Pl_EquipSkill_248
        -- 161 Pl_EquipSkill_249
        -- 162 Pl_EquipSkill_250
        -- 163 Pl_EquipSkill_251
        -- 164 Pl_EquipSkill_252
        -- 165 Pl_EquipSkill_253
        -- 166 Pl_EquipSkill_254
        -- 167 Pl_EquipSkill_255
        -- 148 PlEquipSkillId_Max
        -- 148 Max
        -- 149 Error


        -- 0 Pl_KitchenSkill_None
        -- 1 Pl_KitchenSkill_000 おだんご研磨術
        -- 2 Pl_KitchenSkill_001 おだんご乗り上手
        -- 3 Pl_KitchenSkill_002 おだんご火事場力
        if Sd.KitchenSkill[Pl.KitchenSkill._002.Id] then
            if not Pl.KitchenSkill._002.Condition[1] and St.playerHealth <= Pl.KitchenSkill._002.Param[Sd.KitchenSkill[Pl.KitchenSkill._002.Id]:get_field("_SkillLv")] then
                Pl.KitchenSkill._002.Condition[1] = true
                AddChatInfomation(2, Pl.KitchenSkill._002.Id, Pl.KitchenSkill._002.Condition[1])
            elseif Pl.KitchenSkill._002.Condition[1] and St.playerHealth > Pl.KitchenSkill._002.Param[Sd.KitchenSkill[Pl.KitchenSkill._002.Id]:get_field("_SkillLv")] then
                Pl.KitchenSkill._002.Condition[1] = false
                AddChatInfomation(2, Pl.KitchenSkill._002.Id, Pl.KitchenSkill._002.Condition[1])
            end
        end
        -- 4 Pl_KitchenSkill_003 おだんご解体術【小】
        -- 5 Pl_KitchenSkill_004 おだんご解体術【大】
        -- 6 Pl_KitchenSkill_005 おだんご医療術【小】
        -- 7 Pl_KitchenSkill_006 おだんご医療術【大】
        -- 8 Pl_KitchenSkill_007 おだんご体術
        -- 9 Pl_KitchenSkill_008 おだんご火薬術
        -- 10 Pl_KitchenSkill_009 おだんご特殊攻撃術
        -- 11 Pl_KitchenSkill_010 おだんご防御術【小】
        -- 12 Pl_KitchenSkill_011 おだんご防御術【大】
        -- 13 Pl_KitchenSkill_012 おだんご収穫祭
        -- 14 Pl_KitchenSkill_013 おだんご射撃術
        -- 15 Pl_KitchenSkill_014 おだんご幸運術
        -- 16 Pl_KitchenSkill_015 おだんご激運術
        -- 17 Pl_KitchenSkill_016 おだんごはじかれ上手
        -- 18 Pl_KitchenSkill_017 おだんご弱いの来い！
        -- 19 Pl_KitchenSkill_018 おだんご換算術
        -- 20 Pl_KitchenSkill_019 おだんご暴れ撃ち
        -- 21 Pl_KitchenSkill_020 おだんご壁走り達人
        -- 22 Pl_KitchenSkill_021 おだんごＫＯ術
        -- 23 Pl_KitchenSkill_022 おだんご金運術
        -- 24 Pl_KitchenSkill_023 おだんご砲撃術
        -- 25 Pl_KitchenSkill_024 おだんごド根性
        if Sd.KitchenSkill[Pl.KitchenSkill._024.Id] and not Pl.KitchenSkill._024.Condition[1] and St.isHaveKitchenGuts then
            Pl.KitchenSkill._024.Condition[1] = true
        elseif not Sd.KitchenSkill[Pl.KitchenSkill._024.Id] and Pl.KitchenSkill._024.Condition[1] and not St.isHaveKitchenGuts then
            AddChatInfomation(2, Pl.KitchenSkill._024.Id, Pl.KitchenSkill._024.Condition[1])
            Pl.KitchenSkill._024.Condition[1] = false
        end
        -- 26 Pl_KitchenSkill_025 おだんご免疫術
        -- 27 Pl_KitchenSkill_026 おだんごオトモ指導術
        -- 28 Pl_KitchenSkill_027 おだんご短期催眠術

        -- 29 Pl_KitchenSkill_028 おだんごふんばり術
        -- 30 Pl_KitchenSkill_029 おだんごビルドアップ
        -- 31 Pl_KitchenSkill_030 おだんご報酬金保険

        -- 32 Pl_KitchenSkill_031 おだんご復活術

        -- 33 Pl_KitchenSkill_032 おだんご環境生物召喚
        -- 34 Pl_KitchenSkill_033 おだんご投擲術
        -- 35 Pl_KitchenSkill_034 おだんご火耐性【小】
        -- 36 Pl_KitchenSkill_035 おだんご火耐性【大】
        -- 37 Pl_KitchenSkill_036 おだんご水耐性【小】
        -- 38 Pl_KitchenSkill_037 おだんご水耐性【大】
        -- 39 Pl_KitchenSkill_038 おだんご雷耐性【小】
        -- 40 Pl_KitchenSkill_039 おだんご雷耐性【大】
        -- 41 Pl_KitchenSkill_040 おだんご氷耐性【小】
        -- 42 Pl_KitchenSkill_041 おだんご氷耐性【大】
        -- 43 Pl_KitchenSkill_042 おだんご龍耐性【小】
        -- 44 Pl_KitchenSkill_043 おだんご龍耐性【大】
        -- 45 Pl_KitchenSkill_044 おだんご採蜜術
        -- 46 Pl_KitchenSkill_045 おだんご腹へらず
        -- 47 Pl_KitchenSkill_046 おだんご鳥寄せの術
        -- 48 Pl_KitchenSkill_047 おだんごぶら下がり術
        -- 49 Pl_KitchenSkill_048 おだんご防護術
        if Sd.KitchenSkill[Pl.KitchenSkill._048.Id] then
            if not Pl.KitchenSkill._048.Condition[1] and St._KitchenSkill048_Damage >= Pl.KitchenSkill._048.Param[1][Sd.KitchenSkill[Pl.KitchenSkill._048.Id]:get_field("_SkillLv")] then
                Pl.KitchenSkill._048.Condition[1] = true
            end
        end
        -- 50 Pl_KitchenSkill_049 おだんご強化延長術
        -- 51 Pl_KitchenSkill_050 おだんご生命力
        -- 52 Pl_KitchenSkill_051 おだんご逃走術
        if Sd.KitchenSkill[Pl.KitchenSkill._051.Id] then
            if St._KitchenSkill051_AtkUpTimer == Pl.KitchenSkill._051.Param[1] then
                Pl.KitchenSkill._051.Condition[1] = true
                AddChatInfomation(2, Pl.KitchenSkill._051.Id, Pl.KitchenSkill._051.Condition[1])
            elseif Pl.KitchenSkill._051.Condition[1] and St._KitchenSkill051_AtkUpTimer == 0 then
                Pl.KitchenSkill._051.Condition[1] = false
                AddChatInfomation(2, Pl.KitchenSkill._051.Id, Pl.KitchenSkill._051.Condition[1])
            end
        end
        -- 53 Pl_KitchenSkill_052 おだんご具足術
        -- 54 Pl_KitchenSkill_053 おだんご疾替え術
        -- 55 Pl_KitchenSkill_054 おだんご絆術
        if Sd.KitchenSkill[Pl.KitchenSkill._054.Id] then
            if St._KitchenSkill054_Timer == Pl.KitchenSkill._054.Param[1] then
                Pl.KitchenSkill._054.Condition[1] = true
            elseif Pl.KitchenSkill._054.Condition[1] and St._KitchenSkill054_Timer == 0 then
                Pl.KitchenSkill._054.Condition[1] = false
                AddChatInfomation(2, Pl.KitchenSkill._054.Id, Pl.KitchenSkill._054.Condition[1])
            end
        end
        -- 56 Pl_KitchenSkill_055 おだんご超回復力
        -- 57 Pl_KitchenSkill_056
        -- 58 Pl_KitchenSkill_057
        -- 59 Pl_KitchenSkill_058
        -- 60 Pl_KitchenSkill_059
        -- 61 Pl_KitchenSkill_060
        -- 62 Pl_KitchenSkill_061
        -- 63 Pl_KitchenSkill_062
        -- 64 Pl_KitchenSkill_063
        -- 57 Max
    end,
    function(retval)
    end)

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("onDestroy()"),
    function(args)
        Pl                = nil
        Sd                = nil
        St                = nil

        player_manager    = nil
        master_player_id  = nil
        player_base       = nil
        player_data       = nil
        player_skill_list = nil
        gui_manager       = nil
        gui_hud           = nil
        player_info       = nil
        quest_manager     = nil
    end,
    function(retval)
        return retval
    end)


local pre_damage, post_damage, is_master_player, is_reduce
sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("checkDamage_calcDamage(System.Single, System.Single, snow.player.PlayerDamageInfo, System.Boolean)"),
    function(args)
        is_master_player = sdk.to_managed_object(args[2]):call("isMasterPlayer()")

        if not is_master_player then return end

        pre_damage = sdk.to_float(args[3])

        if Pl.EquipSkill._223.Condition[1] and St._EquipSkill223Accumulator == 0 then
            pre_damage = pre_damage * Pl.EquipSkill._223.Param[1][Sd.EquipSkill[Pl.EquipSkill._223.Id]:get_field("SkillLv")]
            Pl.EquipSkill._223.Condition[1] = false
        end
    end,
    function(retval)
        return retval
    end)

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("damageVital(System.Single, System.Boolean, System.Boolean, System.Boolean, System.Boolean, System.Boolean)"),
    function(args)
        post_damage = nil

        if not pre_damage then return end

        post_damage = sdk.to_float(args[3])

        if sdk.to_float(args[10]) < 0 then
            if Pl.KitchenSkill._048.Condition[1] then
                pre_damage = pre_damage * Pl.KitchenSkill._048.Param[2][Sd.KitchenSkill[Pl.KitchenSkill._048.Id]:get_field("_SkillLv")]
                Pl.KitchenSkill._048.Condition[1] = false
            end
        end
    end,
    function(retval)
        if not is_master_player or not post_damage or not pre_damage then
            return retval
        end

        if pre_damage + post_damage > 0.0001 then
            is_reduce = true
        end

        pre_damage = nil
    end)

sdk.hook(sdk.find_type_definition("via.wwise.WwiseContainer"):get_method("trigger(System.UInt32, via.GameObject)"),
    function(args)
        if sdk.to_int64(args[2]) == 0x2ACF664E then
            if is_reduce then
                AddChatInfomation(3)
            end
        end
        is_reduce = false
    end,
    function(retval)
        return retval
    end)


local success, ModUI = pcall(require, "ModOptionsMenu.ModMenuApi")

if success then
    local config_path = "Improved Skill Notifications/config.json"
    local config      = json.load_file(config_path) or {}

    local Pl_C, Sd_C
    local first_open  = true

    local function pairs_by_keys(t)
        local keys = {}
        for key in pairs(t) do
            table.insert(keys, key)
        end
        table.sort(keys)
        local index = 0
        return function()
            index = index + 1
            if index <= #keys then
                return index, keys[index], t[keys[index]]
            end
        end
    end

    local function remove_new_line(str)
        return str:gsub("<COL[^>]*>{0}</COL[^>]*>[\n\r]", "%1 "):gsub("[\n\r]<COL[^>]*>{0}</COL[^>]*>", " %1"):gsub("[\n\r]", "")
    end

    local function normalize_config(current_config, reference)
        local result = {}

        for i, _, v in pairs_by_keys(reference) do
            local found
            local default_table = { v.Enum, v.Notice[1], v.Notice[2], 1 }

            if current_config then
                for _, w in ipairs(current_config) do
                    if not found and w[1] == v.Enum then
                        if #w ~= 4 then
                            w = default_table
                        end
                        table.insert(result, w)
                        found = true
                    end
                end
            end
            if not found then
                table.insert(result, i, default_table)
            end
        end

        return result
    end

    local function save_config()
        fs.write(config_path, json.dump_string(config))
    end

    local function initialize()
        config.EquipSkill          = normalize_config(config.EquipSkill, Pl_C.EquipSkill)
        config.KitchenSkill        = normalize_config(config.KitchenSkill, Pl_C.KitchenSkill)

        -- Create a copy with table.unpack() to avoid referencing the same table
        local default_color_config = { 0xFF, 0xFF, 0xFF, 1 }
        config.COL                 = config.COL or {}
        while #config.COL ~= 2 do
            if #config.COL > 2 then
                table.remove(config.COL, #config.COL)
            end
            if #config.COL < 2 then
                table.insert(config.COL, { table.unpack(default_color_config) })
            end
        end
        for _, v in ipairs(config.COL) do
            if #v < 4 then
                v = { table.unpack(default_color_config) }
            end
        end

        save_config()
    end

    local function get_skill_option_table()
        local t = {
            Pl_C.EquipSkill,
            Pl_C.KitchenSkill
        }

        for i, v in ipairs(t) do
            UI.Options.SkillSettings.optionNames[i] = {}
            for j, _, w in pairs_by_keys(v) do
                UI.Options.SkillSettings.optionNames[i][j] = {}
                if w.Notice[1] then
                    table.insert(UI.Options.SkillSettings.optionNames[i][j], UI.Options.SkillSettings.msg[2])
                end
                if w.Notice[2] then
                    table.insert(UI.Options.SkillSettings.optionNames[i][j], UI.Options.SkillSettings.msg[3])
                end
                if UI.Options.SkillSettings.optionNames[i][j] then
                    table.insert(UI.Options.SkillSettings.optionNames[i][j], UI.Options.SkillSettings.msg[4])
                    if #UI.Options.SkillSettings.optionNames[i][j] == 3 then
                        table.insert(UI.Options.SkillSettings.optionNames[i][j], 1, UI.Options.SkillSettings.msg[1])
                    end
                end
            end
        end
    end

    local function get_skill_settings()
        local t = { {
            Header       = UI.Header.EquipSkill,
            getSkillId   = get_player_equip_skill_id,
            getSkillName = get_equip_skill_name,
            confSkill    = config.EquipSkill,
            SdSkill      = Sd_C.EquipSkill,
        }, {
            Header       = UI.Header.KitchenSkill,
            getSkillId   = get_player_kitchen_skill_id,
            getSkillName = get_kitchen_skill_name,
            confSkill    = config.KitchenSkill,
            SdSkill      = Sd_C.KitchenSkill
        }, }

        for i, v in ipairs(t) do
            ModUI.Header(v.Header.text)
            for j, w in ipairs(v.confSkill) do
                local id = v.getSkillId(w[1])
                if w[4] > #UI.Options.SkillSettings.optionNames[i][j] then
                    w[4] = 1
                    save_config()
                end
                UI.Options.SkillSettings.curValue[j] = w[4]
                UI.Options.SkillSettings.label = v.getSkillName(nil, id)
                if UI.Options.SkillSettings.curValue[j] ~= 1 then
                    UI.Options.SkillSettings.label = set_rgb_color_to_string(UI.Options.SkillSettings.label, 0xFF, 0xE2, 0x9D)
                end

                if not UI.Options.EquipSkills.isFilter or v.SdSkill[id] then
                    UI.Options.SkillSettings.wasChanged, UI.Options.SkillSettings.newIndex = ModUI.Options(UI.Options.SkillSettings.label, UI.Options.SkillSettings.curValue[j], UI.Options.SkillSettings.optionNames[i][j], UI.Options.SkillSettings.optionMessages, UI.Options.SkillSettings.toolTip, UI.Options.SkillSettings.isImmediateUpdate)
                    if UI.Options.SkillSettings.wasChanged then
                        UI.Options.SkillSettings.curValue[j] = UI.Options.SkillSettings.newIndex

                        if UI.Options.SkillSettings.optionNames[i][j][UI.Options.SkillSettings.curValue[j]] == UI.Options.SkillSettings.msg[2] then
                            w[2] = true
                            w[3] = false
                        elseif UI.Options.SkillSettings.optionNames[i][j][UI.Options.SkillSettings.curValue[j]] == UI.Options.SkillSettings.msg[3] then
                            w[2] = false
                            w[3] = true
                        elseif UI.Options.SkillSettings.optionNames[i][j][UI.Options.SkillSettings.curValue[j]] == UI.Options.SkillSettings.msg[4] then
                            w[2] = false
                            w[3] = false
                        elseif UI.Options.SkillSettings.optionNames[i][j][UI.Options.SkillSettings.curValue[j]] == UI.Options.SkillSettings.msg[1] then
                            w[2] = true
                            w[3] = true
                        end
                        w[4] = UI.Options.SkillSettings.curValue[j]

                        save_config()
                    end
                end
            end
        end
    end

    local function get_color_options()
        for i, v in ipairs(config.COL) do
            UI.Options.COLOR.curValue[i] = v[4]

            UI.Options.COLOR.wasChanged, UI.Options.COLOR.newIndex = ModUI.Options(UI.Options.COLOR.label[i], UI.Options.COLOR.curValue[i], UI.Options.COLOR.optionNames, UI.Options.COLOR.optionMessages, UI.Options.COLOR.toolTip, UI.Options.COLOR.isImmediateUpdate)
            if UI.Options.COLOR.wasChanged then
                UI.Options.COLOR.curValue[i] = UI.Options.COLOR.newIndex
                v[4] = UI.Options.COLOR.curValue[i]
                save_config()
            end

            if UI.Options.COLOR.curValue[i] == 2 then
                UI.Options.COLOR.label[i] = remove_new_line(UI.MSG.Pl[i]):gsub("{0}", set_rgb_color_to_string(get_message_by_name("EnemyIndex112_MR"), v[1], v[2], v[3]))
                ModUI.SetIndent(18)

                for j = 1, #UI.Slider.label do
                    UI.Slider.curValue[i] = { [j] = v[j] }

                    UI.Slider.wasChanged, UI.Slider.newValue = ModUI.Slider(UI.Slider.label[j], UI.Slider.curValue[i][j], UI.Slider.min, UI.Slider.max, UI.Slider.toolTip, UI.Slider.isImmediateUpdate)
                    if UI.Slider.wasChanged then
                        UI.Slider.curValue[i][j] = UI.Slider.newValue
                        v[j] = UI.Slider.curValue[i][j]
                        save_config()
                    end
                end

                ModUI.SetIndent(0)
            elseif UI.Options.COLOR.curValue[i] == 1 then
                UI.Options.COLOR.label[i] = remove_new_line(UI.MSG.Pl[i]):gsub("{0}", get_message_by_name("EnemyIndex112_MR"))
            end
        end
    end

    local config_player_manager, config_master_player_id, config_player_skill_list
    ModUI.OnMenu(UI.OnMenu.name, UI.OnMenu.description, function()
        if is_changed_language() then get_skill_option_table() end

        if first_open then
            config_player_manager = get_player_manager()
            if not config_player_manager then
                ModUI.Label(UI.Label.label, UI.Label.displayValue, UI.Label.toolTip)
                return
            end

            config_master_player_id = get_master_player_id(config_player_manager)
            if not config_master_player_id then
                ModUI.Label(UI.Label.label, UI.Label.displayValue, UI.Label.toolTip)
                return
            end

            config_player_skill_list = get_player_skill_list(config_player_manager, config_master_player_id)

            Pl_C = get_skill_data(config_player_manager)

            Sd_C = {
                EquipSkill   = get_equip_skill_data(config_player_skill_list),
                KitchenSkill = get_kitchen_skill_data(config_player_skill_list)
            }

            initialize()
            get_skill_option_table()

            first_open = false
        end

        UI.Options.Selector.wasChanged, UI.Options.Selector.newIndex = ModUI.Options(UI.Options.Selector.label, UI.Options.Selector.curValue, UI.Options.Selector.optionNames, UI.Options.Selector.optionMessages, UI.Options.Selector.toolTip, UI.Options.Selector.isImmediateUpdate)
        if UI.Options.Selector.wasChanged then
            UI.Options.Selector.curValue = UI.Options.Selector.newIndex
        end

        ModUI.Header()

        if UI.Options.Selector.curValue == 1 then
            if config_player_skill_list then
                UI.Options.EquipSkills.wasChanged, UI.Options.EquipSkills.newIndex = ModUI.Options(UI.Options.EquipSkills.label, UI.Options.EquipSkills.curValue, UI.Options.EquipSkills.optionNames, UI.Options.EquipSkills.optionMessages, UI.Options.EquipSkills.toolTip, UI.Options.EquipSkills.isImmediateUpdate)
                if UI.Options.EquipSkills.wasChanged then
                    UI.Options.EquipSkills.curValue = UI.Options.EquipSkills.newIndex

                    if UI.Options.EquipSkills.curValue == 2 then
                        UI.Options.EquipSkills.isFilter = true
                    else
                        UI.Options.EquipSkills.isFilter = false
                    end
                end
            else
                ModUI.Label(UI.Options.EquipSkills.label, UI.Options.EquipSkills.optionNames[1], UI.Options.EquipSkills.toolTip)
            end

            get_skill_settings()
        elseif UI.Options.Selector.curValue == 2 then
            get_color_options()
        end
    end)

    sdk.hook(sdk.find_type_definition("snow.gui.GuiOptionWindow"):get_method("doClose()"),
        function(args)
        end,
        function(retval)
            Pl_C                     = nil
            Sd_C                     = nil

            config_player_manager    = nil
            config_master_player_id  = nil
            config_player_skill_list = nil

            first_open               = true

            return retval
        end)


    local function skip_chat_info(args)
        local t = { {
            skill_config        = config.EquipSkill,
            getSkillName        = get_equip_skill_name,
            get_player_skill_id = get_player_equip_skill_id
        }, {
            skill_config        = config.KitchenSkill,
            getSkillName        = get_kitchen_skill_name,
            get_player_skill_id = get_player_kitchen_skill_id
        } }

        for i, v in ipairs(t) do
            local pre_message = sdk.to_managed_object(args[3]):call("ToString()")

            for _, w in ipairs(v.skill_config) do
                for j, x in ipairs(config.COL) do
                    local id = v.get_player_skill_id(w[1])
                    local skill_name = v.getSkillName(nil, id)
                    local post_message

                    if i == 2 and (id == 31 or id == 32) then
                        post_message = UI.MSG.Ot[1]
                    else
                        post_message = UI.MSG.Pl[j]
                    end
                    post_message = post_message:gsub("{0}", skill_name)

                    if pre_message == post_message then
                        if not w[j + 1] then
                            return true
                        end
                        if x[4] == 2 then
                            args[3] = sdk.to_ptr(sdk.create_managed_string(post_message:gsub("<COL[^>]*>{0}</COL[^>]*>", skill_name):gsub(skill_name, set_rgb_color_to_string(skill_name, x[1], x[2], x[3]))))
                            return false
                        end
                    end
                end
            end
        end
    end

    sdk.hook(sdk.find_type_definition("snow.gui.ChatManager"):get_method("reqAddChatInfomation(System.String, System.UInt32)"),
        function(args)
            if config.COL and config.EquipSkill and config.KitchenSkill then
                if skip_chat_info(args) then
                    return sdk.PreHookResult.SKIP_ORIGINAL
                end
            end
        end,
        function(retval)
            return retval
        end)
end
