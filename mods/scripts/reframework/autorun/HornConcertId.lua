local type             = {
    horn_concert_id = sdk.find_type_definition("snow.data.DataDef.HornConcertId"),
    data_shortcut   = sdk.find_type_definition("snow.data.DataShortcut")
}

local horn_concert_id  = type.horn_concert_id:get_fields()
local get_concert_name = type.data_shortcut:get_method("getName(snow.data.DataDef.HornConcertId)")

local data             = ""
local max

for i = 2, #horn_concert_id do
    local enum = horn_concert_id[i]:get_name()

    if enum == "Concert_Max" then
        local id = horn_concert_id[i]:get_data(nil)

        max = id

        break
    end
end

for i = 2, #horn_concert_id do
    local id   = horn_concert_id[i]:get_data(nil)
    local enum = horn_concert_id[i]:get_name()
    local name = get_concert_name:call(nil, id)

    data       = ("%s%s %s"):format(data, id, enum)

    if id < max and #name > 0 then
        data = ("%s %s"):format(data, name)
    end

    data = ("%s\n"):format(data)
end

fs.write("HornConcertId.txt", data)
