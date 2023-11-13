local success, ModUI = pcall(require, "ModOptionsMenu.ModMenuApi")

if not success then
    return
end

local singleton

local type                = {
    message = sdk.find_type_definition("via.gui.message")
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

local ui = {
    menu = { -- OnMenu
        name        = "Custom Dango Ticket Rate",
        description = ""
    },
    rate = { -- Slider
        label               = get_message_by_name("Fa_Kitchen_Skill_01"),
        cur_value           = 40,
        min                 = 0,
        max                 = 100,
        tool_tip            = "",
        is_immediate_update = false,

        was_changed         = false,
        new_value           = 40
    }
}

local meal_func

---@return boolean
local function init()
    singleton = {
        facility_data_manager = sdk.get_managed_singleton("snow.data.FacilityDataManager")
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

    meal_func = singleton.facility_data_manager:get_field("_Kitchen"):get_field("_MealFunc")

    if not meal_func then
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
    ui.rate.cur_value = meal_func:get_field("_AddRateVal")

    ui.rate.was_changed, ui.rate.new_value = ModUI.Slider(ui.rate.label,
                                                          ui.rate.cur_value,
                                                          ui.rate.min,
                                                          ui.rate.max,
                                                          ui.rate.tool_tip,
                                                          ui.rate.is_immediate_update)
    if ui.rate.was_changed then
        meal_func:set_field("_AddRateVal", ui.rate.new_value)
    end
end)
