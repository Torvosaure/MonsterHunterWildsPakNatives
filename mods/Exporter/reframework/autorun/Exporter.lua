local success, ModUI = pcall(require, "ModOptionsMenu.ModMenuApi")

if not success then
    return
end

local singleton

local type                = {
    message       = sdk.find_type_definition("via.gui.message"),
    data_shortcut = sdk.find_type_definition("snow.data.DataShortcut")
}

local get_guid_by_name    = type.message:get_method("getGuidByName(System.String)")
local get_message_by_guid = type.message:get_method("get(System.Guid)")
---@param name string
---@return string
local function get_message_by_name(name)
    local guid    = get_guid_by_name:call(nil, name)
    local message = get_message_by_guid:call(nil, guid)

    return message
end

local function get_current_hunter_slot_num()
    return singleton.snow_save_service:get_field("_CurrentHunterSlotNo")
end

local export = {}

function export.talisman()
    local get_equip_skill_name = type.data_shortcut:get_method("getName(snow.data.DataDef.PlEquipSkillId)")
    local items = singleton.data_manager:get_field("_PlEquipBox"):get_field("_WeaponArmorInventoryList"):get_field("mItems"):get_elements()

    local talisman = ""

    for _, item in ipairs(items) do
        if item:get_field("_IdType") == 3 then
            local max_deco_slot_num = item:get_field("MaxDecoSlotNum")

            for _, skill_id in ipairs(item:get_field("_TalismanSkillIdList"):get_elements()) do
                talisman = ("%s%s,"):format(talisman, get_equip_skill_name(nil, skill_id:get_field("value__")))
            end

            for _, skill_lv in ipairs(item:get_field("_TalismanSkillLvList"):get_elements()) do
                talisman = ("%s%s,"):format(talisman, skill_lv:get_field("mValue"))
            end

            local slot_num_list = item:get_field("_TalismanDecoSlotNumList"):get_elements()
            for i = #slot_num_list, 1, -1 do
                local value = slot_num_list[i]:get_field("mValue")
                for _ = 1, value do
                    talisman = ("%s%s"):format(talisman, i - 1)

                    max_deco_slot_num = max_deco_slot_num - 1
                    if max_deco_slot_num ~= 0 then
                        talisman = ("%s,"):format(talisman)
                    end
                end
            end

            while max_deco_slot_num > 0 do
                talisman = ("%s0"):format(talisman)

                if max_deco_slot_num > 1 then
                    talisman = ("%s,"):format(talisman)
                end

                max_deco_slot_num = max_deco_slot_num - 1
            end

            talisman = ("%s\n"):format(talisman)
        end
    end

    fs.write(("Exporter\\Save00%s_Talisman.txt"):format(get_current_hunter_slot_num()), talisman)

    return true
end

function export.qurious()
    local items = singleton.data_manager:get_field("_PlEquipBox"):get_field("_WeaponArmorInventoryList"):get_field("mItems"):get_elements()

    local qurious = ""

    for _, item in ipairs(items) do
        if item:get_field("_IdType") == 2 and item:get_field("_CustomEnable") then
            local armor_data = item:call("getArmorData()")
            local count = 3

            qurious = ("%s%s,%s,"):format(qurious, item:call("getName()"), armor_data:call("get_CustomAddDef()"))

            for i = 0, 4 do
                qurious = ("%s%s,"):format(qurious, armor_data:call("getCustomAddReg(snow.data.DataDef.ArmorElementRegistTypes)", i))
            end

            local slot_lv_table = armor_data:call("getOriginalSlotLvTable()")
            local slot_num_list = armor_data:call("get_DecorationSlotNumList()")
            for j = #slot_num_list - 1, 0, -1 do
                for _ = 1, slot_num_list:call("Get(System.Int32)", j) do
                    qurious = ("%s%s,"):format(qurious, j + 1 - slot_lv_table:call("Get(System.Int32)", 3 - count))
                    count = count - 1
                end

                if j == 0 then
                    while count < 0 do
                        qurious = ("%s0,"):format(qurious)
                        count = count - 1
                    end
                end
            end

            local up_items = armor_data:call("getCustomSkillUpList()"):get_field("mItems"):get_elements()
            for _, up in ipairs(up_items) do
                qurious = ("%s%s,%s,"):format(qurious, up:call("get_Name()"), up:call("get_TotalLv()"))
                count = count + 1
            end

            local down_items = armor_data:call("getCustomSkillDownList()"):get_field("mItems"):get_elements()
            for _, down in ipairs(down_items) do
                qurious = ("%s%s,%s,"):format(qurious, down:call("get_Name()"), down:call("get_TotalLv()"))
                count = count + 1
            end

            while count < 5 do
                qurious = ("%s,"):format(qurious)
                if count < 4 then
                    qurious = ("%s,"):format(qurious)
                end
                count = count + 1
            end

            qurious = ("%s\n"):format(qurious)
        end
    end

    fs.write(("Exporter\\Save00%s_QuriousArmorCrafting.txt"):format(get_current_hunter_slot_num()), qurious)

    return true
