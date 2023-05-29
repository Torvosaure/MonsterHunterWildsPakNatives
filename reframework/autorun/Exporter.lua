local function Export(type)
    local getEquipSkillName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
    local _CurrentHunterSlotNo = sdk.get_managed_singleton("snow.SnowSaveService"):get_field("_CurrentHunterSlotNo")
    local mItems = sdk.get_managed_singleton("snow.data.DataManager"):get_field("_PlEquipBox"):get_field("_WeaponArmorInventoryList"):get_field("mItems"):get_elements()

    if _CurrentHunterSlotNo == -1 or _CurrentHunterSlotNo == nil then return false end

    local function getStrTalisman()
        local StrTalisman = ""
        for i = 1, #mItems do
            if mItems[i]:get_field("_IdType") == 3 then
                local count = mItems[i]:get_field("MaxDecoSlotNum")
                local _TalismanSkillIdList = mItems[i]:get_field("_TalismanSkillIdList"):get_elements()
                local _TalismanSkillLvList = mItems[i]:get_field("_TalismanSkillLvList"):get_elements()
                local _TalismanDecoSlotNumList = mItems[i]:get_field("_TalismanDecoSlotNumList"):get_elements()

                for j = 1, #_TalismanSkillIdList do
                    StrTalisman = StrTalisman .. getEquipSkillName(nil, _TalismanSkillIdList[j]:get_field("value__")) .. "," .. _TalismanSkillLvList[j]:get_field("mValue") .. ","
                end

                for k = #_TalismanDecoSlotNumList, 1, -1 do
                    local mValue = _TalismanDecoSlotNumList[k]:get_field("mValue")
                    for l = 1, mValue do
                        StrTalisman = StrTalisman .. k - 1
                        count = count - 1
                        if count ~= 0 then StrTalisman = StrTalisman .. "," end
                    end
                end
                while count > 0 do
                    StrTalisman = StrTalisman .. "0"
                    if count > 1 then StrTalisman = StrTalisman .. "," end
                    count = count - 1
                end

                StrTalisman = StrTalisman .. "\n"
            end
        end
        return StrTalisman
    end

    local function getStrQuriousArmorCrafting()
        local StrQuriousArmorCrafting = ""
        for i = 1, #mItems do
            if mItems[i]:get_field("_IdType") == 2 and mItems[i]:get_field("_CustomEnable") then
                local SlotLvTable = {}
                local count = 0
                local ArmorData = mItems[i]:call("getArmorData()")
                local DecorationSlotNumList = ArmorData:call("get_DecorationSlotNumList()")
                local OriginalSlotLvTable = ArmorData:call("getOriginalSlotLvTable()")
                local CustomSkillUpList = ArmorData:call("getCustomSkillUpList()")
                local CustomSkillDownList = ArmorData:call("getCustomSkillDownList()")

                StrQuriousArmorCrafting = StrQuriousArmorCrafting .. mItems[i]:call("getName()") .. ","

                StrQuriousArmorCrafting = StrQuriousArmorCrafting .. ArmorData:call("get_CustomAddDef()") .. ","
                for j = 0, 4 do
                    StrQuriousArmorCrafting = StrQuriousArmorCrafting .. ArmorData:call("getCustomAddReg(snow.data.DataDef.ArmorElementRegistTypes)", j) .. ","
                end
                for k = #DecorationSlotNumList - 1, 0, -1 do
                    for l = 1, DecorationSlotNumList:get_Item(k) do
                        table.insert(SlotLvTable, k + 1)
                    end
                    if k == 0 and #SlotLvTable < 3 then
                        while #SlotLvTable < 3 do
                            table.insert(SlotLvTable, 0)
                        end
                    end
                end
                for m = 0, #OriginalSlotLvTable - 1 do
                    StrQuriousArmorCrafting = StrQuriousArmorCrafting .. (SlotLvTable[m + 1] - OriginalSlotLvTable:get_Item(m)) .. ","
                end

                for n = 0, CustomSkillUpList:call("get_Count()") - 1 do
                    StrQuriousArmorCrafting = StrQuriousArmorCrafting .. CustomSkillUpList:get_Item(n):call("get_Name()") .. "," .. CustomSkillUpList:get_Item(n):call("get_TotalLv()") .. ","
                    count = count + 1
                end
                for o = 0, CustomSkillDownList:call("get_Count()") - 1 do
                    StrQuriousArmorCrafting = StrQuriousArmorCrafting .. CustomSkillDownList:get_Item(o):call("get_Name()") .. "," .. CustomSkillDownList:get_Item(o):call("get_TotalLv()") .. ","
                    count = count + 1
                end
                while count < 5 do
                    StrQuriousArmorCrafting = StrQuriousArmorCrafting .. ","
                    if count < 4 then StrQuriousArmorCrafting = StrQuriousArmorCrafting .. "," end
                    count = count + 1
                end

                StrQuriousArmorCrafting = StrQuriousArmorCrafting .. "\n"
            end
        end
        return StrQuriousArmorCrafting
    end

    local str = ""
    if type == 1 then
        str = getStrTalisman()
        fs.write("Exporter/Save00" .. _CurrentHunterSlotNo .. "_Talisman.txt", str)
    elseif type == 2 then
        str = getStrQuriousArmorCrafting()
        fs.write("Exporter/Save00" .. _CurrentHunterSlotNo .. "_QuriousArmorCrafting.txt", str)
    end

    return true
end

local modUI = require("ModOptionsMenu.ModMenuApi")

if modUI then
    local function getMessageByName(Name)
        local Guid = sdk.find_type_definition("via.gui.message"):get_method("getGuidByName"):call(nil, Name)
        return sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)"):call(nil, Guid)
    end

    -- OnMenu
    local name = "Exporter"
    local description = nil

    -- Talisman Button
    local tLabel = getMessageByName("Fa_MakaAlchemy_Head_08")
    local tPrompt = "Export"               -- optional
    local tIsHighlight = false             -- optional
    local tToolTip = "Exporting Talisman." -- optional
    -- Talisman PromptMsg
    local tPromptMessage = "<COL YEL>Exported Talisman</COL>"

    -- Qurious Armor Crafting Button
    local qLabel = getMessageByName("Smithy_Topmenu_09_MR")
    local qPrompt = "Export"                             -- optional
    local qIsHighlight = false                           -- optional
    local qToolTip = "Exporting Qurious Armor Crafting." -- optional
    -- Qurious Armor Crafting PromptMsg
    local qPromptMessage = "<COL YEL>Exported Qurious Armor Crafting</COL>"

    local promptErrorMessage = "<COL RED>Error: </COL><COL YEL>Please select the saved data before executing.</COL>"

    modUI.OnMenu(name, description, function()
        if modUI.Button(tLabel, tPrompt, tIsHighlight, tToolTip) then
            if Export(1) then
                modUI.PromptMsg(tPromptMessage, function()
                end)
            else
                modUI.PromptMsg(promptErrorMessage, function()
                end)
            end
        end
        if modUI.Button(qLabel, qPrompt, qIsHighlight, qToolTip) then
            if Export(2) then
                modUI.PromptMsg(qPromptMessage, function()
                end)
            else
                modUI.PromptMsg(promptErrorMessage, function()
                end)
            end
        end
    end)
end
