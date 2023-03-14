local M = {
  ["<Tab>5"] = { ":AsyncTask file-build<CR>", "Compile File" },
  ["<Tab>6"] = { ":AsyncTask file-run<CR>", "Run File" },
  ["<Tab>7"] = {
    ":AsyncTask project-configure<CR>",
    "Configure CMake Project",
  },
  ["<Tab>8"] = { ":AsyncTask project-build<CR>", "Build CMake Project" },
  ["<Tab>9"] = { ":AsyncTask project-run<CR>", "Run CMake Project" },
  ["<Tab>0"] = {
    ":AsyncTask project-clean<CR>",
    "Clean CMake Binary Directory",
  },
  ["<Leader>f"] = {
    ["name"] = "+Fuzzy Find",
    ["f"] = {
      ":Telescope find_files <CR>",
      "Find Files",
    },
    ["g"] = {
      ":Telescope live_grep <CR>",
      "Live Grep",
    },
    ["b"] = {
      ":Telescope buffers <CR>",
      "Find Buffers",
    },
    ["h"] = {
      ":Telescope help_tags <CR>",
      "Find Help",
    },
    ["d"] = {
      ":Telescope tags <CR>",
      "Find Tags(definition)",
    },
    ["n"] = {
      ":Telescope current_buffer_tags <CR>",
      "Find Tags In Current Buffer",
    },
    ["m"] = {
      ":Telescope man_pages<CR>",
      "Find Man Pages",
    },
    ["p"] = {
      ":Telescope projects<CR>",
      "Find projects",
    },
    ["a"] = {
      ":lua require('telescope').extensions.asynctasks.all()<CR>",
      "Find AsyncTask",
    },
    ["t"] = {
      ":TodoTelescope<CR>",
      "Find Todo Comments",
    },
  },
  -- Terminal
  ["<M-=>"] = {
    function()
      vim.fn.TerminalToggle()
    end,
    "Toggle Terminal",
  },
  ["<M-q>"] = { t("<C-\\><C-n>"), "Switch To Normal Mode", mode = "t" },
  ["<Leader>n"] = {
    ["name"] = "+Neogen Annotation",
    ["f"] = {
      function()
        require("neogen").generate()
      end,
      "Function Annotation",
    },
    ["c"] = {
      function()
        require("neogen").generate({ type = "class" })
      end,
      "Class Annotation",
    },
    ["t"] = {
      function()
        require("neogen").generate({ type = "type" })
      end,
      "Type Annotation",
    },
    ["u"] = {
      function()
        require("neogen").generate({ type = "file" })
      end,
      "File Annotation",
    },
  },
  ["<C-S>"] = {
    "<Cmd>w<CR>",
    "Save File",
  },
  ["dd"] = {
    function()
      if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
      else
        return "dd"
      end
    end,
    expr = true,
    "Smart dd",
  },
  ["<2-LeftMouse>"] = {
    function()
      vim.lsp.buf.definition()
    end,
    "Jump to Definition",
  },
  ["<RightMouse>"] = {
    t("<C-O>"),
    noremap = false,
    "Jump to Older Location",
  },
  ["<2-RightMouse>"] = {
    t("<C-O><C-O>"),
    noremap = false,
    "Jump to Older Location",
  },
  ["<3-RightMouse>"] = {
    t("<C-O><C-O><C-O>"),
    noremap = false,
    "Jump to Older Location",
  },
  ["<4-RightMouse>"] = {
    t("<C-O><C-O><C-O><C-O>"),
    noremap = false,
    "Jump to Older Location",
  },
  ["<M-RightMouse>"] = {
    t("<C-I>"),
    noremap = false,
    "Jump to Newer Location",
  },
  ["<M-2-RightMouse>"] = {
    t("<C-I><C-I>"),
    noremap = false,
    "Jump to Newer Location",
  },
  ["<M-3-RightMouse>"] = {
    t("<C-I><C-I><C-I>"),
    noremap = false,
    "Jump to Newer Location",
  },
  ["<M-4-RightMouse>"] = {
    t("<C-I><C-I><C-I><C-I>"),
    noremap = false,
    "Jump to Newer Location",
  },
}

return M
