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
    get_visible_first_line = function() return getpos('w0')[2] end,
    get_visible_last_line = function() return getpos('w$')[2] end,
}
