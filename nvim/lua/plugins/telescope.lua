
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    -- Setup telescope with extensions if needed
    telescope.setup({
      extensions = {
        file_browser = {
          hijack_netrw = true,
        },
      },
    })

    -- Load the file_browser extension
    telescope.load_extension("file_browser")

    -- Keybindings
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live Grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
    vim.keymap.set("n", "<leader>fe", telescope.extensions.file_browser.file_browser, { desc = "Telescope: File Browser" })
  end,
}
