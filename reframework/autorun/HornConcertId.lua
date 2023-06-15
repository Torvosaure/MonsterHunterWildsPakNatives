local data           = ""
local getConcertName = sdk.find_type_definition("snow.data.DataShortcut"):get_method("getName(snow.data.DataDef.HornConcertId)")
local HornConcertId  = sdk.find_type_definition("snow.data.DataDef.HornConcertId"):get_fields()

for i = 2, #HornConcertId do
    data = data .. HornConcertId[i]:get_data(nil) .. " "
    data = data .. HornConcertId[i]:get_name()

    local name = getConcertName(nil, HornConcertId[i]:get_data(nil))
    if not name:match("\n") then
        data = data .. " " .. name .. "\n"
    else
        data = data .. "\n"
    end
end

fs.write("HornConcertId.txt", data)
