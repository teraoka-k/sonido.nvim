local function read_char() return vim.fn.nr2char(vim.fn.getchar()) end
local getpos = vim.fn.getpos

return {
    col = vim.fn.col,
    getline = vim.fn.getline,
    getpos,
    line = vim.fn.line,
    setcursorcharpos = vim.fn.setcursorcharpos,

    --==========methods==============
    get_chars = function(char_len)
        if char_len < 1 then
            return s.chars
        else
            local chars = ""
            for i = 1, char_len do
                local char = read_char()
                chars = chars .. char
            end
            return chars
        end
    end,
    get_visible_first_line = function() return getpos('w0')[2] end,
    get_visible_last_line = function() return getpos('w$')[2] end,
    read_char,
}
