local data              = ""
local getEquipSkillName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
local PlEquipSkillId    = sdk.find_type_definition("snow.data.DataDef.PlEquipSkillId"):get_fields()

for i = 2, #PlEquipSkillId do
    data = data .. PlEquipSkillId[i]:get_data(nil) .. " "
    data = data .. PlEquipSkillId[i]:get_name()

    local name = getEquipSkillName(nil, PlEquipSkillId[i]:get_data(nil))
    if #name > 0 then
        data = data .. " " .. name .. "\n"
    else
        data = data .. "\n"
    end
end

fs.write("PlEquipSkillId.txt", data)
