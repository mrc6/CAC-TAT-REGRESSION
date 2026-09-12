local os = require("os")

local pwd = {
    abs_path = function(file_path)
      local chr = ""
        local separator = package.config:sub(1,1)
        if separator == "/" then
          -- linux
          chr = io.popen("pwd"):read()
        else
          -- windows
          chr = io.popen("cd"):read()
        end
        if file_path == nil then
          return chr
        end
        return chr .. separator .. file_path
    end
}

return pwd