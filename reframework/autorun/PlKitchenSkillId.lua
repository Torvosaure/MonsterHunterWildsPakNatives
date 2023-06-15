local data                = ""
local getKitchenSkillName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.PlKitchenSkillId)")
local PlKitchenSkillId    = sdk.find_type_definition("snow.data.DataDef.PlKitchenSkillId"):get_fields()

for i = 2, #PlKitchenSkillId do
    data = data .. PlKitchenSkillId[i]:get_data(nil) .. " "
    data = data .. PlKitchenSkillId[i]:get_name()

    local name = getKitchenSkillName(nil, PlKitchenSkillId[i]:get_data(nil))
    if #name > 10 then
        data = data .. " " .. name .. "\n"
    else
        data = data .. "\n"
    end
end

fs.write("PlKitchenSkillId.txt", data)
