local function endswith(str, ending)
    return str:sub(- #ending) == ending
end

return {
    symbols = function()
        local file = vim.fn.expand('%')
        if endswith(file, "rs") then
            return { "fn ", "struct ", "impl ", "trait " }
        elseif endswith(file, "lua") then
            return { "function " }
        elseif endswith(file, "md") then
            return { "# " } --, "## ", "### ", "#### " }
        end
        return { "function " }
    end
}
