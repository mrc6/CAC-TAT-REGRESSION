local driver = {
    get_connection = function()
        -- This example opens the Edge (or Firefox) browser by creating a new session and then goes to google.com
        -- After that it gets the PDF print for the page. The PDF data is written to the file test.pdf

        PORT = 4444	-- This is the port where the webdriver server is listening. This should be changed if it is listening at another port. When the webdriver executable is run then it shows the port number

        wd = require("luawebdriver")
        conn = wd.new(PORT,"firefox")
        return conn
    end,
    navigate = function(conn, destination)
        local stat,msg = conn:gotoURL({ body = { url = destination} })
        return stat,msg
    end,
    element_clear = function(conn, element_id)
        conn:elementClear({ body = { elementId = element_id } })
    end,
    element_click = function(conn, element_id)
        conn:elementClick({ body = { elementId = element_id } })
    end,
    element_get_text = function(conn, element_id)
        return conn:getElementText({ elementId = element_id}).value
    
    end,
    execute_script = function(conn, script)
        return conn:executeScript({ body = { script = script } }).value
    end,
    find_element_by_tagname = function(conn, name)
        local element = conn:findElement({ body = { using = "tag name", value = name } }).value
        element_properties = {}
        for chave, valor in pairs(element) do
          table.insert(element_properties,valor)
        end
        element_id = element_properties[1]
        return element_id 
    end,
    find_element_by_class_name = function(conn, name)
        local element = conn:findElement({ body = { using = "css selector", value = "." .. name } }).value
        element_properties = {}
        for chave, valor in pairs(element) do
          table.insert(element_properties,valor)
        end
        element_id = element_properties[1]
        return element_id 
    end,
    find_element_by_id = function(conn, name)
        local element = conn:findElement({ body = { using = "css selector", value = "#" .. name } }).value
        element_properties = {}
        for chave, valor in pairs(element) do
          table.insert(element_properties,valor)
        end
        element_id = element_properties[1]
        return element_id 
    end,
    find_element_by_xpath = function(conn, xpath)
        local element = conn:findElement({ body = { using = "xpath", value = xpath } }).value
        element_properties = {}
        for chave, valor in pairs(element) do
          table.insert(element_properties,valor)
        end
        element_id = element_properties[1]
        return element_id
    end,
    find_elements_by_xpath = function(conn, xpath)
        local elements = conn:findElements({ body = { using = "xpath", value = xpath } }).value
        elements_properties = {}
        elements_id = {}
        for chave, valor in pairs(elements) do
          table.insert(elements_properties,valor)
        end
        for chave, tabela in pairs(elements_properties) do
            for chave, valor in pairs(tabela) do
                table.insert(elements_id,valor)
            end
        end
        return elements_id
    end,
    is_element_enabled = function(conn, element_id)
        return conn:isElementEnabled( { elementId = element_id } ).value
    end,
    is_element_displayed = function(conn, element_id)
        return conn:isElementDisplayed( { elementId = element_id } ).value
    end,
    get_element_text = function(conn, element_id)
        return conn:getElementText( { elementId = element_id } ).value
    end,
    get_element_attribute = function(conn, element_id, attribute_name)
        return conn:getElementAttribute( { elementId = element_id, name = attribute_name } ).value
    end,
    get_element_property = function(conn, element_id, property_name)
        return conn:getElementProperty( { elementId = element_id, name = property_name } ).value
    end,
    get_title = function(conn)
        return conn:getTitle().value
    end,
    send_keys = function(conn, element_id, keys_to_send)
        return conn:elementSendKeys({ body = { elementId = element_id, text = keys_to_send } })
    end,
    delete_session = function(conn)
        return conn:delete()
    end,
    get_status = function()
        local wd = require("luawebdriver")
        local meta = getmetatable(wd)
        return wd:status()
    end,
    get_timeouts = function(conn)
        return conn:getTimeouts().value
    end,
    set_timeouts = function(conn, timeouts)
        return conn:setTimeouts({ body = timeouts })
    end,
    get_url = function(conn)
        return conn:getURL().value
    end,
    go_back = function(conn)
        return conn:goBack()
    end,
    go_forward = function(conn)
        return conn:goForward()
    end,
    refresh = function(conn)
        return conn:refresh()
    end,
    get_window_handle = function(conn)
        return conn:getWindowHnd().value
    end,
    close_window = function(conn)
        return conn:closeWindow()
    end,
    switch_to_window = function(conn, handle)
        return conn:switchToWindow({ body = { handle = handle } })
    end,
    get_window_handles = function(conn)
        return conn:getWindowHnds().value
    end,
    new_window = function(conn, type_window)
        return conn:newWindow({ body = { type = type_window or "tab" } }).value
    end,
    switch_to_frame = function(conn, frame_id)
        return conn:switchToFrame({ body = { id = frame_id } })
    end,
    switch_to_parent_frame = function(conn)
        return conn:switchToParentFrame({ body = {} })
    end,
    get_window_rect = function(conn)
        return conn:getWindowRect().value
    end,
    set_window_rect = function(conn, rect)
        return conn:setWindowRect({ body = rect })
    end,
    maximize_window = function(conn)
        return conn:maximizeWindow({ body = {} }).value
    end,
    minimize_window = function(conn)
        return conn:minimizeWindow({ body = {} }).value
    end,
    fullscreen_window = function(conn)
        return conn:fullScreenWindow({ body = {} }).value
    end,
    get_active_element = function(conn)
        local element = conn:getActiveElement().value
        element_properties = {}
        for chave, valor in pairs(element) do
            table.insert(element_properties, valor)
        end
        return element_properties[1]
    end,
    get_element_shadow_root = function(conn, element_id)
        local shadow = conn:getElementShadowRoot({ elementId = element_id }).value
        shadow_properties = {}
        for chave, valor in pairs(shadow) do
            table.insert(shadow_properties, valor)
        end
        return shadow_properties[1]
    end,
    find_element_from_element = function(conn, element_id, using, value)
        local element = conn:findElementFromElement({ elementId = element_id, body = { using = using, value = value } }).value
        element_properties = {}
        for chave, valor in pairs(element) do
            table.insert(element_properties, valor)
        end
        return element_properties[1]
    end,
    find_elements_from_element = function(conn, element_id, using, value)
        local elements = conn:findElementsFromElement({ elementId = element_id, body = { using = using, value = value } }).value
        elements_properties = {}
        elements_id = {}
        for chave, valor in pairs(elements) do
            table.insert(elements_properties, valor)
        end
        for chave, tabela in pairs(elements_properties) do
            for chave, valor in pairs(tabela) do
                table.insert(elements_id, valor)
            end
        end
        return elements_id
    end,
    is_element_selected = function(conn, element_id)
        return conn:isElementSelected({ elementId = element_id }).value
    end,
    get_element_css_value = function(conn, element_id, property_name)
        return conn:getElementCSSValue({ elementId = element_id, propertyName = property_name }).value
    end,
    get_element_tag_name = function(conn, element_id)
        return conn:getElementTagName({ elementId = element_id }).value
    end,
    get_element_rect = function(conn, element_id)
        return conn:getElementRect({ elementId = element_id }).value
    end,
    get_computed_role = function(conn, element_id)
        return conn:getComputedRole({ elementId = element_id }).value
    end,
    get_computed_label = function(conn, element_id)
        return conn:getComputedLabel({ elementId = element_id }).value
    end,
    get_page_source = function(conn)
        return conn:getPageSource().value
    end,
    execute_async_script = function(conn, script, args)
        local body = { script = script }
        if args then
            body.args = args
        end
        return conn:executeAsyncScript({ body = body }).value
    end,
    get_all_cookies = function(conn)
        return conn:getAllCookies().value
    end,
    get_named_cookie = function(conn, name)
        return conn:getNamedCookie({ name = name }).value
    end,
    add_cookie = function(conn, cookie)
        return conn:addCookie({ body = { cookie = cookie } })
    end,
    delete_cookie = function(conn, name)
        return conn:deleteCookie({ name = name })
    end,
    delete_all_cookies = function(conn)
        return conn:deleteAllCookies()
    end,
    perform_actions = function(conn, actions)
        return conn:performActions({ body = { actions = actions } })
    end,
    release_actions = function(conn)
        return conn:releaseActions()
    end,
    dismiss_alert = function(conn)
        return conn:dismissAlert({ body = {} })
    end,
    accept_alert = function(conn)
        return conn:acceptAlert({ body = {} })
    end,
    get_alert_text = function(conn)
        return conn:getAlertText().value
    end,
    send_alert_text = function(conn, text)
        return conn:sendAlertText({ body = { text = text } })
    end,
    take_screenshot = function(conn)
        return conn:takeScreenshot().value
    end,
    take_element_screenshot = function(conn, element_id)
        return conn:takeElementScreenshot({ elementId = element_id }).value
    end,
    print_page = function(conn, print_options)
        return conn:printPage({ body = print_options or {} }).value
    end
}
return driver
