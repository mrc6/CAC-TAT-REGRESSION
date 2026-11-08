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
local function privacy_page_url()
  local local_path = pwd.abs_path(config.test_cases_path .. "/src/privacy.html")
  return "file://" .. local_path
end
local function index_page_url()
  local local_path = pwd.abs_path(config.test_cases_path .. "/src/index.html")
  return "file://" .. local_path
end
--runnint set of tests
describe('--> Test local CAC TAT Privacy Policy page', function ()
  it('Check Privacy Policy page title', function ()
    local expected_title = "Central de Atendimento ao Cliente TAT - Política de Privacidade"
    local stat,msg = gallium_webdriver.navigate(conn, privacy_page_url())
    local obtained_title = gallium_webdriver.get_title(conn)
    local failure_comment = "Expected title was "..expected_title..", but is "..tostring(obtained_title)
    assert(obtained_title == expected_title, failure_comment)
  end)
  it('Check Privacy Policy page heading', function()
    local expected_heading = "CAC TAT - Política de Privacidade"
    local stat,msg = gallium_webdriver.navigate(conn, privacy_page_url())
    local element_id = gallium_webdriver.find_element_by_id(conn, "title")
    local failure_comment = "Expected that heading element was displayed, but not "
    assert(gallium_webdriver.is_element_displayed(conn, element_id), failure_comment)
    local received_heading = gallium_webdriver.get_element_text(conn, element_id)
    failure_comment = "Expected heading was "..expected_heading..", but is "..tostring(received_heading)
    assert(received_heading == expected_heading, failure_comment)
  end)
  it('Check Privacy Policy page content', function()
    local expected_paragraphs = {
      "Não salvamos dados submetidos no formulário da aplicação CAC TAT.",
      "Utilzamos as tecnologias HTML, CSS e JavaScript, para simular uma aplicação real.",
      "No entanto, a aplicação é um exemplo, sem qualquer persistência de dados, e usada para fins de ensino.",
      "Talking About Testing"
    }
    local stat,msg = gallium_webdriver.navigate(conn, privacy_page_url())
    local elements_id = gallium_webdriver.find_elements_by_xpath(conn, "//div[@id='white-background']/p")
    local failure_comment = "Expected "..#expected_paragraphs.." paragraphs, but found "..#elements_id
    assert(#elements_id == #expected_paragraphs, failure_comment)
    for i, expected_text in ipairs(expected_paragraphs) do
      local received_text = gallium_webdriver.get_element_text(conn, elements_id[i])
      failure_comment = "Expected paragraph "..i.." to be "..expected_text..", but is "..tostring(received_text)
      assert(received_text == expected_text, failure_comment)
    end
  end)
  it('Check Privacy Policy page opens from the CAC TAT page link', function()
    local expected_title = "Central de Atendimento ao Cliente TAT - Política de Privacidade"
    local stat,msg = gallium_webdriver.navigate(conn, index_page_url())
    local original_handle = gallium_webdriver.get_window_handle(conn)
    -- The link has target="_blank", so the privacy policy opens in a new window/tab
    local element_id = gallium_webdriver.find_element_by_xpath(conn, "//a[@href='privacy.html']")
    gallium_webdriver.element_click(conn, element_id)
    local new_handle = nil
    for _, handle in ipairs(gallium_webdriver.get_window_handles(conn)) do
      if handle ~= original_handle then
        new_handle = handle
      end
    end
    assert(new_handle ~= nil, "Expected a new window to open for the Privacy Policy, but none did")
    gallium_webdriver.switch_to_window(conn, new_handle)
    local obtained_url = gallium_webdriver.get_url(conn)
    local failure_comment = "Expected URL to end with privacy.html, but is "..tostring(obtained_url)
    assert(string.find(obtained_url, "privacy.html$") ~= nil, failure_comment)
    local obtained_title = gallium_webdriver.get_title(conn)
    failure_comment = "Expected title was "..expected_title..", but is "..tostring(obtained_title)
    assert(obtained_title == expected_title, failure_comment)
    -- Closing the new window and returning to the CAC TAT page
    gallium_webdriver.close_window(conn)
    gallium_webdriver.switch_to_window(conn, original_handle)
  end)
end)
local tear_down = {
  close = function (conn)
    conn:delete()
  end
}
tear_down.close(conn)