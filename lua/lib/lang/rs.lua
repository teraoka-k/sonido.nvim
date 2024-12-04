local common = require('lib.lang.common')
local util = require('lib.util')

return {
    { 'rs' },
    util.merge_table(common, {
        class = { "struct (.+)", "impl (.+)", "trait (.+)" },
        fn = { "fn ", "|.*| {" },
        type = { ': ([a-zA-Z0-9_<>&*]+)[,%) ]', '-> ([a-zA-Z0-9_<>&*]+)' },
    })
}
