local type                   = {
    pl_kitchen_skill_id = sdk.find_type_definition("snow.data.DataDef.PlKitchenSkillId"),
    data_shortcut       = sdk.find_type_definition("snow.data.DataShortcut")
}

local pl_kitchen_skill_id    = type.pl_kitchen_skill_id:get_fields()
local get_kitchen_skill_name = type.data_shortcut:get_method("getName(snow.data.DataDef.PlKitchenSkillId)")

local data                   = ""
local max

for i = 2, #pl_kitchen_skill_id do
    local enum = pl_kitchen_skill_id[i]:get_name()

    if enum == "Max" then
        local id = pl_kitchen_skill_id[i]:get_data(nil)

        max = id

        break
    end
end

for i = 2, #pl_kitchen_skill_id do
    local id = pl_kitchen_skill_id[i]:get_data(nil)
    local enum = pl_kitchen_skill_id[i]:get_name()
    local name = get_kitchen_skill_name:call(nil, id)

    data = ("%s%s %s"):format(data, id, enum)

    if id < max and #name > 0 then
        data = ("%s %s"):format(data, name)
    end

    data = ("%s\n"):format(data)
end

fs.write("PlKitchenSkillId.txt", data)
