import os, re, zipfile

input_file_path = "reframework\\autorun\\ChatLog.lua"
output_file_path = "ChatLog.lua"
zip_file_path = "Improved Skill Notifications.zip"
compression = zipfile.ZIP_DEFLATED
compresslevel = 9


def remove_lua_comments(lua_code):
    return re.sub(r"^.*--.*$\n", "", lua_code, flags=re.MULTILINE)


with open(input_file_path, "r", encoding="utf-8") as input_file:
    lua_code = input_file.read()

with open(output_file_path, "w", encoding="utf-8") as output_file:
    output_file.write(remove_lua_comments(lua_code))

with zipfile.ZipFile(zip_file_path, "w", compression=compression, compresslevel=compresslevel) as zip_file:
    zip_file.write(output_file_path, arcname=os.path.join(os.path.dirname(input_file_path), output_file_path))
    os.remove(output_file_path)
