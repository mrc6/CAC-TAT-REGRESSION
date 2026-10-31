--loading the framework
local describe = require('lunatic')
local rest_api = require('rest_api')

-- Getting the config file
local config = require('config')

--loading the pwd module to get the absolute path of the file
local pwd = require('pwd')

-- Using os.time() for seconds
os = require("os")
function wait(seconds)
  local start_time = os.time()
    repeat until os.time() > start_time + seconds
end

--runnint set of tests
describe('--> Test Rest API Calls', function ()
  it('Make a get http request', function()
    local local_url = 'https://httpbin.org/get'
    local msg = rest_api.get(local_url)
    local expected_value = "httpbin.org"

    if msg == nil then
      print("Error: response is nil")
    else
      local received_value = msg.headers.Host
      local failure_comment = "Expected response header Host to be "..tostring(expected_value)..", but is "..tostring(received_value)
      assert(received_value == expected_value, failure_comment)
    end
  end)
  it('Make a auth post http request', function()
    local local_url = 'https://demo.dotcms.com/api/v1/authentication/api-token'
    local body = [[{
                     "user": "admin@dotcms.com",
                     "password": "admin",
                     "expirationDays": 10
                  }]]
    local msg = rest_api.post(local_url, body)

    if msg == nil then
      print("Error: response is nil")
    else
      local received_value = msg.entity.token
      local failure_comment = "Expected token to be received, but is nil"
      assert(received_value ~= nil, failure_comment)
    end
  end)
  it('Make a delete http request', function()
    local local_url = 'https://httpbin.org/delay/1'
    local body = '{}'
    local msg = rest_api.delete(local_url, body)

    if msg == nil then
      print("Error: response is nil")
    else
      local received_value = msg.method
      local expected_value = "DELETE"
      local failure_comment = "Expected method to be "..tostring(expected_value)..", but is "..tostring(received_value)
      assert(received_value == expected_value, failure_comment)
    end
  end)
  it('Make a put http request', function()
    local local_url = 'https://httpbin.org/delay/1'
    local body = '{}'
    local msg = rest_api.put(local_url, body)

    if msg == nil then
      print("Error: response is nil")
    else
      local received_value = msg.method
      local expected_value = "PUT"
      local failure_comment = "Expected method to be "..tostring(expected_value)..", but is "..tostring(received_value)
      assert(received_value == expected_value, failure_comment)
    end
  end)
end)