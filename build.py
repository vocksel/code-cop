import os
import os.path

from elixir.compilers import ModelCompiler

NAME = "CodeCop"

# The source code is compiled into a ROBLOX Model right into the plugins folder.
#
# Simply run `python build.py` and everything will be taken care of. You can
# then load up any game and test out the plugin.

local_app_data = os.environ["LocalAppData"]
plugins_folder = os.path.join(local_app_data, "Roblox/Plugins")
plugin = os.path.join(plugins_folder, NAME + ".rbxmx")

ModelCompiler("src/", plugin).compile()
