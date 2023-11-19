local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")




ls.add_snippets("javascript", {
	s("__dirname", {
		t("const __dirname = fileURLToPath(new URL('.', import.meta.url));")
	}),
	s("__filename", {
		t("const __filename = url.fileURLToPath(import.meta.url);")
	}),
})

local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local postfix_builtin = require("luasnip.extras.treesitter_postfix").builtin

ls.add_snippets("javascript", {
  treesitter_postfix({
    trig = ".mv",
    matchTSNode = postfix_builtin.tsnode_matcher.find_topmost_types({
      "call_expression",
      "identifier"
    }),
  }, f(function(_, parent)
      print(parent.snippet.env.LS_TSMATCH)
      -- local node_content = table.concat(parent.snippet.env.LS_TSMATCH, '\n')
      -- local replaced_content = ("std::move(%s)"):format(node_content)
      -- return vim.split(ret_str, "\n", { trimempty = false })
    end))

})
