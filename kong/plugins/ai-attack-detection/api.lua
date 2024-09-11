local endpoints   = require "kong.api.endpoints"
local utils       = require "kong.tools.utils"

local exporter = require "kong.plugins.prometheus.exporter"
local prometheus

local shared = ngx.shared
local ngx = ngx
local kong = kong
local escape_uri = ngx.escape_uri
local unescape_uri = ngx.unescape_uri

local buffer = require("string.buffer")
local declarative = require("kong.db.declarative")

local function getAllKeysFromCacheName(cache_name)
  local dict = shared[cache_name]

  if dict == nil then
    return kong.response.exit(404, { message = "This dict was not found" })
  end

  local keys = dict:get_keys()

  return keys
end

local function getValuesFromCacheName(cache_name, key)
    local dict = shared[cache_name]
    
    if dict == nil then
        return kong.response.exit(404, { message = "This dict was not found" })
    end

    local values = dict:get(key)

    return values
end

--resource = "cache-memory"
return {
  ["/memcache/:cache_name/size"] = {
    GET = function(self, db)
        if kong.db.strategy ~= "off" then
            return kong.response.exit(400, {
              message = "this endpoint is only available when Kong is configured to not use a database"
            })
          end

          local cache_name = self.params.cache_name
          local keys = getAllKeysFromCacheName(cache_name)

          local count = 0
  
          if keys then
            for _, key in ipairs(keys) do
                local value, err = dict:get(key)
                if value then
                    count = count + 1
                end
            end
          end
          
          return kong.response.exit(200, { config = count })
    end,
  },
  ["/memcache/:cache_name/:key"] = {
    GET = function(self, db)
      kong.log.debug("Routing /memcache/cache_name/key")
      if kong.db.strategy ~= "off" then
          return kong.response.exit(400, {
            message = "this endpoint is only available when Kong is configured to not use a database"
          })
        end

        local cache_name = self.params.cache_name
        local key = self.params.key
        local values = getValuesFromCacheName(cache_name, key)
       
        return kong.response.exit(200, { config = values })
  end
  },
  ["/memcache/:cache_name"] = {
    GET = function(self, db)
      if kong.db.strategy ~= "off" then
          return kong.response.exit(400, {
            message = "this endpoint is only available when Kong is configured to not use a database"
          })
        end

        local cache_name = self.params.cache_name
        local keys = getAllKeysFromCacheName(cache_name)
       
        return kong.response.exit(200, { config = keys })
  end
  }
}
