local common = require('lib.lang.common')
local util = require('lib.util')

return util.merge_table(common, {
    class = { 'local (.-) = ' },
    fn = { 'function%(', 'function ' },
    flow = util.merge_arrays({ common.flow, { 'do$', 'repeat$' } }),
    ret = { 'return$', 'return (.-)$', 'end$' },
})