end

local ui = {
    menu = { -- OnMenu
        name        = "<ICON Armor_CustomBuildUp00>Exporter",
        description = ""
    },
    t_error = { -- Label
        label         = get_message_by_name("Fa_MakaAlchemy_Head_08"),
        display_value = get_message_by_name("StartMenu_Menu_005_04"),
        tool_tip      = get_message_by_name("StartMenu_System_Common_GrayOut")
    },
    q_error = { -- Label
        label         = get_message_by_name("Smithy_Topmenu_09_MR"),
        display_value = get_message_by_name("StartMenu_Menu_005_04"),
        tool_tip      = get_message_by_name("StartMenu_System_Common_GrayOut")
    },
    talisman = { -- Button
        label        = get_message_by_name("Fa_MakaAlchemy_Head_08"),
        prompt       = get_message_by_name("StartMenu_Menu_005_04"),
        is_highlight = false,
        tool_tip     = "",

        was_clicked  = false
    },
    qurious = { -- Button
        label        = get_message_by_name("Smithy_Topmenu_09_MR"),
        prompt       = get_message_by_name("StartMenu_Menu_005_04"),
        is_highlight = false,
        tool_tip     = "",

        was_clicked  = false
    }
}

local function init()
    singleton = {
        snow_save_service = sdk.get_managed_singleton("snow.SnowSaveService"),
        data_manager = sdk.get_managed_singleton("snow.data.DataManager")
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

if not init() then
    sdk.hook(sdk.find_type_definition("snow.gui.fsm.title.GuiTitle"):get_method("start()"),
             function(args)
             end,
             function(retval)
                 init()
             end)
end

ModUI.OnMenu(ui.menu.name, ui.menu.description, function()
    local current_hunter_slot_num = get_current_hunter_slot_num()

    if not current_hunter_slot_num or current_hunter_slot_num == -1 then
        ModUI.Label(ui.t_error.label, ui.t_error.display_value, ui.t_error.tool_tip)
        ModUI.Label(ui.q_error.label, ui.q_error.display_value, ui.q_error.tool_tip)

        return
    end

    ui.talisman.was_clicked = ModUI.Button(ui.talisman.label, ui.talisman.prompt, ui.talisman.is_highlight, ui.talisman.tool_tip)

    if ui.talisman.was_clicked then
        if export.talisman() then
            ModUI.PromptMsg(get_message_by_name("DialogMsg_System_NSW_DataSave_success"))
        end
    end

    ui.qurious.was_clicked = ModUI.Button(ui.qurious.label, ui.qurious.prompt, ui.qurious.is_highlight, ui.qurious.tool_tip)

    if ui.qurious.was_clicked then
        if export.qurious() then
            ModUI.PromptMsg(get_message_by_name("DialogMsg_System_NSW_DataSave_success"))
        end
    end
end)
