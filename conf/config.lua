--package.path = package.path .. ";/../examples/?.lua"
--local pwd = require('pwd')

 --All paths are relative to the conf folder of the project
local config = {
    browser_webdriver_path = "../drivers",
    browser_webdriver_executable = "geckodriver",
    test_cases_path = "../examples",
}

return config