local ModUI = require("ModOptionsMenu.ModMenuApi")

if ModUI then
    local function get_CurrentHunterSlotNo()
        return sdk.get_managed_singleton("snow.SnowSaveService"):get_field("_CurrentHunterSlotNo")
    end
    local function getMessageByName(Name)
        local Guid = sdk.find_type_definition("via.gui.message"):get_method("getGuidByName"):call(nil, Name)
        return sdk.find_type_definition("via.gui.message"):get_method("get(System.Guid)"):call(nil, Guid)
    end

    -- OnMenu
    local name           = "<ICON Armor_CustomBuildUp00>Exporter"
    local description

    -- Label(Error)
    local ErrorToolTip   = getMessageByName("StartMenu_System_Common_GrayOut")

    -- Button(Talisman)
    local tLabel         = getMessageByName("Fa_MakaAlchemy_Head_08")
    local tPrompt        = getMessageByName("StartMenu_Menu_005_04")
    local tIsHighlight
    local tToolTip
    -- PromptMsg(Talisman)
    local tPromptMessage = getMessageByName("DialogMsg_System_NSW_DataSave_success")

    -- Button(Qurious Armor Crafting)
    local qLabel         = getMessageByName("Smithy_Topmenu_09_MR")
    local qPrompt        = getMessageByName("StartMenu_Menu_005_04")
    local qIsHighlight
    local qToolTip
    -- PromptMsg(Qurious Armor Crafting)
    local qPromptMessage = getMessageByName("DialogMsg_System_NSW_DataSave_success")

    local function Export(type)
        local getEquipSkillName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
        local mItems = sdk.get_managed_singleton("snow.data.DataManager"):get_field("_PlEquipBox"):get_field("_WeaponArmorInventoryList"):get_field("mItems"):get_elements()

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
                    local count = 3
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
                            StrQuriousArmorCrafting = StrQuriousArmorCrafting .. k + 1 - OriginalSlotLvTable:get_Item(3 - count) .. ","
                            count = count - 1
                        end
                        if k == 0 then
                            while count < 0 do
                                StrQuriousArmorCrafting = StrQuriousArmorCrafting .. "0" .. ","
                                count = count - 1
                            end
                        end
                    end

                    for m = 0, CustomSkillUpList:call("get_Count()") - 1 do
                        StrQuriousArmorCrafting = StrQuriousArmorCrafting .. CustomSkillUpList:get_Item(m):call("get_Name()") .. "," .. CustomSkillUpList:get_Item(m):call("get_TotalLv()") .. ","
                        count = count + 1
                    end
                    for n = 0, CustomSkillDownList:call("get_Count()") - 1 do
                        StrQuriousArmorCrafting = StrQuriousArmorCrafting .. CustomSkillDownList:get_Item(n):call("get_Name()") .. "," .. CustomSkillDownList:get_Item(n):call("get_TotalLv()") .. ","
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

        if type == 1 then
            fs.write("Exporter/Save00" .. get_CurrentHunterSlotNo() .. "_Talisman.txt", getStrTalisman())
            ModUI.PromptMsg(tPromptMessage)
        elseif type == 2 then
            fs.write("Exporter/Save00" .. get_CurrentHunterSlotNo() .. "_QuriousArmorCrafting.txt", getStrQuriousArmorCrafting())
            ModUI.PromptMsg(qPromptMessage)
        end
    end

    ModUI.OnMenu(name, description, function()
        if get_CurrentHunterSlotNo() == -1 or get_CurrentHunterSlotNo() == nil then
            ModUI.Label(tLabel, tPrompt, ErrorToolTip)
            ModUI.Label(qLabel, qPrompt, ErrorToolTip)
            return
        end
        if ModUI.Button(tLabel, tPrompt, tIsHighlight, tToolTip) then Export(1) end
        if ModUI.Button(qLabel, qPrompt, qIsHighlight, qToolTip) then Export(2) end
    end)
end
