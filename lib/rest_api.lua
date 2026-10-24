-- Load the HTTP client and JSON libraries
local http = require("ssl.https")
local json = require("dkjson")
local ltn12 = require("ltn12")
local tu = require("tableUtils")

local request = {
  post = function(endpoint,jsonBody)
	local response_body = {}
	-- Send a POST request to start a new session
	local _, status_code, headers, status_line = http.request {
		url = endpoint,
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Content-Length"] = #jsonBody
		},
		source = ltn12.source.string(jsonBody),
		sink = ltn12.sink.table(response_body)
	}
	--print(status_code,headers,status_line)
	-- Check the status code for errors
	if status_code ~= 200 then
	  return nil,"Request failed: " .. (status_line or "").." Code: "..(status_code or "")
	end

	-- Decode the response body from JSON to a Lua table
	  return json.decode(table.concat(response_body))
  end,

  get = function(endpoint,method)
	local response_body = {}
	-- Send a POST request to start a new session
	local _, status_code, headers, status_line = http.request {
		url = endpoint,
		method = method,
		sink = ltn12.sink.table(response_body)
	}

	-- Check the status code for errors
	if status_code ~= 200 then
		return nil,"Request failed: " .. (status_line or "")
	end

	-- Decode the response body from JSON to a Lua table
	return json.decode(table.concat(response_body))	
  end
}

return request