local getpos = vim.fn.getpos
local function is_esc(key)
    return key == 27
end

return {
    col = vim.fn.col,
    getline = vim.fn.getline,
    getpos,
    line = vim.fn.line,
    setcursorcharpos = vim.fn.setcursorcharpos,
    search = vim.fn.search,
    extension = function()
        return vim.fn.expand('%'):match("^.+%.(.+)$")
    end,
    get_chars = function(char_len)
        if char_len < 1 then
            return ''
        else
            local chars = ""
            for i = 1, char_len do
                local key = vim.fn.getchar()
                if is_esc(key) then
                    return ''
                end
                chars = chars .. vim.fn.nr2char(key)
            end
            return chars
        end
    end,
    get_line_column = function()
        local pos = getpos('.')
        return pos[2], pos[3]
    end,
}
