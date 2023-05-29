local ModUI = require("ModOptionsMenu.ModMenuApi")

if ModUI then
    local isFirstOpen
    local Default_ScaleAndRateData = {}

    local function getEnemyManager()
        return sdk.get_managed_singleton("snow.enemy.EnemyManager")
    end
    local function get_RandomScaleTableDataList()
        return getEnemyManager():get_field("_BossRandomScale"):get_field("_RandomScaleTableDataList"):get_elements()
    end
    local function getBossScaleTblType()
        return sdk.find_type_definition("snow.enemy.EnemyDef.BossScaleTblType")
    end

    local function getMessageByName(Name)
        local Guid = sdk.find_type_definition("via.gui.message"):get_method("getGuidByName"):call(nil, Name)
        return sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)"):call(nil, Guid)
    end

    local function xRoundOff(num, dgt)
        local round = 10 ^ (-1 * dgt)
        return math.floor((num + 5 * (10 ^ (dgt - 1))) * round) / round
    end

    -- OnMenu
    local name                  = "EnemyBossRandomScaleData"
    local description           = nil

    -- Options(TblType)
    local TblTypelabel          = getMessageByName("CharMakeMsg_Me_070")
    local TblTypecurValue       = 1
    local TblTypeoptionNames    = {}
    local TblTypeoptionMessages
    local TblTypetoolTip
    local TblTypeisImmediateUpdate

    -- Label(TotalRate)
    local TotalRatelabel        = "TotalRate"
    local TotalRatedisplayValue
    local TotalRatetoolTip

    -- Button(Reset)
    local Resetlabel
    local Resetprompt           = getMessageByName("KeyAssign_Mes_Y_07_MR")
    local ResetisHighlight
    local ResettoolTip

    -- Header(Presets)
    local Presetstext           = getMessageByName("CharMakeMsg_Me_132")

    -- Options(Presets)
    local Presetslabel          = getMessageByName("CharMakeMsg_Me_132")
    local PresetscurValue       = 1
    local PresetsoptionNames    = { "None", "Big", "Small", "Half" }
    local PresetsoptionMessages
    local PresetstoolTip
    local PresetsisImmediateUpdate

    -- Header(_ScaleAndRateData)
    local _ScaleAndRateDatatext = "_ScaleAndRateData"

    local function getBossScaleTblTypeName(value)
        local TblNameFields = getBossScaleTblType():get_fields()
        for i = 1, #TblNameFields do
            if value == TblNameFields[i]:get_data(nil) then
                return TblNameFields[i]:get_name()
            end
        end
    end

    local function calcTotalRate(TblTypecurValue)
        return "<COL YEL>" .. get_RandomScaleTableDataList()[TblTypecurValue]:call("calcTotalRate()") .. "</COL>"
    end

    local function init_ScaleAndRateData(set)
        local _RandomScaleTableDataList = get_RandomScaleTableDataList()
        if isFirstOpen or not _RandomScaleTableDataList then return end
        for i = 1, #_RandomScaleTableDataList do
            if not Default_ScaleAndRateData[i] then Default_ScaleAndRateData[i] = {} end
            local _ScaleAndRateData = _RandomScaleTableDataList[i]:get_field("_ScaleAndRateData"):get_elements()
            for j = 1, #_ScaleAndRateData do
                if not Default_ScaleAndRateData[i][j] and not set then
                    Default_ScaleAndRateData[i][j] = { _Scale = xRoundOff(_ScaleAndRateData[j]:get_field("_Scale"), -6), _Rate = _ScaleAndRateData[j]:get_field("_Rate") }
                elseif Default_ScaleAndRateData and set then
                    _ScaleAndRateData[j]:set_field("_Scale", Default_ScaleAndRateData[i][j]._Scale)
                    _ScaleAndRateData[j]:set_field("_Rate", Default_ScaleAndRateData[i][j]._Rate)
                end
            end
        end
    end

    local function set_ScaleAndRateData(PresetcurValue)
        for i = 1, #get_RandomScaleTableDataList() do
            local _ScaleAndRateData = get_RandomScaleTableDataList()[i]:get_field("_ScaleAndRateData"):get_elements()
            for j = 1, #_ScaleAndRateData do
                if PresetcurValue == 2 and j == #_ScaleAndRateData then
                    _ScaleAndRateData[j]:set_field("_Rate", 100)
                elseif PresetcurValue == 3 and j == 1 then
                    _ScaleAndRateData[j]:set_field("_Rate", 100)
                elseif PresetcurValue == 4 and (j == 1 or j == #_ScaleAndRateData) then
                    _ScaleAndRateData[j]:set_field("_Rate", 50)
                    if #_ScaleAndRateData <= 1 then _ScaleAndRateData[j]:set_field("_Rate", 100) end
                else
                    _ScaleAndRateData[j]:set_field("_Rate", 0)
                end
            end
        end
    end

    local function get_ScaleAndRateData(TblTypecurValue, onlySize)
        local label = {}
        local curValue = {}
        local min = 0
        local max = 100
        local toolTip
        local isImmediateUpdate

        local wasChanged, newValue = {}, {}
        local _ScaleAndRateData = get_RandomScaleTableDataList()[TblTypecurValue]:get_field("_ScaleAndRateData"):get_elements()
        if onlySize then return #_ScaleAndRateData end
        for i = 1, #_ScaleAndRateData do
            label[i] = xRoundOff(_ScaleAndRateData[i]:get_field("_Scale"), -6)
            curValue[i] = _ScaleAndRateData[i]:get_field("_Rate")

            wasChanged[i], newValue[i] = ModUI.Slider(label[i], curValue[i], min, max, toolTip, isImmediateUpdate)

            if wasChanged[i] then
                curValue[i] = newValue[i]
                _ScaleAndRateData[i]:set_field("_Rate", curValue[i])
                PresetscurValue = 1
            end
        end
    end

    ModUI.OnMenu(name, description, function()
        TotalRatedisplayValue = calcTotalRate(TblTypecurValue)
        init_ScaleAndRateData()

        local ResetwasClicked = ModUI.Button(Resetlabel, Resetprompt, ResetisHighlight, ResettoolTip)
        if ResetwasClicked then
            init_ScaleAndRateData(true)
            PresetscurValue = 1
            get_ScaleAndRateData(TblTypecurValue)
        end

        for i = 1, #get_RandomScaleTableDataList() do
            local _Type = get_RandomScaleTableDataList()[i]:get_field("_Type")
            TblTypeoptionNames[i] = getBossScaleTblTypeName(_Type)
        end
        local TblTypewasChanged, TblTypenewIndex = ModUI.Options(TblTypelabel, TblTypecurValue, TblTypeoptionNames, TblTypeoptionMessages, TblTypetoolTip, TblTypeisImmediateUpdate)

        ModUI.Label(TotalRatelabel, TotalRatedisplayValue, TotalRatetoolTip)

        if TblTypewasChanged then
            TblTypecurValue = TblTypenewIndex
        end

        ModUI.Header(Presetstext)

        local PresetswasChanged, PresetsnewIndex = ModUI.Options(Presetslabel, PresetscurValue, PresetsoptionNames, PresetsoptionMessages, PresetstoolTip, PresetsisImmediateUpdate)
        if PresetswasChanged then
            PresetscurValue = PresetsnewIndex
            set_ScaleAndRateData(PresetsnewIndex)
            get_ScaleAndRateData(TblTypecurValue)
        end

        ModUI.Header(_ScaleAndRateDatatext)

        get_ScaleAndRateData(TblTypecurValue)
    end)
end
