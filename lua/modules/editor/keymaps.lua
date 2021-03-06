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
      vim.cmd([[silent! PackerLoad vim-terminal-help]])
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
}

vim.keymap.set({ "i", "s" }, t("<C-j>"), function()
  local snip = require("luasnip")
  if snip.expand_or_jumpable() then
    snip.expand_or_jump()
  end
end)
vim.keymap.set({ "i", "s" }, t("<C-k>"), function()
  local snip = require("luasnip")
  if snip.jumpable(-1) then
    snip.jump(-1)
  end
end)
vim.keymap.set("n", t("<C-I>"), t("<C-I>"))
vim.keymap.set({ "n", "i" }, t("<C-S>"), "<Cmd>w<CR>")
return M
