local data              = ""
local getEquipSkillName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlEquipSkillId)")
local PlEquipSkillId    = sdk.find_type_definition("snow.data.DataDef.PlEquipSkillId"):get_fields()

for i = 2, #PlEquipSkillId do
    data = data .. PlEquipSkillId[i]:get_data(nil) .. " "
    data = data .. PlEquipSkillId[i]:get_name() .. " "
    data = data .. getEquipSkillName(nil, PlEquipSkillId[i]:get_data(nil)) .. "\n"
end

fs.write("PlEquipSkillId.txt", data)
