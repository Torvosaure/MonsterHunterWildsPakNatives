local success, ModUI = pcall(require, "ModOptionsMenu.ModMenuApi")

if not success then
    return
end

local singleton

local type = {
    boss_scale_tbl_type = sdk.find_type_definition("snow.enemy.EnemyDef.BossScaleTblType"),
    message             = sdk.find_type_definition("via.gui.message")
}

function math.round(number, num_digits)
    local scale = 10 ^ num_digits
    return math.floor(number * scale + 0.5) / scale
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

local function get_random_scale_table_data_list()
    return singleton.enemy_manager:get_field("_BossRandomScale"):get_field("_RandomScaleTableDataList"):get_elements()
end

local function get_boss_scale_tbl_type_name(value)
    local fields = type.boss_scale_tbl_type:get_fields()
    for _, field in ipairs(fields) do
        if value == field:get_data(nil) then
            return field:get_name()
        end
    end
end

local data = {
    default = {},
    custom  = {}
}

local function backup_default_data()
    local random_scale_table_data_list = get_random_scale_table_data_list()

    for i, random_scale_table_data in ipairs(random_scale_table_data_list) do
        data.default[i] = {}
        for j, scale_and_rate_data in ipairs(random_scale_table_data:get_field("_ScaleAndRateData"):get_elements()) do
            data.default[i][j] = {
                scale = math.round(scale_and_rate_data:get_field("_Scale"), 6),
                rate  = scale_and_rate_data:get_field("_Rate")
            }
        end
    end
end

local function set_scale_and_rate_data(tbl)
    local random_scale_table_data_list = get_random_scale_table_data_list()

    for i, random_scale_table_data in ipairs(random_scale_table_data_list) do
        local tbl_type = tbl[i]

        if tbl_type then
            local scale_and_rate_elements = random_scale_table_data:get_field("_ScaleAndRateData"):get_elements()

            for j, scale_and_rate_data in ipairs(scale_and_rate_elements) do
                local tbl_data = tbl_type[j]

                if tbl_data and tbl_data.scale and tbl_data.rate then
                    scale_and_rate_data:set_field("_Scale", tbl_data.scale)
                    scale_and_rate_data:set_field("_Rate", tbl_data.rate)
                else
                    break
                end
            end
        else
            break
        end
    end
end

local preset = {
    none  = { idx = 1, value = 0 },
    big   = { idx = 2, value = 100 },
    small = { idx = 3, value = 100 },
    half  = { idx = 4, value = 50 }
}

function preset.set_data(idx)
    local random_scale_table_data_list = get_random_scale_table_data_list()

    for _, random_scale_table_data in ipairs(random_scale_table_data_list) do
        local scale_and_rate_data_list = random_scale_table_data:get_field("_ScaleAndRateData"):get_elements()
        local data_length = #scale_and_rate_data_list
        for i, scale_and_rate_data in ipairs(scale_and_rate_data_list) do
            if idx == preset.big.idx and i == data_length then
                scale_and_rate_data:set_field("_Rate", preset.big.value)
            elseif idx == preset.small.idx and i == 1 then
                scale_and_rate_data:set_field("_Rate", preset.small.value)
            elseif idx == preset.half.idx and (i == 1 or i == data_length) then
                scale_and_rate_data:set_field("_Rate", preset.half.value)
                if data_length <= 1 then scale_and_rate_data:set_field("_Rate", preset.big.value) end
            else
                scale_and_rate_data:set_field("_Rate", preset.none.value)
            end
        end
    end
end

local ui = {
    menu = { -- OnMenu
        name        = "Custom Enemy Boss Random Scale Data",
        description = ""
    },
    reset = { -- Button
        label        = "",
        prompt       = get_message_by_name("KeyAssign_Mes_Y_07_MR"),
        is_highlight = false,
        tool_tip     = "",

        was_clicked  = false
    },
    type = { -- Options
        label               = get_message_by_name("CharMakeMsg_Me_070"),
        cur_value           = 1,
        option_names        = {},
        option_messages     = {},
        tool_tip            = "",
        is_immediate_update = false,

        was_changed         = false,
        new_index           = 1
    },
    total_rate = { -- Label
        label         = "Total Rate",
        display_value = "",
        tool_tip      = ""
    },
    preset = { -- Options
        label               = get_message_by_name("CharMakeMsg_Me_132"),
        cur_value           = 1,
        option_names        = { "None", "Big", "Small", "Half" },
        option_messages     = {},
        tool_tip            = "",
        is_immediate_update = false,

        was_changed         = false,
        new_index           = 1
    },
    data = { -- Slider
        label               = "",
        cur_value           = 1,
        min                 = 0,
        max                 = 100,
        tool_tip            = "",
        is_immediate_update = false,

        was_changed         = false,
        new_value           = 0
    }
}

local function init()
    singleton = {
        enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager")
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

    backup_default_data()

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
    local random_scale_table_data_list = get_random_scale_table_data_list()

    ui.reset.was_clicked = ModUI.Button(ui.reset.label, ui.reset.prompt, ui.reset.is_highlight, ui.reset.tool_tip)
    if ui.reset.was_clicked then
        set_scale_and_rate_data(data.default)
        ui.preset.cur_value = 1

        return
    end

    for i, random_scale_table_data in ipairs(random_scale_table_data_list) do
        ui.type.option_names[i] = get_boss_scale_tbl_type_name(random_scale_table_data:get_field("_Type"))
    end

    ui.type.was_changed, ui.type.new_index = ModUI.Options(ui.type.label,
                                                           ui.type.cur_value,
                                                           ui.type.option_names,
                                                           ui.type.option_messages,
                                                           ui.type.tool_tip,
                                                           ui.type.is_immediate_update)
    if ui.type.was_changed then
        ui.type.cur_value = ui.type.new_index
    end

    local total_rate = random_scale_table_data_list[ui.type.cur_value]:call("calcTotalRate()")
    ui.total_rate.display_value = ("<COL YEL>%s</COL>"):format(total_rate)

    ModUI.Label(ui.total_rate.label, ui.total_rate.display_value, ui.total_rate.tool_tip)

    ModUI.Header(ui.preset.label)

    ui.preset.was_changed, ui.preset.new_index = ModUI.Options(ui.preset.label,
                                                               ui.preset.cur_value,
                                                               ui.preset.option_names,
                                                               ui.preset.option_messages,
                                                               ui.preset.tool_tip,
                                                               ui.preset.is_immediate_update)
    if ui.preset.was_changed then
        ui.preset.cur_value = ui.preset.new_index
        preset.set_data(ui.preset.cur_value)

        return
    end

    ModUI.Header("Scale And Rate Data")

    local scale_and_rate_data_list = random_scale_table_data_list[ui.type.cur_value]:get_field("_ScaleAndRateData"):get_elements()
    for _, scale_and_rate_data in ipairs(scale_and_rate_data_list) do
        ui.data.label = math.round(scale_and_rate_data:get_field("_Scale"), 6)
        ui.data.cur_value = scale_and_rate_data:get_field("_Rate")

        ui.data.was_changed, ui.data.new_value = ModUI.Slider(ui.data.label,
                                                              ui.data.cur_value,
                                                              ui.data.min,
                                                              ui.data.max,
                                                              ui.data.tool_tip,
                                                              ui.data.is_immediate_update)
        if ui.data.was_changed then
            ui.data.cur_value = ui.data.new_value
            scale_and_rate_data:set_field("_Rate", ui.data.cur_value)

            ui.preset.cur_value = 1
        end
    end
end)

re.on_script_reset(function()
    set_scale_and_rate_data(data.default)
end)
