local plugin_name = "cache-memory"
local package_name = "kong-plugin-" .. plugin_name
local package_version = "1.0.0"
local rockspec_revision = "1"

local github_account_name = "Kong"
local github_repo_name = "kong-plugin"
local git_checkout = package_version == "dev" and "master" or package_version


package = package_name
version = package_version .. "-" .. rockspec_revision
supported_platforms = { "linux", "macosx" }
source = {
  url = "git+https://github.com/"..github_account_name.."/"..github_repo_name..".git",
  branch = git_checkout,
}


description = {
  summary = "Kong is a scalable and customizable API Management Layer built on top of Nginx.",
  homepage = "https://"..github_account_name..".github.io/"..github_repo_name,
  license = "Apache 2.0",
}


dependencies = {
  "lua >= 5.1",
  "lua-resty-http",
  "lunajson"
}


build = {
  type = "builtin",
  modules = {
    ["kong.plugins.ai-attack-detection.handler"] = "kong/plugins/ai-attack-detection/handler.lua",
    ["kong.plugins.ai-attack-detection.schema"] = "kong/plugins/ai-attack-detection/schema.lua",
  }
}