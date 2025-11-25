return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    -- Your configuration options here
  },
  -- Optional: You can set a keymap to open oil.
  keys = {
    { "<leader>pv", "<cmd>Oil<CR>",         desc = "Explorer" },
    { "<leader>pp", "<cmd>Oil --float<CR>", desc = "Explorer" },
  },
  -- Optional: Make it the default file explorer
  default_file_explorer = true,
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      float = {
        -- Padding around the floating window
        padding = 2,
        max_height = 0.4,
        max_width = 0.8,
        border = "rounded",
        win_options = {
          winblend = 10,
        },
        preview_split = "right"
      },
    })
  end
}
