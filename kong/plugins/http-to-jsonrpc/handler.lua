local BasePlugin = require "kong.plugins.base_plugin"

local StringUtils = require "kong.plugins.http-to-jsonrpc.string_util"

local kong = kong

local Http2JsonRPCHandler = BasePlugin:extend()

Http2JsonRPCHandler.PRIORITY = 10
Http2JsonRPCHandler.VERSION = "1.0.0"

function Http2JsonRPCHandler:new()
  Http2JsonRPCHandler.super.new(self, "http-to-jsonrpc")
end

function Http2JsonRPCHandler:access(config)
  Http2JsonRPCHandler.super.access(self)
  
  local requestMethod = kong.request.get_method()
  if 'POST' == requestMethod and config.to_jsonrpc then
    -- 获取jsonrpc的method, 为路径的最后一段
    local path = kong.request.get_path()
    local pathFields = StringUtils.split(path, '/')
    local method = pathFields[#pathFields]
    table.remove(pathFields)
    local newPath = table.concat(pathFields, '/')
    -- 设置新的路径
    kong.service.request.set_path('/'..newPath)

    -- 获取请求的body
    local body, err = kong.request.get_body('application/json')
    if err then 
      kong.log.err("Convert http to jsonrpc error, can not get request body, ", err)
      return kong.response.exit(500, { message = "Request's body must be JSON." })
    end
    -- 设置新的body
    local rpcBody = { ["method"]=method, ["id"]=0, ["jsonrpc"]="2.0", ["params"]=body }
    local ok, err = kong.service.request.set_body(rpcBody)
    if err then 
      kong.log.err("Set new rpc body err, ", rpcBody)
      return kong.response.exit(500, { message = "Set request's body err, "..err })
    end

  end
end

return Http2JsonRPCHandler
