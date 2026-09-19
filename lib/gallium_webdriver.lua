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
    end
}
return driver
