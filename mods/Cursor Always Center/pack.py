import os
import subprocess
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "..\\.."))
import mod

mod.CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
mod.MOD_NAME = os.path.basename(mod.CURRENT_DIR)

mod.INCLUDE_DIR = [{"src": "build\\windows\\x64\\release", "arc": "reframework\\plugins", "ext": ".dll"}]
mod.CLEAN_DIR = ["build"]

mod.FORMAT_DIR = ["src"]
mod.CLANG_EXT = [".cpp", ".hpp", ".h"]

mod.OUT_PATH = os.path.join(mod.CURRENT_DIR, f"{mod.MOD_NAME}.zip")


if __name__ == "__main__":
    subprocess.run(["git", "pull", "--recurse-submodules"])
    subprocess.run(["git", "submodule", "update", "--init", "--recursive"])

    mod.Cpp.clang_format()

    subprocess.run(["xmake", "-y", "-r"], cwd=mod.CURRENT_DIR)

    mod.Zip.pack()
    mod.clean()
