local ModUI = require("ModOptionsMenu.ModMenuApi")

if ModUI then
    local FacilityDataManager = nil
    re.on_frame(function()
        if not FacilityDataManager then
            FacilityDataManager     = sdk.get_managed_singleton("snow.data.FacilityDataManager"):get_field("_Kitchen"):get_field("_MealFunc")
            local getGuidByName     = sdk.find_type_definition("via.gui.message"):get_method("getGuidByName")
            local message           = sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)")
            local Guid              = {}
            Guid[1]                 = getGuidByName:call(nil, "I_0124_Name")
            Guid[2]                 = getGuidByName:call(nil, "Fa_Kitchen_Skill_01")
            local label             = message:call(nil, Guid[2])

            local configFile        = "CustomDangoTicketRate/config.json"

            -- OnMenu
            local name              = "CustomDangoTicketRate"
            local description       = nil

            -- Slider
            local curValue          = nil
            local min               = 0
            local max               = 100
            local toolTip           = nil
            local isImmediateUpdate = false

            local function getConfig()
                return json.load_file(configFile)
            end

            local function updateOption(newValue)
                FacilityDataManager:set_field("_AddRateVal", newValue)
                fs.write(configFile, json.dump_string({ _AddRateVal = newValue }))
            end

            if getConfig() then
                curValue = updateOption(getConfig()._AddRateVal)
            end

            ModUI.OnMenu(name, description, function()
                curValue = FacilityDataManager:get_field("_AddRateVal")

                -- ModUI.Header(message:call(nil, Guid[1]))

                local wasChanged, newValue = ModUI.Slider(label, curValue, min, max, toolTip, isImmediateUpdate)
                if wasChanged then updateOption(newValue) end
            end)
        end
    end)
end
