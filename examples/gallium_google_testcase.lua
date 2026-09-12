--loading the framework
local describe = require('lunatic')
local gallium_webdriver = require('gallium_webdriver')

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

local conn = gallium_webdriver.get_connection()

--runnint set of tests
describe('--> Test Google Search', function ()
  it('The best programming language', function ()
    local obtained_title = "Default String" --do some action that results the expected string
    local expected_title = "Lua Programming Language"

    local stat,msg = gallium_webdriver.navigate(conn, "http://google.com")
    element_id = gallium_webdriver.find_element_by_tagname(conn, "textarea")

    -- sending keys to element
    gallium_webdriver.send_keys(conn, element_id, "Lua Programming Language")
    wait(1)

    -- make the search
    element_id = gallium_webdriver.find_element_by_xpath(conn, "//input[@name='btnK']")
    gallium_webdriver.element_click(conn, element_id)
    wait(5) -- wait for the page to load
    
    obtained_title = gallium_webdriver.get_title(conn) 
    
    local failure_comment = "Expected title was "..expected_title..", but is "..obtained_title
    local is_substring = string.find(obtained_title, expected_title)

    assert(is_substring ~= nil, failure_comment)
  end, 'skip')
  it('Check Gmail Page Title', function ()
    local stat,msg = gallium_webdriver.navigate(conn, "http://google.com")
    local expected_title = "Gmail: Private and secure email at no cost | Google Workspace"
    local obtained_title = "Default String" --do some action that results the expected string

    -- clicking in the first link  
    element_id = gallium_webdriver.find_element_by_xpath(conn, "//a/parent::*")
    
    element_text = gallium_webdriver.element_get_text(conn, element_id) --should be Gmail link
    
    gallium_webdriver.element_click(conn, element_id) 
    
    obtained_title = gallium_webdriver.get_title(conn) 
    print(obtained_title)
    
    local failure_comment = "Expected name was "..expected_title..", but is "..obtained_title
    assert(obtained_name == expected_name, failure_comment)
  end)
end)

local tear_down = {
  close = function (conn)
    conn:delete()
  end
}

tear_down.close(conn)
