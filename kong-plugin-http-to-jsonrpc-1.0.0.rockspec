package = "kong-plugin-http-to-jsonrpc"

version = "1.0.0"

local pluginName = package:match("^kong%-plugin%-(.+)$")

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://github.com/chenpi12311/kong-plugin.git",
  tag = "1.0.0"
}

description = {
  summary = "Convert Http Request to JsonRPC Request"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".string_util"] = "kong/plugins/"..pluginName.."/string_util.lua",
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}