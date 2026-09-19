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
describe('--> Test local CAC TAT page', function ()
  it('Check CAC TAT page title', function ()
    local obtained_title = "Default String" --do some action that results the expected string
    local expected_title = "Central de Atendimento ao Cliente TAT"

    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)

    obtained_title = gallium_webdriver.get_title(conn) 
    --print(obtained_title)
    
    local failure_comment = "Expected title was "..expected_title..", but is "..obtained_title
    local is_substring = string.find(obtained_title, expected_title)

    assert(is_substring ~= nil, failure_comment)
  end)
  it('Fill required fields and submit form', function()
      
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Filling the required fields
    local first_name = "João"
    local last_name = "da Silva"
    local email = "joao.silva@example.com"
    local text_area = "Arrume-me uma vaga QA remoto ganhando em Dólares"
    local expected_success_message = "Mensagem enviada com sucesso."
        
    local element_id = gallium_webdriver.find_element_by_id(conn, "firstName")
    gallium_webdriver.send_keys(conn, element_id, first_name)

    element_id = gallium_webdriver.find_element_by_id(conn, "lastName")
    gallium_webdriver.send_keys(conn, element_id, last_name)

    element_id = gallium_webdriver.find_element_by_id(conn, "email")
    gallium_webdriver.send_keys(conn, element_id, email)

    element_id = gallium_webdriver.find_element_by_id(conn, "open-text-area")
    gallium_webdriver.send_keys(conn, element_id, text_area)

    -- Submitting the form
    element_id = gallium_webdriver.find_element_by_xpath(conn, "//button[@type='submit']")
    gallium_webdriver.element_click(conn, element_id)
    
    element_id = gallium_webdriver.find_element_by_class_name(conn, "success")
    
    local failure_comment = "Expected that element was displayed, but not "
    assert(gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)
    
    local received_success_message = gallium_webdriver.get_element_text(conn, element_id)
    local failure_comment = "Expected success message was "..expected_success_message..", but is "..received_success_message
    assert(received_success_message == expected_success_message, failure_comment)
    
    wait(5)
    local failure_comment = "Expected that element was not displayed, but it was "
    assert(not gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)
  end)
  it('Display error message when submitting form with invalid email format', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Filling the required fields
    local first_name = "João"
    local last_name = "da Silva"
    local email = "joao.silva#example.com"
    local text_area = "Arrume-me uma vaga QA remoto ganhando em Dólares"
    local expected_success_message = "Mensagem enviada com sucesso."
        
    local element_id = gallium_webdriver.find_element_by_id(conn, "firstName")
    gallium_webdriver.send_keys(conn, element_id, first_name)

    element_id = gallium_webdriver.find_element_by_id(conn, "lastName")
    gallium_webdriver.send_keys(conn, element_id, last_name)

    element_id = gallium_webdriver.find_element_by_id(conn, "email")
    gallium_webdriver.send_keys(conn, element_id, email)

    element_id = gallium_webdriver.find_element_by_id(conn, "open-text-area")
    gallium_webdriver.send_keys(conn, element_id, text_area)

    -- Submitting the form
    element_id = gallium_webdriver.find_element_by_xpath(conn, "//button[@type='submit']")
    gallium_webdriver.element_click(conn, element_id)

    -- Checking for error message
    element_id = gallium_webdriver.find_element_by_class_name(conn, "error")

    local failure_comment = "Expected that element was displayed, but not "
    assert(gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)

    local received_error_message = gallium_webdriver.get_element_text(conn, element_id)
    local expected_error_message = "Valide os campos obrigatórios!"
    local failure_comment = "Expected error message was "..expected_error_message..", but is "..received_error_message
    assert(received_error_message == expected_error_message, failure_comment)
    
    wait(5)
    local failure_comment = "Expected that element was not displayed, but it was "
    assert(not gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)
  end)
  it('Check the phone field only accepts numbers', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Filling the phone field with letters
    local phone_input = "abcdefghij"
    local element_id = gallium_webdriver.find_element_by_id(conn, "phone")
    gallium_webdriver.send_keys(conn, element_id, phone_input)

    -- Checking if the phone field is empty
    local received_phone_value = gallium_webdriver.get_element_property(conn, element_id, "value")
    local expected_phone_value = ""
    local failure_comment = "Expected phone value was "..expected_phone_value..", but is "..received_phone_value
    assert(received_phone_value == expected_phone_value, failure_comment)
  end)
  it('Check error message when phone is required but not filled', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Filling the required fields
    local first_name = "João"
    local last_name = "da Silva"
    local email = "joao.silva@example.com"
    local text_area = "Arrume-me uma vaga QA remoto ganhando em Dólares"
    local expected_success_message = "Mensagem enviada com sucesso."
        
    local element_id = gallium_webdriver.find_element_by_id(conn, "firstName")
    gallium_webdriver.send_keys(conn, element_id, first_name)

    element_id = gallium_webdriver.find_element_by_id(conn, "lastName")
    gallium_webdriver.send_keys(conn, element_id, last_name)

    element_id = gallium_webdriver.find_element_by_id(conn, "email")
    gallium_webdriver.send_keys(conn, element_id, email)

    element_id = gallium_webdriver.find_element_by_id(conn, "open-text-area")
    gallium_webdriver.send_keys(conn, element_id, text_area)

    -- Checking the phone checkbox to make it required
    element_id = gallium_webdriver.find_element_by_id(conn, "phone-checkbox")
    gallium_webdriver.element_click(conn, element_id)

    -- Submitting the form
    element_id = gallium_webdriver.find_element_by_xpath(conn, "//button[@type='submit']")
    gallium_webdriver.element_click(conn, element_id)

    -- Checking for error message
    element_id = gallium_webdriver.find_element_by_class_name(conn, "error")

    local failure_comment = "Expected that element was displayed, but not "
    assert(gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)

    local received_error_message = gallium_webdriver.get_element_text(conn, element_id)
    local expected_error_message = "Valide os campos obrigatórios!"
    local failure_comment = "Expected error message was "..expected_error_message..", but is "..received_error_message
    assert(received_error_message == expected_error_message, failure_comment)
    
    wait(5)
    local failure_comment = "Expected that element was not displayed, but it was "
    assert(not gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)
  end)
  it('Verify if the field was cleanned', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Filling the required fields
    local first_name = "João"
    local last_name = "da Silva"
    local email = "joao.silva@example.com"
    local text_area = "Arrume-me uma vaga QA remoto ganhando em Dólares"
    local expected_success_message = "Mensagem enviada com sucesso."
        
    local element_id = gallium_webdriver.find_element_by_id(conn, "firstName")
    gallium_webdriver.send_keys(conn, element_id, first_name)
    gallium_webdriver.element_clear(conn, element_id)
    local received_first_name_value = gallium_webdriver.get_element_property(conn, element_id, "value")
    local expected_first_name_value = ""
    local failure_comment = "Expected first name value was cleared "..expected_first_name_value..", but is "..received_first_name_value
    assert(received_first_name_value == expected_first_name_value, failure_comment)

    element_id = gallium_webdriver.find_element_by_id(conn, "lastName")
    gallium_webdriver.send_keys(conn, element_id, last_name)
    gallium_webdriver.element_clear(conn, element_id)
    local received_last_name_value = gallium_webdriver.get_element_property(conn, element_id, "value")
    local expected_last_name_value = ""
    local failure_comment = "Expected last name value was cleared "..expected_last_name_value..", but is "..received_last_name_value
    assert(received_last_name_value == expected_last_name_value, failure_comment)
    
    element_id = gallium_webdriver.find_element_by_id(conn, "email")
    gallium_webdriver.send_keys(conn, element_id, email)
    gallium_webdriver.element_clear(conn, element_id)
    local received_email_value = gallium_webdriver.get_element_property(conn, element_id, "value")
    local expected_email_value = ""
    local failure_comment = "Expected email value was cleared "..expected_email_value..", but is "..received_email_value
    assert(received_email_value == expected_email_value, failure_comment)
    
    element_id = gallium_webdriver.find_element_by_id(conn, "open-text-area")
    gallium_webdriver.send_keys(conn, element_id, text_area)
    gallium_webdriver.element_clear(conn, element_id)
    local received_text_area_value = gallium_webdriver.get_element_property(conn, element_id, "value")
    local expected_text_area_value = ""
    local failure_comment = "Expected text area value was cleared "..expected_text_area_value..", but is "..received_text_area_value
    assert(received_text_area_value == expected_text_area_value, failure_comment)
  end)
  it('Display error message when submitting form without filling required fields', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Submitting the form without filling required fields
    element_id = gallium_webdriver.find_element_by_xpath(conn, "//button[@type='submit']")
    gallium_webdriver.element_click(conn, element_id)

    -- Checking for error message
    element_id = gallium_webdriver.find_element_by_class_name(conn, "error")

    local failure_comment = "Expected that element was displayed, but not "
    assert(gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)

    local received_error_message = gallium_webdriver.get_element_text(conn, element_id)
    local expected_error_message = "Valide os campos obrigatórios!"
    local failure_comment = "Expected error message was "..expected_error_message..", but is "..received_error_message
    assert(received_error_message == expected_error_message, failure_comment)
  end)
  it('Select Youtube product by text', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Selecting Youtube product by text
    element_id = gallium_webdriver.find_element_by_id(conn, "product")
    gallium_webdriver.element_click(conn, element_id)

    element_id = gallium_webdriver.find_element_by_xpath(conn, "//option[text()='YouTube']")
    gallium_webdriver.element_click(conn, element_id)

    -- Checking if the Youtube option is selected
    local received_selected_value = gallium_webdriver.get_element_property(conn, element_id, "selected")
    local expected_selected_value = true
    local failure_comment = "Expected Youtube option to be selected "..tostring(expected_selected_value)..", but is "..tostring(received_selected_value)
    assert(received_selected_value == expected_selected_value, failure_comment)

    local expected_element_text = "YouTube"
    local element_text = gallium_webdriver.get_element_text(conn, element_id)
    local failure_comment = "Expected element text was "..expected_element_text..", but is "..element_text
    assert(element_text == expected_element_text, failure_comment)
  end)
  it('Select Mentoria product by value', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Selecting Mentoria product by text
    element_id = gallium_webdriver.find_element_by_id(conn, "product")
    gallium_webdriver.element_click(conn, element_id)

    element_id = gallium_webdriver.find_element_by_xpath(conn, "//option[@value='mentoria']")
    gallium_webdriver.element_click(conn, element_id)

    -- Checking if the Mentoria option is selected
    local received_selected_value = gallium_webdriver.get_element_property(conn, element_id, "selected")
    local expected_selected_value = true
    local failure_comment = "Expected Mentoria option to be selected "..tostring(expected_selected_value)..", but is "..tostring(received_selected_value)
    assert(received_selected_value == expected_selected_value, failure_comment)

    local expected_element_text = "Mentoria"
    local element_text = gallium_webdriver.get_element_text(conn, element_id)
    local failure_comment = "Expected element text was "..expected_element_text..", but is "..element_text
    assert(element_text == expected_element_text, failure_comment)
  end)
  it('Select Blog product by index', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Selecting Mentoria product by text
    element_id = gallium_webdriver.find_element_by_id(conn, "product")
    gallium_webdriver.element_click(conn, element_id)

    element_id = gallium_webdriver.find_element_by_xpath(conn, "//option[2]")
    gallium_webdriver.element_click(conn, element_id)

    -- Checking if the Blog option is selected
    local received_selected_value = gallium_webdriver.get_element_property(conn, element_id, "selected")
    local expected_selected_value = true
    local failure_comment = "Expected Blog option to be selected "..tostring(expected_selected_value)..", but is "..tostring(received_selected_value)
    assert(received_selected_value == expected_selected_value, failure_comment)

    local expected_element_text = "Blog"
    local element_text = gallium_webdriver.get_element_text(conn, element_id)
    local failure_comment = "Expected element text was "..expected_element_text..", but is "..element_text
    assert(element_text == expected_element_text, failure_comment)
  end)
  it('Check all service types', function()
    local local_url = pwd.abs_path(config.test_cases_path .. "/src/index.html")
    local stat,msg = gallium_webdriver.navigate(conn, "file://" .. local_url)
    
    -- Selecting Services
    elements_id = gallium_webdriver.find_elements_by_xpath(conn, "//*[@type='radio']")
    for i, element_id in ipairs(elements_id) do
      gallium_webdriver.element_click(conn, element_id)
      local received_selected_value = gallium_webdriver.get_element_property(conn, element_id, "checked")
      local expected_selected_value = true
      local failure_comment = "Expected radio button "..i.." to be selected "..tostring(expected_selected_value)..", but is "..tostring(received_selected_value)
      assert(received_selected_value == expected_selected_value, failure_comment)
    end
  end)
end)

local tear_down = {
  close = function (conn)
    conn:delete()
  end
}

tear_down.close(conn)
