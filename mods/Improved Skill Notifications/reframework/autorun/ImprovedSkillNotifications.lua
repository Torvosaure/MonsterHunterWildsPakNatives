--------------------------------------------------------------------------------
----------------------------------- function -----------------------------------
--------------------------------------------------------------------------------

---@param s any
---@param r integer
---@param g integer
---@param b integer
---@return string
function string.set_rgb_col(s, r, g, b)
    return ("<COLOR %02X%02X%02X>%s</COLOR>"):format(r, g, b, s)
end

---@param s any
---@param name string
---@return string
function string.set_name_col(s, name)
    return ("<COL %s>%s</COL>"):format(name, s)
end

local type = {
    pl_equip_skill_id   = sdk.find_type_definition("snow.data.DataDef.PlEquipSkillId"),
    pl_kitchen_skill_id = sdk.find_type_definition("snow.data.DataDef.PlKitchenSkillId"),
    data_shortcut       = sdk.find_type_definition("snow.data.DataShortcut"),
    common              = sdk.find_type_definition("snow.gui.COMMON"),
    player_quest_base   = sdk.find_type_definition("snow.player.PlayerQuestBase"),
    player_quest_define = sdk.find_type_definition("snow.player.PlayerQuestDefine"),
    end_flow            = sdk.find_type_definition("snow.QuestManager.EndFlow"),
    gui_system          = sdk.find_type_definition("via.gui.GUISystem"),
    message             = sdk.find_type_definition("via.gui.message")
}

local get_message_language = type.gui_system:get_method("get_MessageLanguage()")
local msg_lang_idx = get_message_language:call(nil)
---@return boolean
local function is_lang_changed()
    local pre_index = get_message_language:call(nil)

    if msg_lang_idx ~= pre_index then
        msg_lang_idx = pre_index
        return true
    end

    return false
end

---@param enum string
---@return integer
local function get_player_equip_skill_id(enum)
    return type.pl_equip_skill_id:get_field(enum):get_data(nil)
end

---@param enum string
---@return integer
local function get_player_kitchen_skill_id(enum)
    return type.pl_kitchen_skill_id:get_field(enum):get_data(nil)
end

---@param player_skill_list any
---@return table
local function get_equip_skill_data(player_skill_list)
    local v = {}

    if sdk.is_managed_object(player_skill_list) then
        for i = 1, #type.pl_equip_skill_id:get_fields() do
            v[i] = player_skill_list:call("getSkillData(snow.data.DataDef.PlEquipSkillId)", i)
        end
    end

    return v
end

---@param player_skill_list any
---@return table
local function get_kitchen_skill_data(player_skill_list)
    local v = {}

    if sdk.is_managed_object(player_skill_list) then
        for i = 1, #type.pl_kitchen_skill_id:get_fields() do
            v[i] = player_skill_list:call("getKitchenSkillData(snow.data.DataDef.PlKitchenSkillId)", i)
        end
    end

    return v
end

local get_guid_by_name    = type.message:get_method("getGuidByName(System.String)")
local get_message_by_guid = type.message:get_method("get(System.Guid)")
---@param name string
---@return string
local function get_message_by_name(name)
    local guid    = get_guid_by_name:call(nil, name)
    local message = get_message_by_guid:call(nil, guid)

    return message
end

