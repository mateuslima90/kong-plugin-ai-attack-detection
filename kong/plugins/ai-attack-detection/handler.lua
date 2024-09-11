local error = error
local kong = kong
local log = kong.log
local ngx = ngx
local ngx_var = ngx.var
local shared = ngx.shared

local tablex = require "pl.tablex"

local http = require("resty.http")
local json = require("lunajson")

local AiAttackDetectionHandler = {
  PRIORITY = 1400,
  VERSION = "1.0.0-1",
}

--- Exit with an unauthorized http response
local function response_error_exit(http_status, msg)
  kong.response.set_header("Content-Type", "application/json; charset=utf-8")
  return kong.response.exit(http_status, '{"message": "' .. msg .. '"}')
end

local function check_is_attack(t)
    for k, v in pairs(t) do
      kong.log.inspect(k)
      kong.log.inspect(v)
        if v.is_attack == true then
            kong.log.inspect("is_attacl is true")
            return true  -- Return the key where the value was found
        end
    end
    return false
end

local function validatePayload(backend_url, backend_path, payload)

  local httpConnection = http.new()
  local connect_timeout = 5000
  local send_timeout = 5000
  local read_timeout = 5000
  httpConnection:set_timeouts(connect_timeout, send_timeout, read_timeout)

  local path = backend_path
  local response, err = httpConnection:request_uri(backend_url, {
    method = "POST",
    path = path,
    body = json.encode(payload),
    headers = {
      ["Content-Type"] = "application/json",
    }
  })

  if not response then
    kong.log.err("request error :", err)
    return
  end

  local _, errorHttpC = httpConnection:close()
  if errorHttpC ~= nil then
    kong.log.debug(errorHttpC)
  end

  local result = json.decode(response.body)

  if  response.status == 200 and result.result_0.is_attack and tablex.size(result) == 1 then
    return true
  elseif tablex.size(result) > 1 then
    return check_is_attack(result)
  else
    return false
  end
end

function AiAttackDetectionHandler:access(plugin_conf)

  -- your custom code here
  kong.log("phase access custom")
  kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!

  local backend_url = plugin_conf.backend_url
  local backend_path = plugin_conf.backend_path

  if kong.request.get_method() == "GET" then

    local content_length = kong.request.get_header("Content-Length")

    if content_length ~= nil then
      kong.log.err("you shall not pass! Body is not empty")
      return response_error_exit(403, "You shall not pass! This was considered an attack!")
    end

    local query_params, err = kong.request.get_query()

    kong.log.inspect(query_params)

    if query_params == nil then
      return
    end

    payload = {}

    for k, v in pairs(query_params) do
      -- kong.log.inspect(k, v)
      payload[k] = v
    end

    local responsePrediction = validatePayload(backend_url, backend_path, payload)

    kong.log.inspect("ResponsePrediction: ", responsePrediction)

    if responsePrediction == true or responsePrediction == nil then
      kong.log.err("you shall not pass")
      return response_error_exit(403, "You shall not pass! This was considered an attack!")
    end
  end

  -- TODO: check other http methodss
  if kong.request.get_method() == "POST" then

    local body, err = kong.request.get_body()

    -- TODO: check in the request contains content-type
    if body == nil then
      kong.log.err("Body is nil")
      return response_error_exit(403, "You shall not pass")
    end

    local responsePrediction = validatePayload(backend_url, backend_path, body)

    kong.log.inspect("ResponsePrediction: ", responsePrediction)

    if responsePrediction == true or responsePrediction == nil then
      kong.log.err("you shall not pass")
      return response_error_exit(403, "You shall not pass! This was considered an attack!")
    end

  end

end


return AiAttackDetectionHandler