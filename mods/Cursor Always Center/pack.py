import os
import subprocess
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "..\\.."))
import mod

mod.CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
mod.MOD_NAME = os.path.basename(mod.CURRENT_DIR)

mod.INCLUDE_DIR = [{"src": "build\\windows\\x64\\release", "arc": "reframework\\plugins", "ext": ".dll"}]
mod.CLEAN_DIR = [".xmake", "build"]

mod.FORMAT_DIR = ["src"]
mod.CLANG_EXT = [".cpp", ".hpp", ".h"]

mod.OUT_PATH = os.path.join(mod.CURRENT_DIR, f"{mod.MOD_NAME}.zip")


if __name__ == "__main__":
    subprocess.run(["git", "submodule", "update", "--remote"])

    mod.Cpp.clang_format()

    subprocess.run(["xmake", "clean", "--yes", "--all"], cwd=mod.CURRENT_DIR)
    subprocess.run(["xmake", "global", "--yes", "--check"], cwd=mod.CURRENT_DIR)
    subprocess.run(["xmake", "config", "--yes", "--check"], cwd=mod.CURRENT_DIR)
    subprocess.run(["xmake", "--yes"], cwd=mod.CURRENT_DIR)

    mod.Zip.pack()
    mod.clean()
