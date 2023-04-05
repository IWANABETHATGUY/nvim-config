local util = require 'lspconfig.util'

return {
  default_config = {
    root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
    single_file_support = false,
  },
  single_file_support = false,
}
