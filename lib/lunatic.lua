local os = require('os')
local append_row_at_file = require('append_row_at_file')

local function describe(name, descriptor)
    local errors = {}
    local successes = {}
    local skipped = {}
  
    function it(spec_line, spec, skip)
      if not skip then
        local status = xpcall(spec, function (err)
          table.insert(errors, string.format("\t%s\n\t\t%s\n", spec_line, err))
        end)
        
        if status then
          table.insert(successes, string.format("\t%s\n", spec_line))
        end
      else
        table.insert(skipped, string.format("\t%s\n", spec_line))
      end
    end
  
    local status = xpcall(descriptor, function (err)
      table.insert(errors, err)
    end, it)
  
    print(name)
    if #errors > 0 then
      print('Failures:')
      print(table.concat(errors))
      for i=1, #errors do
        first_line = errors[i]:gsub("[^\t]*$", "")
        result = first_line:gsub("[\t\n]", "")
        append_row_at_file.file('./tests.failed', result.."\n")
      end
    end
  
    if #successes > 0 then
      print('Successes:')
      print(table.concat(successes))
      for i=1, #successes do
        first_line = successes[i]:gsub("[^\n]*$", "")
        result = first_line:gsub("[\t\n]", "")
        append_row_at_file.file('./tests.passed', result.."\n")
      end
    end

    if #skipped > 0 then
      print('Skipped:')
      print(table.concat(skipped))
      for i=1, #skipped do
        first_line = skipped[i]:gsub("[^\n]*$", "")
        result = first_line:gsub("[\t\n]", "")
        append_row_at_file.file('./tests.skiped', result.."\n")
      end
    end
  end
  
  return describe
