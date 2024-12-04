local common = require('lib.lang.common')
local util = require('lib.util')

return {
    { 'lua' },
    util.merge_table(common, {
        fn = { 'function%(', 'function ' },
    })
}
