import os, re, zipfile

mod_name = "Improved Skill Notifications"
input_file_path = rf"reframework\autorun\ChatLog.lua"
output_file_path = rf"{mod_name}\ChatLog.lua"


def remove_lua_comments(lua_code):
    return re.sub(r"\s*--.*$", "", lua_code, flags=re.MULTILINE)


with open(os.path.join(mod_name, input_file_path), "r", encoding="utf-8") as input_file:
    lua_code = input_file.read()

with open(output_file_path, "w", encoding="utf-8") as output_file:
    output_file.write(remove_lua_comments(lua_code))

with zipfile.ZipFile(f"{mod_name}\\{mod_name}.zip", "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zip_file:
    zip_file.write(output_file_path, arcname=os.path.join(os.path.dirname(input_file_path), os.path.basename(output_file_path)))
    os.remove(output_file_path)