---@param player_manager any
---@return table|nil
local function get_skill_data(player_manager)
    local v = {}

    if not sdk.is_managed_object(player_manager) then
        return
    end

    local equip_skill_parameter  = player_manager:get_field("_PlayerUserDataSkillParameter"):get_field("_EquipSkillParameter")
    local odango_skill_parameter = player_manager:get_field("_PlayerUserDataSkillParameter"):get_field("_OdangoSkillParameter")

    if not sdk.is_managed_object(equip_skill_parameter) or not sdk.is_managed_object(odango_skill_parameter) then
        return
    end

    v.EquipSkill   = {
        _001 = {
            Enum   = "Pl_EquipSkill_001",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_001"),
            Notice = { true, true },
            Flags  = { false },
            Params = { type.player_quest_define:get_field("SkillChallengeTime"):get_data(nil) }
        },
        _002 = {
            Enum   = "Pl_EquipSkill_002",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_002"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _003 = {
            Enum   = "Pl_EquipSkill_003",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_003"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _004 = {
            Enum   = "Pl_EquipSkill_004",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_004"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _008 = {
            Enum   = "Pl_EquipSkill_008",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_008"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _009 = {
            Enum   = "Pl_EquipSkill_009",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_009"),
            Notice = { true, true },
            Flags  = { false, false, false },
            Params = { 120 }
        },
        _023 = {
            Enum   = "Pl_EquipSkill_023",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_023"),
            Notice = { true, false },
            Flags  = {},
            Params = {}
        },
        _036 = {
            Enum   = "Pl_EquipSkill_036",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_036"),
            Notice = { true, true },
            Flags  = { false },
            Params = { 720 }
        },
        _042 = {
            Enum   = "Pl_EquipSkill_042",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_042"),
            Notice = { true, true },
            Flags  = { false },
            Params = { equip_skill_parameter:get_field("_EquipSkill_042_CtlAddTime") * 60 }
        },
        _089 = {
            Enum   = "Pl_EquipSkill_089",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_089"),
            Notice = { true, false },
            Flags  = {},
            Params = {}
        },
        _090 = {
            Enum   = "Pl_EquipSkill_090",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_090"),
            Notice = { true, true },
            Flags  = { false },
            Params = { 0.35 }
        },
        _091 = {
            Enum   = "Pl_EquipSkill_091",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_091"),
            Notice = { true, true },
            Flags  = { false },
            Params = { 0 }
        },
        _102 = {
            Enum   = "Pl_EquipSkill_102",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_102"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv2"),
                equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv2"),
                equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv4"),
                equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv4"),
                equip_skill_parameter:get_field("_EquipSkill_102_ActivationLv5")
            }
        },
        _105 = {
            Enum   = "Pl_EquipSkill_105",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_105"),
            Notice = { true, true },
            Flags  = { false },
            Params = { 1800 }
        },
        _204 = {
            Enum   = "Pl_EquipSkill_204",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_204"),
            Notice = { true, true },
            Flags  = { false },
            Params = { 1800 }
        },
        _206 = {
            Enum   = "Pl_EquipSkill_206",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_206"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _208 = {
            Enum   = "Pl_EquipSkill_208",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_208"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_208_Lv1_Duration") * 60,
                equip_skill_parameter:get_field("_EquipSkill_208_Lv2_Duration") * 60,
                equip_skill_parameter:get_field("_EquipSkill_208_Lv3_Duration") * 60
            }
        },
        _209 = {
            Enum   = "Pl_EquipSkill_209",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_209"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _210 = {
            Enum   = "Pl_EquipSkill_210",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_210"),
            Notice = { true, false },
            Flags  = { false },
            Params = {}
        },
        _215 = {
            Enum   = "Pl_EquipSkill_215",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_215"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_215_Lv1"):get_field("_Time") * 60,
                equip_skill_parameter:get_field("_EquipSkill_215_Lv2"):get_field("_Time") * 60,
                equip_skill_parameter:get_field("_EquipSkill_215_Lv3"):get_field("_Time") * 60
            }
        },
        _216 = {
            Enum   = "Pl_EquipSkill_216",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_216"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_216_Lv1"):get_field("_Bow_Duration") * 60,
                equip_skill_parameter:get_field("_EquipSkill_216_Lv2"):get_field("_Bow_Duration") * 60,
                equip_skill_parameter:get_field("_EquipSkill_216_Lv3"):get_field("_Bow_Duration") * 60
            }
        },
        _220 = {
            Enum   = "Pl_EquipSkill_220",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_220"),
            Notice = { true, false },
            Flags  = { false },
            Params = {}
        },
        _222 = {
            Enum   = "Pl_EquipSkill_222",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_222"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_222_Lv1"),
                equip_skill_parameter:get_field("_EquipSkill_222_Lv2"),
                equip_skill_parameter:get_field("_EquipSkill_222_Lv3")
            }
        },
        _223 = {
            Enum   = "Pl_EquipSkill_223",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_223"),
            Notice = { true, false },
            Flags  = { false },
            Params = { {
                (100 - equip_skill_parameter:get_field("_EquipSkill_223"):get_field("_DamageReduceLv1")) / 100,
                (100 - equip_skill_parameter:get_field("_EquipSkill_223"):get_field("_DamageReduceLv2")) / 100
            }, {
                equip_skill_parameter:get_field("_EquipSkill_223"):get_field("_AccumulatorMax")
            } }
        },
        _024 = {
            Enum   = "Pl_EquipSkill_024",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_024"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_024_Lv1") * 60,
                equip_skill_parameter:get_field("_EquipSkill_024_Lv2") * 60,
                equip_skill_parameter:get_field("_EquipSkill_024_Lv3") * 60
            }
        },
        _226 = {
            Enum   = "Pl_EquipSkill_226",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_226"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _227 = {
            Enum   = "Pl_EquipSkill_227",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_227"),
            Notice = { true, false },
            Flags  = { false },
            Params = {}
        },
        _229 = {
            Enum   = "Pl_EquipSkill_229",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_229"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _230 = {
            Enum   = "Pl_EquipSkill_230",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_230"),
            Notice = { true, true },
            Flags  = { false },
            Params = {}
        },
        _231 = {
            Enum   = "Pl_EquipSkill_231",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_231"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                equip_skill_parameter:get_field("_EquipSkill_231_Lv1_WpOn_Timer") * 60,
                equip_skill_parameter:get_field("_EquipSkill_231_Lv2_WpOn_Timer") * 60,
                equip_skill_parameter:get_field("_EquipSkill_231_Lv3_WpOn_Timer") * 60
            }
        },
        _232 = {
            Enum   = "Pl_EquipSkill_232",
            Id     = get_player_equip_skill_id("Pl_EquipSkill_232"),
            Notice = { true, true },
            Flags  = { false },
            Params = { {
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
    }

    v.KitchenSkill = {
        _002 = {
            Enum   = "Pl_KitchenSkill_002",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_002"),
            Notice = { true, true },
            Flags  = { false },
            Params = {
                odango_skill_parameter:get_field("_KitchenSkill_002_Lv1"):get_field("_EnableHP"),
                odango_skill_parameter:get_field("_KitchenSkill_002_Lv2"):get_field("_EnableHP"),
                odango_skill_parameter:get_field("_KitchenSkill_002_Lv3"):get_field("_EnableHP"),
                odango_skill_parameter:get_field("_KitchenSkill_002_Lv4"):get_field("_EnableHP")
            }
        },
        _024 = {
            Enum   = "Pl_KitchenSkill_024",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_024"),
            Notice = { true, false },
            Flags  = { false },
            Params = {}
        },
        _027 = {
            Enum   = "Pl_KitchenSkill_027",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_027"),
            Notice = { true, true },
            Flags  = {},
            Params = {}
        },
        _030 = {
            Enum   = "Pl_KitchenSkill_030",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_030"),
            Notice = { true, false },
            Flags  = {},
            Params = {}
        },
        _031 = {
            Enum   = "Pl_KitchenSkill_031",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_031"),
            Notice = { true, false },
            Flags  = {},
            Params = {}
        },
        _048 = {
            Enum   = "Pl_KitchenSkill_048",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_048"),
            Notice = { true, false },
            Flags  = { false },
            Params = { {
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
            Enum   = "Pl_KitchenSkill_051",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_051"),
            Notice = { true, true },
            Flags  = { false },
            Params = { odango_skill_parameter:get_field("_KitchenSkill_051_Lv4_AtkDuration") * 60 }
        },
        _054 = {
            Enum   = "Pl_KitchenSkill_054",
            Id     = get_player_kitchen_skill_id("Pl_KitchenSkill_054"),
            Notice = { true, true },
            Flags  = { false },
            Params = { odango_skill_parameter:get_field("_KitchenSkill_054_Time") * 60 }
        }
    }

    return v
end

---@return table
local function get_ui()
    local v = {}

    v.OnMenu = {
        name        = ("Improved Skill Notifications"):set_rgb_col(0x00, 0xFF, 0xFF),
        description = ""
    }

    v.Slider = {
        label             = { ("R"):set_rgb_col(0xFF, 0x00, 0x00), ("G"):set_rgb_col(0x00, 0xFF, 0x00), ("B"):set_rgb_col(0x00, 0x00, 0xFF) },
        curValue          = {},
        min               = 0x0,
        max               = 0xFF,
        toolTip           = "",
        isImmediateUpdate = false,
        wasChanged        = nil,
        newValue          = nil
    }

    v.Options = {
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
                get_message_by_name("Option_Me_Item_107_01_MR"):set_name_col("YEL"),
                get_message_by_name("Option_Me_Item_107_02_MR"):set_name_col("RED"),
                get_message_by_name("ChatMenu_LogMenu_16"):set_name_col("GRAY")
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
    }

    v.Header = {
        EquipSkill = {
            text = get_message_by_name("FacilityCommonMenu_14")
        },
        KitchenSkill = {
            text = get_message_by_name("COMN_SkillDetailTab_04")
        }
    }

    v.Label = {
        label = get_message_by_name("DialogMsg_System_NSW_DataLoad_NG"),
        displayValue = "",
        toolTip = get_message_by_name("StartMenu_System_Common_GrayOut")
    }

    v.MSG = {
        Pl = {
            get_message_by_name("ChatLog_Pl_Skill_01"), -- ≪{0}≫が発動しました
            get_message_by_name("ChatLog_Pl_Skill_02")  -- ≪{0}≫の効果が切れました
        },
        Ot = {
            get_message_by_name("ChatLog_Ot_Skill_01"), -- ≪{0}≫の効果を受けました
            get_message_by_name("ChatLog_Ot_Skill_02"), -- ≪{0}≫が発動しました
            get_message_by_name("ChatLog_Ot_Skill_03")  -- ≪{0}≫の効果が切れました
        },
        Co = {
            get_message_by_name("ChatLog_Co_Skill_01") -- ダメージ軽減効果が発動しました
        }
    }

    return v
end

local UI                           = get_ui()

local singleton

---@enum SkillType
local SkillType                    = {
    Equip = 1,
    Kitchen = 2,
    Reduce = 3
}

local get_equip_skill_name         = type.data_shortcut:get_method("getName(snow.data.DataDef.PlEquipSkillId)")
local get_kitchen_skill_name       = type.data_shortcut:get_method("getName(snow.data.DataDef.PlKitchenSkillId)")
local GUI_COMMON_MEAL_SKILL_NOTICE = type.common:get_field("GUI_COMMON_MEAL_SKILL_NOTICE"):get_data(nil)
---@param skill_type SkillType
---@param is_active boolean
---@param id integer?
local function display_skill_message(skill_type, is_active, id)
    local get_skill_name = {
        get_equip_skill_name,
        get_kitchen_skill_name
    }

    local pre_message = {
        UI.MSG.Pl[1],
        UI.MSG.Pl[2],
        UI.MSG.Co[1]
    }

    local post_message

    if id and (skill_type == SkillType.Equip or skill_type == SkillType.Kitchen) then
        local idx = is_active and 1 or 2
        local skill_name = get_skill_name[skill_type](nil, id)

        post_message = pre_message[idx]:gsub("{0}", skill_name)
    elseif is_active and skill_type == SkillType.Reduce then
        post_message = pre_message[3]
    end

    singleton.chat_manager:call("reqAddChatInfomation(System.String, System.UInt32)", post_message, GUI_COMMON_MEAL_SKILL_NOTICE)
end

local m
local pl
local sd
local st

local function init_data()
    m  = nil
    pl = nil
    sd = nil
    st = nil
end

---@return boolean
local function init()
    init_data()

    singleton = {
        chat_manager      = sdk.get_managed_singleton("snow.gui.ChatManager"),
        gui_manager       = sdk.get_managed_singleton("snow.gui.GuiManager"),
        player_manager    = sdk.get_managed_singleton("snow.player.PlayerManager"),
        quest_manager     = sdk.get_managed_singleton("snow.QuestManager"),
        snow_save_service = sdk.get_managed_singleton("snow.SnowSaveService")
    }

    local i = 0

    for _, v in pairs(singleton) do
        if not sdk.is_managed_object(v) then
            return false
        end

        i = i + 1
    end

    if i == 0 then
        return false
    end

    return true
end


---@return nil
local function init_player()
    m                  = {}

    m.master_player_id = singleton.player_manager:call("getMasterPlayerID()")
    if not m.master_player_id then return false end

    m.player_base = singleton.player_manager:call("findMasterPlayer()")
    if not m.player_base then return false end

    m.player_data = singleton.player_manager:get_field("<PlayerData>k__BackingField")[m.master_player_id]
    if not m.player_data then return false end

    m.player_skill_list = singleton.player_manager:get_field("<PlayerSkill>k__BackingField")[m.master_player_id]
    if not m.player_skill_list then return false end

    local ref_gui_hud = singleton.gui_manager:get_field("<refGuiHud>k__BackingField")
    if not ref_gui_hud then return false end

    m.player_info = ref_gui_hud:get_field("PlayerInfo")
    if not m.player_info then return false end

    pl = get_skill_data(singleton.player_manager)

    if not pl then
        return false
    end

    sd = {
        es = get_equip_skill_data(m.player_skill_list),
        ks = get_kitchen_skill_data(m.player_skill_list)
    }

    return true
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
--     end)

---@return table
local function get_state()
    local v = {
        playerHealth                    = m.player_data:call("get_vital()"),
        playerMaxHealth                 = m.player_base:call("getVitalMax()"),
        playerRawRedHealth              = m.player_data:get_field("_r_Vital"),
        playerRedHealth                 = m.player_base:call("getRedVital()"),
        playerStamina                   = m.player_data:get_field("_stamina"),
        playerMaxStamina                = m.player_data:get_field("_staminaMax"),

        _ChallengeTimer                 = m.player_data:get_field("_ChallengeTimer"),
        isDebuffState                   = m.player_base:call("isDebuffState()"),
        _PowerFreedomTimer              = m.player_base:get_field("_PowerFreedomTimer"),
        _WholeBodyTimer                 = m.player_data:get_field("_WholeBodyTimer"),
        _SharpnessGaugeBoostTimer       = m.player_base:get_field("_SharpnessGaugeBoostTimer"),
        _EquipSkill_036_Timer           = m.player_data:get_field("_EquipSkill_036_Timer"),
        _SlidingPowerupTimer            = m.player_data:get_field("_SlidingPowerupTimer"),
        isEquipSkill091                 = m.player_base:call("isEquipSkill091()"),
        _DieCount                       = m.player_data:get_field("_DieCount"),
        _CounterattackPowerupTimer      = m.player_data:get_field("_CounterattackPowerupTimer"),
        _DisasterTurnPowerUpTimer       = m.player_data:get_field("_DisasterTurnPowerUpTimer"),
        _FightingSpiritTimer            = m.player_data:get_field("_FightingSpiritTimer"),
        _EquipSkill208_AtkUpTimer       = m.player_data:get_field("_EquipSkill208_AtkUpTimer"),
        _BrandNewSharpnessAdjustUpTimer = m.player_data:get_field("_BrandNewSharpnessAdjustUpTimer"),
        _EquipSkill216_BottleUpTimer    = m.player_base:get_field("_EquipSkill216_BottleUpTimer"),
        isHaveSkillGuts                 = m.player_info:get_field("isHaveSkillGuts"),
        _EquipSkill222_Timer            = m.player_data:get_field("_EquipSkill222_Timer"),
        _EquipSkill223Accumulator       = m.player_data:get_field("_EquipSkill223Accumulator"),
        isHateTarget                    = m.player_base:call("isHateTarget()"),
        _IsEquipSkill226Enable          = m.player_base:get_field("_IsEquipSkill226Enable"),
        _EquipSkill227State             = m.player_data:get_field("_EquipSkill227State"),
        get_IsEnableEquipSkill225       = m.player_base:call("get_IsEnableEquipSkill225()"),
        _EquipSkill229UseUpFlg          = m.player_base:get_field("_EquipSkill229UseUpFlg"),
        isActiveEquipSkill230           = m.player_base:call("isActiveEquipSkill230()"),
        _EquipSkill231_WireNumTimer     = m.player_data:get_field("_EquipSkill231_WireNumTimer"),
        _EquipSkill231_WpOffTimer       = m.player_data:get_field("_EquipSkill231_WpOffTimer"),
        _EquipSkill232Absorption        = m.player_data:get_field("_EquipSkill232Absorption"),
        _EquipSkill232Timer             = m.player_data:get_field("_EquipSkill232Timer"),

        isHaveKitchenGuts               = m.player_info:get_field("isHaveKitchenGuts"),
        _KitchenSkill048_Damage         = m.player_data:get_field("_KitchenSkill048_Damage"),
        _KitchenSkill051_AtkUpTimer     = m.player_data:get_field("_KitchenSkill051_AtkUpTimer"),
        _KitchenSkill054_Timer          = m.player_data:get_field("_KitchenSkill054_Timer"),

        end_flow                        = singleton.quest_manager:get_field("_EndFlow"),
        flows                           = {
            [type.end_flow:get_field("WaitFadeCameraDemo"):get_data(nil)] = true,
            [type.end_flow:get_field("LoadCameraDemo"):get_data(nil)]     = true,
            [type.end_flow:get_field("LoadWaitCameraDemo"):get_data(nil)] = true,
            [type.end_flow:get_field("StartCameraDemo"):get_data(nil)]    = true,
            [type.end_flow:get_field("CameraDemo"):get_data(nil)]         = true,
            [type.end_flow:get_field("Stamp"):get_data(nil)]              = true,
            [type.end_flow:get_field("WaitFadeOut"):get_data(nil)]        = true
        }
    }

    return v
end

---@return integer?
local function get_current_hunter_slot_num()
    return singleton.snow_save_service:get_field("_CurrentHunterSlotNo")
end

--------------------------------------------------------------------------------
------------------------------------- Logic ------------------------------------
--------------------------------------------------------------------------------

if not init() then
    sdk.hook(sdk.find_type_definition("snow.gui.fsm.title.GuiTitle"):get_method("start()"),
             function(args)
             end,
             function(retval)
                 init()
             end)
end

local is_quest = false

sdk.hook(sdk.find_type_definition("snow.gui.GuiHud"):get_method("start()"),
         function(args)
         end,
         function(retval)
             init_player()
         end)

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("update()"),
         function(args)
             if not m or not pl or not sd then
                 if not init_player() then
                     return
                 end
             end

             st = get_state()

             -- Don't show notifications in cutscenes at the end of quests.
             if st.flows[st.end_flow] then
                 return
             end

             if is_lang_changed() then
                 UI = get_ui()
             end

             if not is_quest then
                 is_quest = true
             end

             -- 0 Pl_EquipSkill_None
             -- 1 Pl_EquipSkill_000 攻撃
             -- 2 Pl_EquipSkill_001 挑戦者
             if sd.es[pl.EquipSkill._001.Id] then
                 if not pl.EquipSkill._001.Flags[1] and st._ChallengeTimer == pl.EquipSkill._001.Params[1] then
                     pl.EquipSkill._001.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._001.Flags[1], pl.EquipSkill._001.Id)
                 elseif pl.EquipSkill._001.Flags[1] and st._ChallengeTimer == 0 then
                     pl.EquipSkill._001.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._001.Flags[1], pl.EquipSkill._001.Id)
                 end
             end
             -- 3 Pl_EquipSkill_002 フルチャージ
             if sd.es[pl.EquipSkill._002.Id] then
                 if not pl.EquipSkill._002.Flags[1] and st.playerHealth == st.playerMaxHealth then
                     pl.EquipSkill._002.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._002.Flags[1], pl.EquipSkill._002.Id)
                 elseif pl.EquipSkill._002.Flags[1] and st.playerHealth < st.playerMaxHealth then
                     pl.EquipSkill._002.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._002.Flags[1], pl.EquipSkill._002.Id)
                 end
             end
             -- 4 Pl_EquipSkill_003 逆恨み
             if sd.es[pl.EquipSkill._003.Id] then
                 if not pl.EquipSkill._003.Flags[1] then
                     if st.get_IsEnableEquipSkill225 or st.playerRedHealth > 0 then
                         pl.EquipSkill._003.Flags[1] = true
                         display_skill_message(SkillType.Equip, pl.EquipSkill._003.Flags[1], pl.EquipSkill._003.Id)
                     end
                 elseif pl.EquipSkill._003.Flags[1] and not st.get_IsEnableEquipSkill225 and st.playerHealth == st.playerRawRedHealth and st.playerRedHealth == 0 then
                     pl.EquipSkill._003.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._003.Flags[1], pl.EquipSkill._003.Id)
                 end
             end
             -- 5 Pl_EquipSkill_004 死中に活
             if sd.es[pl.EquipSkill._004.Id] then
                 if not pl.EquipSkill._004.Flags[1] and st.isDebuffState then
                     pl.EquipSkill._004.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._004.Flags[1], pl.EquipSkill._004.Id)
                 elseif pl.EquipSkill._004.Flags[1] and not st.isDebuffState then
                     pl.EquipSkill._004.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._004.Flags[1], pl.EquipSkill._004.Id)
                 end
             end
             -- 6 Pl_EquipSkill_005 見切り
             -- 7 Pl_EquipSkill_006 超会心
             -- 8 Pl_EquipSkill_007 弱点特効
             -- 9 Pl_EquipSkill_008 力の解放
             if sd.es[pl.EquipSkill._008.Id] then
                 if not pl.EquipSkill._008.Flags[1] and st._PowerFreedomTimer == pl.EquipSkill._001.Params[1] then
                     pl.EquipSkill._008.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._008.Flags[1], pl.EquipSkill._008.Id)
                 elseif pl.EquipSkill._008.Flags[1] and st._PowerFreedomTimer == 0 then
                     pl.EquipSkill._008.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._008.Flags[1], pl.EquipSkill._008.Id)
                 end
             end
             -- 10 Pl_EquipSkill_009 渾身
             if sd.es[pl.EquipSkill._009.Id] then
                 if not pl.EquipSkill._009.Flags[1] and not pl.EquipSkill._009.Flags[2] and st.playerStamina == st.playerMaxStamina and st._WholeBodyTimer > pl.EquipSkill._009.Params[1] then
                     pl.EquipSkill._009.Flags[2] = true
                 elseif pl.EquipSkill._009.Flags[2] and st.playerStamina < st.playerMaxStamina then
                     pl.EquipSkill._009.Flags[2] = false
                 elseif pl.EquipSkill._009.Flags[2] and st._WholeBodyTimer == 0 then
                     pl.EquipSkill._009.Flags[1] = true
                     pl.EquipSkill._009.Flags[2] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._009.Flags[1], pl.EquipSkill._009.Id)
                 elseif pl.EquipSkill._009.Flags[1] and not pl.EquipSkill._009.Flags[3] and st.playerStamina < st.playerMaxStamina and st._WholeBodyTimer == 0 then
                     pl.EquipSkill._009.Flags[3] = true
                 elseif pl.EquipSkill._009.Flags[1] and pl.EquipSkill._009.Flags[3] and st.playerStamina < st.playerMaxStamina and st._WholeBodyTimer == 0 then
                     pl.EquipSkill._009.Flags[1] = false
                     pl.EquipSkill._009.Flags[3] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._009.Flags[1], pl.EquipSkill._009.Id)
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
             if sd.es[pl.EquipSkill._024.Id] then
                 if st._SharpnessGaugeBoostTimer == pl.EquipSkill._024.Params[sd.es[pl.EquipSkill._024.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._024.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._024.Flags[1], pl.EquipSkill._024.Id)
                 elseif pl.EquipSkill._024.Flags[1] and st._SharpnessGaugeBoostTimer == 0 then
                     pl.EquipSkill._024.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._024.Flags[1], pl.EquipSkill._024.Id)
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
             if sd.es[pl.EquipSkill._036.Id] then
                 if st._EquipSkill_036_Timer == pl.EquipSkill._036.Params[1] then
                     pl.EquipSkill._036.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._036.Flags[1], pl.EquipSkill._036.Id)
                 elseif pl.EquipSkill._036.Flags[1] and st._EquipSkill_036_Timer == 0 then
                     pl.EquipSkill._036.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._036.Flags[1], pl.EquipSkill._036.Id)
                 end
             end
             -- 38 Pl_EquipSkill_037 抜刀術【技】
             -- 39 Pl_EquipSkill_038 抜刀術【力】
             -- 40 Pl_EquipSkill_039 納刀術
             -- 41 Pl_EquipSkill_040 ＫＯ術
             -- 42 Pl_EquipSkill_041 スタミナ奪取
             -- 43 Pl_EquipSkill_042 滑走強化
             if sd.es[pl.EquipSkill._042.Id] then
                 if not pl.EquipSkill._042.Flags[1] and st._SlidingPowerupTimer == pl.EquipSkill._042.Params[1] then
                     pl.EquipSkill._042.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._042.Flags[1], pl.EquipSkill._042.Id)
                 elseif pl.EquipSkill._042.Flags[1] and st._SlidingPowerupTimer == 0 then
                     pl.EquipSkill._042.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._042.Flags[1], pl.EquipSkill._042.Id)
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
             if sd.es[pl.EquipSkill._090.Id] then
                 if not pl.EquipSkill._090.Flags[1] and not pl.KitchenSkill._002.Flags[1] and st.playerHealth <= st.playerMaxHealth * pl.EquipSkill._090.Params[1] then
                     pl.EquipSkill._090.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._090.Flags[1], pl.EquipSkill._090.Id)
                 elseif pl.EquipSkill._090.Flags[1] and st.playerHealth > st.playerMaxHealth * pl.EquipSkill._090.Params[1] then
                     pl.EquipSkill._090.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._090.Flags[1], pl.EquipSkill._090.Id)
                 end
             end
             -- 92 Pl_EquipSkill_091 不屈
             if st.isEquipSkill091 then
                 if sd.es[pl.EquipSkill._091.Id] then
                     if st._DieCount - pl.EquipSkill._091.Params[1] > 0 or (st._DieCount > 0 and not pl.EquipSkill._091.Flags[1]) then
                         pl.EquipSkill._091.Params[1] = st._DieCount
                         pl.EquipSkill._091.Flags[1] = true
                         display_skill_message(SkillType.Equip, pl.EquipSkill._091.Flags[1], pl.EquipSkill._091.Id)
                     elseif pl.EquipSkill._091.Flags[1] and st._DieCount - pl.EquipSkill._091.Params[1] < 0 then
                         pl.EquipSkill._091.Flags[1] = false
                         display_skill_message(SkillType.Equip, pl.EquipSkill._091.Flags[1], pl.EquipSkill._091.Id)
                     end
                 elseif not sd.es[pl.EquipSkill._091.Id] and pl.EquipSkill._091.Flags[1] then
                     pl.EquipSkill._091.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._091.Flags[1], pl.EquipSkill._091.Id)
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
             if sd.es[pl.EquipSkill._102.Id] then
                 if not pl.EquipSkill._102.Flags[1] and st.playerHealth <= st.playerMaxHealth * pl.EquipSkill._102.Params[sd.es[pl.EquipSkill._102.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._102.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._102.Flags[1], pl.EquipSkill._102.Id)
                 elseif pl.EquipSkill._102.Flags[1] and st.playerHealth > st.playerMaxHealth * pl.EquipSkill._102.Params[sd.es[pl.EquipSkill._102.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._102.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._102.Flags[1], pl.EquipSkill._102.Id)
                 end
             end
             -- 104 Pl_EquipSkill_103 翔蟲使い
             -- 105 Pl_EquipSkill_104 壁面移動
             -- 106 Pl_EquipSkill_105 逆襲
             if sd.es[pl.EquipSkill._105.Id] then
                 if st._CounterattackPowerupTimer == pl.EquipSkill._105.Params[1] then
                     pl.EquipSkill._105.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._105.Flags[1], pl.EquipSkill._105.Id)
                 elseif pl.EquipSkill._105.Flags[1] and st._CounterattackPowerupTimer == 0 then
                     pl.EquipSkill._105.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._105.Flags[1], pl.EquipSkill._105.Id)
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
             if sd.es[pl.EquipSkill._204.Id] then
                 if not pl.EquipSkill._204.Flags[1] and st._DisasterTurnPowerUpTimer == pl.EquipSkill._204.Params[1] then
                     pl.EquipSkill._204.Flags[1] = true
                 elseif pl.EquipSkill._204.Flags[1] and st._DisasterTurnPowerUpTimer == 0 then
                     pl.EquipSkill._204.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._204.Flags[1], pl.EquipSkill._204.Id)
                 end
             end
             -- 117 Pl_EquipSkill_205 狂竜症【蝕】
             -- 118 Pl_EquipSkill_206 顕如盤石
             if sd.es[pl.EquipSkill._206.Id] then
                 if not pl.EquipSkill._206.Flags[1] and st._FightingSpiritTimer == pl.EquipSkill._001.Params[1] then
                     pl.EquipSkill._206.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._206.Flags[1], pl.EquipSkill._206.Id)
                 elseif pl.EquipSkill._206.Flags[1] and st._FightingSpiritTimer == 0 then
                     pl.EquipSkill._206.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._206.Flags[1], pl.EquipSkill._206.Id)
                 end
             end
             -- 119 Pl_EquipSkill_207 闇討ち
             -- 120 Pl_EquipSkill_208 巧撃
             if sd.es[pl.EquipSkill._208.Id] then
                 if st._EquipSkill208_AtkUpTimer == pl.EquipSkill._208.Params[sd.es[pl.EquipSkill._208.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._208.Flags[1] = true
                 elseif pl.EquipSkill._208.Flags[1] and st._EquipSkill208_AtkUpTimer == 0 then
                     pl.EquipSkill._208.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._208.Flags[1], pl.EquipSkill._208.Id)
                 end
             end
             -- 121 Pl_EquipSkill_209 煽衛
             if sd.es[pl.EquipSkill._209.Id] then
                 if not pl.EquipSkill._209.Flags[1] and st.isHateTarget then
                     pl.EquipSkill._209.Flags[1] = true
                 elseif pl.EquipSkill._209.Flags[1] and not st.isHateTarget then
                     pl.EquipSkill._209.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._209.Flags[1], pl.EquipSkill._209.Id)
                 end
             end
             -- 122 Pl_EquipSkill_210 合気
             -- 123 Pl_EquipSkill_211 供応
             -- 124 Pl_EquipSkill_212 チャージマスター
             -- 125 Pl_EquipSkill_213 攻勢
             -- 126 Pl_EquipSkill_214 チューンアップ
             -- 127 Pl_EquipSkill_215 研磨術【鋭】
             if sd.es[pl.EquipSkill._215.Id] then
                 if st._BrandNewSharpnessAdjustUpTimer == pl.EquipSkill._215.Params[sd.es[pl.EquipSkill._215.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._215.Flags[1] = true
                 elseif pl.EquipSkill._215.Flags[1] and st._BrandNewSharpnessAdjustUpTimer == 0 then
                     pl.EquipSkill._215.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._215.Flags[1], pl.EquipSkill._215.Id)
                 end
             end
             -- 128 Pl_EquipSkill_216 刃鱗磨き
             if sd.es[pl.EquipSkill._216.Id] then
                 if st._EquipSkill216_BottleUpTimer == pl.EquipSkill._216.Params[sd.es[pl.EquipSkill._216.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._216.Flags[1] = true
                 elseif pl.EquipSkill._216.Flags[1] and st._EquipSkill216_BottleUpTimer == 0 then
                     pl.EquipSkill._216.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._216.Flags[1], pl.EquipSkill._216.Id)
                 end
             end
             -- 129 Pl_EquipSkill_217 壁面移動【翔】
             -- 130 Pl_EquipSkill_218 弱点特効【属性】
             -- 131 Pl_EquipSkill_219 連撃
             -- 132 Pl_EquipSkill_220 根性
             if sd.es[pl.EquipSkill._220.Id] and not pl.EquipSkill._220.Flags[1] and st.isHaveSkillGuts then
                 pl.EquipSkill._220.Flags[1] = true
             elseif not sd.es[pl.EquipSkill._220.Id] and pl.EquipSkill._220.Flags[1] and not st.isHaveSkillGuts then
                 display_skill_message(SkillType.Equip, pl.EquipSkill._220.Flags[1], pl.EquipSkill._220.Id)
                 pl.EquipSkill._220.Flags[1] = false
             end
             -- 133 Pl_EquipSkill_221 疾之息吹
             -- 134 Pl_EquipSkill_222 状態異常確定蓄積
             if sd.es[pl.EquipSkill._222.Id] then
                 if st._EquipSkill222_Timer == pl.EquipSkill._222.Params[sd.es[pl.EquipSkill._222.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._222.Flags[1] = true
                 elseif pl.EquipSkill._222.Flags[1] and st._EquipSkill222_Timer == 0 then
                     pl.EquipSkill._222.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._222.Flags[1], pl.EquipSkill._222.Id)
                 end
             end
             -- 135 Pl_EquipSkill_223 剛心
             if sd.es[pl.EquipSkill._223.Id] then
                 if not pl.EquipSkill._223.Flags[1] and st._EquipSkill223Accumulator == pl.EquipSkill._223.Params[2][1] then
                     pl.EquipSkill._223.Flags[1] = true
                 end
             end
             -- 136 Pl_EquipSkill_224 蓄積時攻撃強化
             -- 137 Pl_EquipSkill_225 狂化
             -- 138 Pl_EquipSkill_226 風纏
             if sd.es[pl.EquipSkill._226.Id] then
                 if not pl.EquipSkill._226.Flags[1] and st._IsEquipSkill226Enable then
                     pl.EquipSkill._226.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._226.Flags[1], pl.EquipSkill._226.Id)
                 elseif pl.EquipSkill._226.Flags[1] and not st._IsEquipSkill226Enable then
                     pl.EquipSkill._226.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._226.Flags[1], pl.EquipSkill._226.Id)
                 end
             end
             -- 139 Pl_EquipSkill_227 粉塵纏
             if sd.es[pl.EquipSkill._227.Id] then
                 if not pl.EquipSkill._227.Flags[1] and st._EquipSkill227State ~= 0 then
                     pl.EquipSkill._227.Flags[1] = true
                 elseif pl.EquipSkill._227.Flags[1] and st._EquipSkill227State == 0 then
                     display_skill_message(SkillType.Equip, pl.EquipSkill._227.Flags[1], pl.EquipSkill._227.Id)
                     pl.EquipSkill._227.Flags[1] = false
                 end
             end
             -- 140 Pl_EquipSkill_228 冰気錬成
             -- 141 Pl_EquipSkill_229 龍気変換
             if sd.es[pl.EquipSkill._229.Id] then
                 if not pl.EquipSkill._229.Flags[1] and st._EquipSkill229UseUpFlg then
                     pl.EquipSkill._229.Flags[1] = true
                     display_skill_message(SkillType.Equip, pl.EquipSkill._229.Flags[1], pl.EquipSkill._229.Id)
                 elseif pl.EquipSkill._229.Flags[1] and not st._EquipSkill229UseUpFlg then
                     pl.EquipSkill._229.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._229.Flags[1], pl.EquipSkill._229.Id)
                 end
             end
             -- 142 Pl_EquipSkill_230 天衣無崩
             if sd.es[pl.EquipSkill._230.Id] then
                 if not pl.EquipSkill._230.Flags[1] and st.isActiveEquipSkill230 then
                     pl.EquipSkill._230.Flags[1] = true
                 elseif pl.EquipSkill._230.Flags[1] and not st.isActiveEquipSkill230 then
                     pl.EquipSkill._230.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._230.Flags[1], pl.EquipSkill._230.Id)
                 end
             end
             -- 143 Pl_EquipSkill_231 狂竜症【翔】
             if sd.es[pl.EquipSkill._231.Id] then
                 if not pl.EquipSkill._231.Flags[1] and st._EquipSkill231_WireNumTimer == pl.EquipSkill._231.Params[sd.es[pl.EquipSkill._231.Id]:get_field("SkillLv")] then
                     pl.EquipSkill._231.Flags[1] = true
                 elseif pl.EquipSkill._231.Flags[1] and st._EquipSkill231_WpOffTimer == 0 then
                     pl.EquipSkill._231.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._231.Flags[1], pl.EquipSkill._231.Id)
                 end
             end
             -- 144 Pl_EquipSkill_232 血氣覚醒
             if sd.es[pl.EquipSkill._232.Id] then
                 if not pl.EquipSkill._232.Flags[1] then
                     if st._EquipSkill232Absorption >= pl.EquipSkill._232.Params[1][sd.es[pl.EquipSkill._232.Id]:get_field("SkillLv")] and st._EquipSkill232Timer == pl.EquipSkill._232.Params[3][sd.es[pl.EquipSkill._232.Id]:get_field("SkillLv")] then
                         pl.EquipSkill._232.Flags[1] = true
                     elseif st._EquipSkill232Absorption >= pl.EquipSkill._232.Params[2][sd.es[pl.EquipSkill._232.Id]:get_field("SkillLv")] and st._EquipSkill232Timer == pl.EquipSkill._232.Params[4][sd.es[pl.EquipSkill._232.Id]:get_field("SkillLv")] then
                         pl.EquipSkill._232.Flags[1] = true
                     end
                 elseif pl.EquipSkill._232.Flags[1] and st._EquipSkill232Timer == 0 then
                     pl.EquipSkill._232.Flags[1] = false
                     display_skill_message(SkillType.Equip, pl.EquipSkill._232.Flags[1], pl.EquipSkill._232.Id)
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
             if sd.ks[pl.KitchenSkill._002.Id] then
                 if not pl.KitchenSkill._002.Flags[1] and st.playerHealth <= pl.KitchenSkill._002.Params[sd.ks[pl.KitchenSkill._002.Id]:get_field("_SkillLv")] then
                     pl.KitchenSkill._002.Flags[1] = true
                     display_skill_message(SkillType.Kitchen, pl.KitchenSkill._002.Flags[1], pl.KitchenSkill._002.Id)
                 elseif pl.KitchenSkill._002.Flags[1] and st.playerHealth > pl.KitchenSkill._002.Params[sd.ks[pl.KitchenSkill._002.Id]:get_field("_SkillLv")] then
                     pl.KitchenSkill._002.Flags[1] = false
                     display_skill_message(SkillType.Kitchen, pl.KitchenSkill._002.Flags[1], pl.KitchenSkill._002.Id)
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
             if sd.ks[pl.KitchenSkill._024.Id] and not pl.KitchenSkill._024.Flags[1] and st.isHaveKitchenGuts then
                 pl.KitchenSkill._024.Flags[1] = true
             elseif not sd.ks[pl.KitchenSkill._024.Id] and pl.KitchenSkill._024.Flags[1] and not st.isHaveKitchenGuts then
                 display_skill_message(SkillType.Kitchen, pl.KitchenSkill._024.Flags[1], pl.KitchenSkill._024.Id)
                 pl.KitchenSkill._024.Flags[1] = false
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
             if sd.ks[pl.KitchenSkill._048.Id] then
                 if not pl.KitchenSkill._048.Flags[1] and st._KitchenSkill048_Damage >= pl.KitchenSkill._048.Params[1][sd.ks[pl.KitchenSkill._048.Id]:get_field("_SkillLv")] then
                     pl.KitchenSkill._048.Flags[1] = true
                 end
             end
             -- 50 Pl_KitchenSkill_049 おだんご強化延長術
             -- 51 Pl_KitchenSkill_050 おだんご生命力
             -- 52 Pl_KitchenSkill_051 おだんご逃走術
             if sd.ks[pl.KitchenSkill._051.Id] then
                 if st._KitchenSkill051_AtkUpTimer == pl.KitchenSkill._051.Params[1] then
                     pl.KitchenSkill._051.Flags[1] = true
                     display_skill_message(SkillType.Kitchen, pl.KitchenSkill._051.Flags[1], pl.KitchenSkill._051.Id)
                 elseif pl.KitchenSkill._051.Flags[1] and st._KitchenSkill051_AtkUpTimer == 0 then
                     pl.KitchenSkill._051.Flags[1] = false
                     display_skill_message(SkillType.Kitchen, pl.KitchenSkill._051.Flags[1], pl.KitchenSkill._051.Id)
                 end
             end
             -- 53 Pl_KitchenSkill_052 おだんご具足術
             -- 54 Pl_KitchenSkill_053 おだんご疾替え術
             -- 55 Pl_KitchenSkill_054 おだんご絆術
             if sd.ks[pl.KitchenSkill._054.Id] then
                 if st._KitchenSkill054_Timer == pl.KitchenSkill._054.Params[1] then
                     pl.KitchenSkill._054.Flags[1] = true
                 elseif pl.KitchenSkill._054.Flags[1] and st._KitchenSkill054_Timer == 0 then
                     pl.KitchenSkill._054.Flags[1] = false
                     display_skill_message(SkillType.Kitchen, pl.KitchenSkill._054.Flags[1], pl.KitchenSkill._054.Id)
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

