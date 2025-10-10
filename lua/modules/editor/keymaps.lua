local M = {
  {
    { "<Tab>5", ":AsyncTask file-build<CR>", desc = "Compile File" },
    { "<Tab>6", ":AsyncTask file-run<CR>", desc = "Run File" },
    {
      "<Tab>7",
      ":AsyncTask project-configure<CR>",
      desc = "Configure CMake Project",
    },
    {
      "<Tab>8",
      ":AsyncTask project-build<CR>",
      desc = "Build CMake Project",
    },
    { "<Tab>9", ":AsyncTask project-run<CR>", desc = "Run CMake Project" },
    {
      "<Tab>0",
      ":AsyncTask project-clean<CR>",
      desc = "Clean CMake Binary Directory",
    },
  },
  {
    { "<leader>f", group = "Fuzzy Fund" },
    { "<leader>fj", ":Telescope jumplist<CR>", desc = "Find Jumplist" },
    { "<leader>ff", ":Telescope find_files <CR>", desc = "Find Files" },
    { "<leader>fg", ":Telescope live_grep <CR>", desc = "Live Grep" },
    { "<leader>fb", ":Telescope buffers <CR>", desc = "Find Buffers" },
    { "<leader>fh", ":Telescope help_tags <CR>", desc = "Find Help" },
    { "<leader>fd", ":Telescope tags <CR>", desc = "Find Tags(definition)" },
    {
      "<leader>fn",
      ":Telescope current_buffer_tags <CR>",
      desc = "Find Tags In Current Buffer",
    },
    {
      "<leader>fm",
      [[:lua require("telescope.builtin").man_pages({sections={"ALL"}})<CR>]],
      desc = "Find Man Pages",
    },
    { "<leader>fp", ":Telescope projects<CR>", desc = "Find projects" },
    {
      "<leader>fa",
      ":lua require('telescope').extensions.asynctasks.all()<CR>",
      desc = "Find AsyncTask",
    },
    { "<leader>ft", ":TodoTelescope<CR>", desc = "Find Todo Comments" },
  },
  -- Terminal
  {
    {
      "<M-=>",
      function()
        vim.fn.TerminalToggle()
      end,
      desc = "Toggle Terminal",
    },
    { "<M-q>", t("<C-\\><C-n>"), desc = "Switch To Normal Mode", mode = "t" },
  },
  {
    { "<Leader>n", group = "Annotation" },
    {
      "<Leader>nf",
      function()
        require("neogen").generate()
      end,
      desc = "Function Annotation",
    },
    {
      "<Leader>nc",
      function()
        require("neogen").generate({ type = "class" })
      end,
      desc = "Class Annotation",
    },
    {
      "<Leader>nt",
      function()
        require("neogen").generate({ type = "type" })
      end,
      desc = "Type Annotation",
    },
    {
      "<Leader>nu",
      function()
        require("neogen").generate({ type = "file" })
      end,
      desc = "File Annotation",
    },
  },
  { "<C-S>", "<Cmd>w<CR>", desc = "Save File" },
  { "<C-/>", "<Plug>NERDCommenterToggle", desc = "Toggle Comment" },
  {
    {
      "<2-LeftMouse>",
      function()
        vim.lsp.buf.definition()
      end,
      desc = "Jump to Definition",
    },
    {
      "<RightMouse>",
      t("<C-O>"),
      noremap = false,
      desc = "Jump to Older Location",
    },
    {
      "<2-RightMouse>",
      t("<C-O><C-O>"),
      noremap = false,
      desc = "Jump to Older Location",
    },
    {
      "<3-RightMouse>",
      t("<C-O><C-O><C-O>"),
      noremap = false,
      desc = "Jump to Older Location",
    },
    {
      "<4-RightMouse>",
      t("<C-O><C-O><C-O><C-O>"),
      noremap = false,
      desc = "Jump to Older Location",
    },
    {
      "<M-RightMouse>",
      t("<C-I>"),
      noremap = false,
      desc = "Jump to Newer Location",
    },
    {
      "<M-2-RightMouse>",
      t("<C-I><C-I>"),
      noremap = false,
      desc = "Jump to Newer Location",
    },
    {
      "<M-3-RightMouse>",
      t("<C-I><C-I><C-I>"),
      noremap = false,
      desc = "Jump to Newer Location",
    },
    {
      "<M-4-RightMouse>",
      t("<C-I><C-I><C-I><C-I>"),
      noremap = false,
      desc = "Jump to Newer Location",
    },
  },
}

return M
