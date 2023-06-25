local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  formatting.clang_format,
  lint.cpplint
}

null_ls.setup({
   debug = true,
   sources = sources,
   on_init = function(new_client, _)
      new_client.offset_encoding = 'utf-8'
   end,
})
