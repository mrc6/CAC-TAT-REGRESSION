package.path = package.path .. ";../conf/?.lua"
package.path = package.path .. ";../lib/?.lua"
local config = require('config')
local os = require('os')

-- Function to start the WebDriver server
local function start_webdriver_server()
    local webdriver_path = config.browser_webdriver_path
    local webdriver_executable = config.browser_webdriver_executable
    local command = webdriver_path .. "/" .. webdriver_executable .. " &"
    print("Starting WebDriver server with command: " .. command)
    os.execute(command)
    -- Wait for a few seconds to ensure the server starts
    os.execute("sleep 5")
end

local function stop_webdriver_server()
    local command = "pkill -f " .. config.browser_webdriver_executable
    print("Stopping WebDriver server with command: " .. command)
    os.execute(command)
end

local function list_files_in_directory(directory)
    -- Choose "dir /b" for Windows or "ls" for Linux/Mac
    local command = "ls ".. directory 
    local i, t, popen = 0, {}, io.popen
    local files_table = {}

    local pfile = popen(command)
    for filename in pfile:lines() do
        --print(filename)
        table.insert(files_table, filename)
    end
    pfile:close()
    return files_table
end

local function run_test_cases()
    local test_cases_path = config.test_cases_path
    local files = list_files_in_directory(test_cases_path)

    -- Open a file to write the output
    local file = io.open("output.txt", "w")
    -- Backup standard print
    local orig_print = print
    -- Redefine print to write to file
    print = function(...)
        local t = {}
        for i = 1, select("#", ...) do
            t[i] = tostring(select(i, ...))
        end
        file:write(table.concat(t, "\t") .. "\n")
    end

    for _, file in ipairs(files) do
        if file:match("^gallium_.+%.lua$") then
            local test_case_path = test_cases_path .. "/" .. file
            print("Running test case: " .. test_case_path)
            local test_case = dofile(test_case_path)
        end
    end
    file:close()
    print = orig_print
end

local function show_results()
    local file = io.open("output.txt", "r")
    if not file then
        print("No output file found.")
        return
    end

    print("\n===========================Test Results:===========================")
    for line in file:lines() do
        print(line)
    end
    file:close()
end

-- Main execution
start_webdriver_server()
run_test_cases()
stop_webdriver_server()
show_results()