local pre_damage, post_damage, is_master_player, is_reduce
sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("checkDamage_calcDamage(System.Single, System.Single, snow.player.PlayerDamageInfo, System.Boolean)"),
         function(args)
             is_master_player = sdk.to_managed_object(args[2]):call("isMasterPlayer()")

             if not is_master_player then return end

             pre_damage = sdk.to_float(args[3])

             if pl.EquipSkill._223.Flags[1] and st._EquipSkill223Accumulator == 0 then
                 pre_damage = pre_damage * pl.EquipSkill._223.Params[1][sd.es[pl.EquipSkill._223.Id]:get_field("SkillLv")]
                 pl.EquipSkill._223.Flags[1] = false
             end
         end,
         function(retval)
         end)

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("damageVital(System.Single, System.Boolean, System.Boolean, System.Boolean, System.Boolean, System.Boolean)"),
         function(args)
             post_damage = nil

             if not pre_damage then return end

             post_damage = sdk.to_float(args[3])

             if sdk.to_float(args[10]) < 0 then
                 if pl.KitchenSkill._048.Flags[1] then
                     pre_damage = pre_damage * pl.KitchenSkill._048.Params[2][sd.ks[pl.KitchenSkill._048.Id]:get_field("_SkillLv")]
                     pl.KitchenSkill._048.Flags[1] = false
                 end
             end
         end,
         function(retval)
             if not is_master_player or not post_damage or not pre_damage then
                 return
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
                     display_skill_message(SkillType.Reduce, true)
                 end
             end
             is_reduce = false
         end,
         function(retval)
         end)

