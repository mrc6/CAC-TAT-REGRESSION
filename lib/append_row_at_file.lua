local append_row_at_file = {
    file = function(file_name, string_to_write)
                openning_file = io.open(file_name, 'a')
                file_string = openning_file:write(string_to_write)
                openning_file:flush()
                openning_file:close()
                return nil
           end
}

return append_row_at_file
