require("neo-tree").setup({
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
      }
    },
    filesystem = {
      bind_to_cwd = false
    }
})