sdk.hook(sdk.find_type_definition("snow.player.PlayerQuestBase"):get_method("onDestroy()"),
         function(args)
         end,
         function(retval)
             init_data()

             is_quest = false
         end)

--------------------------------------------------------------------------------
------------------------------------ Config ------------------------------------
--------------------------------------------------------------------------------

-- ModOptionsMenu (https://github.com/Bolt-Scripts/MHR-InGame-ModMenu-API)
local success, ModUI = pcall(require, "ModOptionsMenu.ModMenuApi")

if success then
    ---@param s string
    ---@return string
    ---@return integer
    local function remove_new_line(s)
        return s:gsub("<COL[^>]*>{0}</COL[^>]*>[\n\r]", "%1 "):gsub("[\n\r]<COL[^>]*>{0}</COL[^>]*>", " %1"):gsub("[\n\r]", "")
    end

    ---@generic T: table, K, V
    ---@param t T
    ---@return fun():integer, K, V
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

    local config     = {}

    config.path      = "Improved Skill Notifications/config.json"
    config.data      = json.load_file(config.path) or {}
    config.need_init = true

    ---@param current_config table
    ---@param reference table
    ---@return table
    function config.normalize(current_config, reference)
        local result = {}

        for idx, _, skill in pairs_by_keys(reference) do
            local found
            local default_table = { skill.Enum, skill.Notice[1], skill.Notice[2], 1 }

            if current_config then
                for _, skill_config in ipairs(current_config) do
                    if not found and skill_config[1] == skill.Enum then
                        if #skill_config ~= 4 then
                            skill_config = default_table
                        end

                        table.insert(result, skill_config)

                        found = true
                    end
                end
            end

            if not found then
                table.insert(result, idx, default_table)
            end
        end

        return result
    end

    ---@return nil
    function config.save()
        fs.write(config.path, json.dump_string(config.data))
    end

    ---@return boolean
    function config.init()
        local current_hunter_slot_num = get_current_hunter_slot_num()

        if not current_hunter_slot_num or current_hunter_slot_num == -1 then
            return false
        end

        if not singleton.player_manager then
            return false
        end

        m = m or {}

        m.master_player_id = m.master_player_id or singleton.player_manager:call("getMasterPlayerID()")

        if not m.master_player_id then
            return false
        end

        m.player_skill_list = m.player_skill_list or singleton.player_manager:get_field("<PlayerSkill>k__BackingField")[m.master_player_id]

        if not m.player_skill_list then
            return false
        end

        pl = pl or get_skill_data(singleton.player_manager)

        if not pl then
            return false
        end

        sd                         = sd or {
            es = get_equip_skill_data(m.player_skill_list),
            ks = get_kitchen_skill_data(m.player_skill_list)
        }

        local default_color_config = { 0xFF, 0xFF, 0xFF, 1 }

        config.data.EquipSkill     = config.normalize(config.data.EquipSkill, pl.EquipSkill)
        config.data.KitchenSkill   = config.normalize(config.data.KitchenSkill, pl.KitchenSkill)

        config.data.COL            = config.data.COL or {}

        while #config.data.COL ~= 2 do
            if #config.data.COL > 2 then
                table.remove(config.data.COL, #config.data.COL)
            end
            if #config.data.COL < 2 then
                table.insert(config.data.COL, { table.unpack(default_color_config) })
            end
        end

        for _, v in ipairs(config.data.COL) do
            if #v < 4 then
                v = { table.unpack(default_color_config) }
            end
        end

        config.save()

        return true
    end

    ---@return nil
    function config.set_error_message()
        ModUI.Label(UI.Label.label, UI.Label.displayValue, UI.Label.toolTip)
    end

    ---@return nil
    function config.init_skill_option_names()
        local t = {
            pl.EquipSkill,
            pl.KitchenSkill
        }

        for idx, skills in ipairs(t) do
            UI.Options.SkillSettings.optionNames[idx] = {}
            for skill_idx, _, skill in pairs_by_keys(skills) do
                UI.Options.SkillSettings.optionNames[idx][skill_idx] = {}

                if skill.Notice[1] then
                    table.insert(UI.Options.SkillSettings.optionNames[idx][skill_idx], UI.Options.SkillSettings.msg[2])
                end

                if skill.Notice[2] then
                    table.insert(UI.Options.SkillSettings.optionNames[idx][skill_idx], UI.Options.SkillSettings.msg[3])
                end

                if UI.Options.SkillSettings.optionNames[idx][skill_idx] then
                    table.insert(UI.Options.SkillSettings.optionNames[idx][skill_idx], UI.Options.SkillSettings.msg[4])
                    if #UI.Options.SkillSettings.optionNames[idx][skill_idx] == 3 then
                        table.insert(UI.Options.SkillSettings.optionNames[idx][skill_idx], 1, UI.Options.SkillSettings.msg[1])
                    end
                end
            end
        end
    end

    ---@return nil
    function config.set_skill_settings()
        local t = { {
            Header         = UI.Header.EquipSkill,
            getSkillId     = get_player_equip_skill_id,
            get_skill_name = get_equip_skill_name,
            confSkill      = config.data.EquipSkill,
            SdSkill        = sd.es
        }, {
            Header         = UI.Header.KitchenSkill,
            getSkillId     = get_player_kitchen_skill_id,
            get_skill_name = get_kitchen_skill_name,
            confSkill      = config.data.KitchenSkill,
            SdSkill        = sd.ks
        } }

        for idx, v in ipairs(t) do
            ModUI.Header(v.Header.text)
            for skill_idx, skill in ipairs(v.confSkill) do
                local id = v.getSkillId(skill[1])
                local skill_name = v.get_skill_name(nil, id)

                if skill[4] > #UI.Options.SkillSettings.optionNames[idx][skill_idx] then
                    skill[4] = 1
                    config.save()
                end

                UI.Options.SkillSettings.curValue[skill_idx] = skill[4]
                UI.Options.SkillSettings.label = skill_name

                if UI.Options.SkillSettings.curValue[skill_idx] ~= 1 then
                    UI.Options.SkillSettings.label = UI.Options.SkillSettings.label:set_rgb_col(0xFF, 0xE2, 0x9D)
                end

                if not UI.Options.EquipSkills.isFilter or v.SdSkill[id] then
                    UI.Options.SkillSettings.wasChanged, UI.Options.SkillSettings.newIndex = ModUI.Options(UI.Options.SkillSettings.label,
                                                                                                           UI.Options.SkillSettings.curValue[skill_idx],
                                                                                                           UI.Options.SkillSettings.optionNames[idx][skill_idx],
                                                                                                           UI.Options.SkillSettings.optionMessages,
                                                                                                           UI.Options.SkillSettings.toolTip,
                                                                                                           UI.Options.SkillSettings.isImmediateUpdate)
                    if UI.Options.SkillSettings.wasChanged then
                        UI.Options.SkillSettings.curValue[skill_idx] = UI.Options.SkillSettings.newIndex

                        if UI.Options.SkillSettings.optionNames[idx][skill_idx][UI.Options.SkillSettings.curValue[skill_idx]] == UI.Options.SkillSettings.msg[2] then
                            skill[2] = true
                            skill[3] = false
                        elseif UI.Options.SkillSettings.optionNames[idx][skill_idx][UI.Options.SkillSettings.curValue[skill_idx]] == UI.Options.SkillSettings.msg[3] then
                            skill[2] = false
                            skill[3] = true
                        elseif UI.Options.SkillSettings.optionNames[idx][skill_idx][UI.Options.SkillSettings.curValue[skill_idx]] == UI.Options.SkillSettings.msg[4] then
                            skill[2] = false
                            skill[3] = false
                        elseif UI.Options.SkillSettings.optionNames[idx][skill_idx][UI.Options.SkillSettings.curValue[skill_idx]] == UI.Options.SkillSettings.msg[1] then
                            skill[2] = true
                            skill[3] = true
                        end

                        skill[4] = UI.Options.SkillSettings.curValue[skill_idx]

                        config.save()
                    end
                end
            end
        end
    end

    ---@return nil
    function config.set_color_settings()
        for idx, color in ipairs(config.data.COL) do
            UI.Options.COLOR.curValue[idx] = color[4]

            UI.Options.COLOR.wasChanged, UI.Options.COLOR.newIndex = ModUI.Options(UI.Options.COLOR.label[idx],
                                                                                   UI.Options.COLOR.curValue[idx],
                                                                                   UI.Options.COLOR.optionNames,
                                                                                   UI.Options.COLOR.optionMessages,
                                                                                   UI.Options.COLOR.toolTip,
                                                                                   UI.Options.COLOR.isImmediateUpdate)
            if UI.Options.COLOR.wasChanged then
                UI.Options.COLOR.curValue[idx] = UI.Options.COLOR.newIndex
                color[4] = UI.Options.COLOR.curValue[idx]
                config.save()
            end

            local example_message = get_message_by_name("EnemyIndex112_MR")

            if UI.Options.COLOR.curValue[idx] == 2 then
                UI.Options.COLOR.label[idx] = remove_new_line(UI.MSG.Pl[idx]):gsub("{0}", example_message:set_rgb_col(color[1], color[2], color[3]))
                ModUI.SetIndent(18)

                for j = 1, #UI.Slider.label do
                    UI.Slider.curValue[idx] = { [j] = color[j] }

                    UI.Slider.wasChanged, UI.Slider.newValue = ModUI.Slider(UI.Slider.label[j],
                                                                            UI.Slider.curValue[idx][j],
                                                                            UI.Slider.min,
                                                                            UI.Slider.max,
                                                                            UI.Slider.toolTip,
                                                                            UI.Slider.isImmediateUpdate)
                    if UI.Slider.wasChanged then
                        UI.Slider.curValue[idx][j] = UI.Slider.newValue
                        color[j] = UI.Slider.curValue[idx][j]
                        config.save()
                    end
                end

                ModUI.SetIndent(0)
            elseif UI.Options.COLOR.curValue[idx] == 1 then
                UI.Options.COLOR.label[idx] = remove_new_line(UI.MSG.Pl[idx]):gsub("{0}", example_message)
            end
        end
    end

    ModUI.OnMenu(UI.OnMenu.name, UI.OnMenu.description, function()
        if is_lang_changed() then
            UI = get_ui()
            config.init_skill_option_names()
        end

        if config.need_init then
            if not config.init() then
                config.set_error_message()

                return
            end

            config.init_skill_option_names()

            config.need_init = false
        end

        UI.Options.Selector.wasChanged, UI.Options.Selector.newIndex = ModUI.Options(UI.Options.Selector.label,
                                                                                     UI.Options.Selector.curValue,
                                                                                     UI.Options.Selector.optionNames,
                                                                                     UI.Options.Selector.optionMessages,
                                                                                     UI.Options.Selector.toolTip,
                                                                                     UI.Options.Selector.isImmediateUpdate)
        if UI.Options.Selector.wasChanged then
            UI.Options.Selector.curValue = UI.Options.Selector.newIndex
        end

        ModUI.Header()

        if UI.Options.Selector.curValue == 1 then
            if m.player_skill_list then
                UI.Options.EquipSkills.wasChanged, UI.Options.EquipSkills.newIndex = ModUI.Options(UI.Options.EquipSkills.label,
                                                                                                   UI.Options.EquipSkills.curValue,
                                                                                                   UI.Options.EquipSkills.optionNames,
                                                                                                   UI.Options.EquipSkills.optionMessages,
                                                                                                   UI.Options.EquipSkills.toolTip,
                                                                                                   UI.Options.EquipSkills.isImmediateUpdate)
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

            config.set_skill_settings()
        elseif UI.Options.Selector.curValue == 2 then
            config.set_color_settings()
        end
    end)

    sdk.hook(sdk.find_type_definition("snow.gui.GuiOptionWindow"):get_method("doClose()"),
             function(args)
             end,
             function(retval)
                 if not is_quest then
                     init_data()
                 end

                 config.need_init = true
             end)

    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------

    ---@return boolean
    local function skip_skill_message(args)
        local t = { {
            skill_config        = config.data.EquipSkill,
            get_skill_name      = get_equip_skill_name,
            get_player_skill_id = get_player_equip_skill_id
        }, {
            skill_config        = config.data.KitchenSkill,
            get_skill_name      = get_kitchen_skill_name,
            get_player_skill_id = get_player_kitchen_skill_id
        } }

        local pre_message = sdk.to_managed_object(args[3]):call("ToString()")

        for idx, v in ipairs(t) do
            for _, skill_config in ipairs(v.skill_config) do
                for color_idx, color_config in ipairs(config.data.COL) do
                    local enum = skill_config[1]
                    local id = v.get_player_skill_id(enum)
                    local skill_name = v.get_skill_name(nil, id)

                    local post_message

                    if idx == 2 and (id == 31 or id == 32) then
                        post_message = UI.MSG.Ot[1]
                    else
                        post_message = UI.MSG.Pl[color_idx]
                    end

                    post_message = post_message:gsub("{0}", skill_name)

                    if pre_message == post_message then
                        -- Skip skill message.
                        if not skill_config[color_idx + 1] then
                            return true
                        end

                        -- Custom color.
                        if color_config[4] == 2 then
                            local r = color_config[1]
                            local g = color_config[2]
                            local b = color_config[3]

                            local message = post_message:gsub("<COL[^>]*>{0}</COL[^>]*>", skill_name):gsub(skill_name, skill_name:set_rgb_col(r, g, b))
                            local managed_string = sdk.create_managed_string(message)

                            args[3] = sdk.to_ptr(managed_string)

                            return false
                        end
                    end
                end
            end
        end

        return false
    end

    sdk.hook(sdk.find_type_definition("snow.gui.ChatManager"):get_method("reqAddChatInfomation(System.String, System.UInt32)"),
             function(args)
                 if config.data.COL and config.data.EquipSkill and config.data.KitchenSkill then
                     if skip_skill_message(args) then
                         return sdk.PreHookResult.SKIP_ORIGINAL
                     end
                 end
             end,
             function(retval)
             end)
end
