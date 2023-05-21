local function Export(type)
    local function getTalismanExportString(list, getName)
        local exportString = ""
        for i = 0, list:call("get_Count") - 1 do
            local v = list:call("get_Item", i)
            if v._IdType == 3 then
                local singleString = ""
                local lvList = v._TalismanSkillLvList
                local skillList = v._TalismanSkillIdList

                for j = 0, 1 do
                    singleString = singleString .. getName:call(nil, skillList:call("get_Item", j)) .. "," .. lvList:call("get_Item", j) .. ","
                end

                local decoList = v._TalismanDecoSlotNumList
                local decoString = ""

                for j = 4, 1, -1 do
                    local level = decoList:call("get_Item", j)
                    if level > 0 then
                        for k = 1, level do
                            decoString = decoString .. j .. ","
                        end
                    end
                end

                while string.len(decoString) < string.len("0,0,0") do
                    decoString = decoString .. "0,"
                end

                decoString = string.sub(decoString, 0, string.len("0,0,0"))
                singleString = singleString .. decoString
                exportString = exportString .. singleString .. "\n"
            end
        end
        return exportString
    end

    local function getQuriousArmorCraftingExportString(list)
        local exportString = ""
        for i = 0, list:call("get_Count") - 1 do
            local v = list:call("get_Item", i)
            if v._IdType == 2 and v._CustomEnable then
                local singleString = ""
                local armorData = v:getArmorData()
                local armorName = armorData:getName()
                local def = armorData:get_CustomAddDef()
                local orgDecos = armorData:getOriginalSlotLvTable()
                local DecosObj = armorData:get_DecorationSlotNumList()

                local Decos = {}
                for j = DecosObj:get_Count() - 1, 0, -1 do
                    local Deco = DecosObj:get_Item(j)
                    if Deco ~= 0 then
                        for k = 1, Deco do
                            table.insert(Decos, j + 1)
                        end
                    end
                end

                while #Decos < 3 do
                    table.insert(Decos, 0)
                end

                local decoString = ""
                for j = 0, orgDecos:get_Count() - 1 do
                    decoString = decoString .. (Decos[j + 1] - orgDecos:get_Item(j)) .. ","
                end

                local elemRes = ""
                for j = 0, 4 do
                    elemRes = elemRes .. armorData:getCustomAddReg(j) .. ","
                end

                local skillUps = armorData:getCustomSkillUpList()
                local skillDwns = armorData:getCustomSkillDownList()

                local skillCount = 0
                local skillString = ""

                for j = 0, skillUps:get_Count() - 1 do
                    local v = skillUps:get_Item(j)
                    skillCount = skillCount + 1
                    skillString = skillString .. v:get_Name() .. "," .. v:get_TotalLv() .. ","
                end

                for j = 0, skillDwns:get_Count() - 1 do
                    local v = skillDwns:get_Item(j)
                    skillCount = skillCount + 1
                    skillString = skillString .. v:get_Name() .. "," .. v:get_TotalLv() .. ","
                end

                while skillCount < 4 do
                    skillCount = skillCount + 1
                    skillString = skillString .. ",,"
                end

                singleString = string.sub(string.format("%s,%d,%s%s%s", armorName, def, elemRes, decoString, skillString), 0, -2)
                exportString = exportString .. singleString .. "\n"
            end
        end
        return exportString
    end

    local getName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")

    local saveManager = sdk.get_managed_singleton("snow.SnowSaveService")
    local slot = saveManager._CurrentHunterSlotNo

    if slot == -1 or slot == nil then
        return false
    end

    local data = sdk.get_managed_singleton("snow.data.DataManager")
    local box = data._PlEquipBox
    local list = box:get_field("_WeaponArmorInventoryList")

    local exportString = ""
    if type == "t" then
        exportString = getTalismanExportString(list, getName)
        fs.write("Exporter/Save00" .. slot .. "_Talisman.txt", exportString)
    elseif type == "q" then
        exportString = getQuriousArmorCraftingExportString(list)
        fs.write("Exporter/Save00" .. slot .. "_QuriousArmorCrafting.txt", exportString)
    end

    return true
end

local modUI = require("ModOptionsMenu.ModMenuApi")

-- OnMenu
local name = "Exporter"
local description = nil

-- Header
local text = nil

-- Talisman Button
local tLabel = "Talisman"
local tPrompt = "Export"               -- optional
local tIsHighlight = false             -- optional
local tToolTip = "Exporting Talisman." -- optional
-- Talisman PromptMsg
local tPromptMessage = "<COL YEL>Exported Talisman</COL>"

-- Qurious Armor Crafting Button
local qLabel = "Qurious Armor Crafting"
local qPrompt = "Export"                             -- optional
local qIsHighlight = false                           -- optional
local qToolTip = "Exporting Qurious Armor Crafting." -- optional
-- Qurious Armor Crafting PromptMsg
local qPromptMessage = "<COL YEL>Exported Qurious Armor Crafting</COL>"

local promptErrorMessage = "<COL RED>Error: </COL><COL YEL>Please select the saved data before executing.</COL>"

modUI.OnMenu(name, description, function()
    if modUI.Button(tLabel, tPrompt, tIsHighlight, tToolTip) then
        if Export("t") then
            modUI.PromptMsg(tPromptMessage, function()
            end)
        else
            modUI.PromptMsg(promptErrorMessage, function()
            end)
        end
    end
    if modUI.Button(qLabel, qPrompt, qIsHighlight, qToolTip) then
        if Export("q") then
            modUI.PromptMsg(qPromptMessage, function()
            end)
        else
            modUI.PromptMsg(promptErrorMessage, function()
            end)
        end
    end
end)
