local M = {
  {
    {
      "<Leader>d",
      function()
        local builtin = require("telescope.builtin")
        local word = vim.fn.expand("<cword>")
        builtin.tags({ default_text = word })
      end,
      desc = "Search Tags",
    },
    { "<Leader>j", "<cmd>AnyJump<CR>", desc = "AnyJump" },
    { "gp", group = "+Preview symbol" },
    {
      "gpi",
      "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
      desc = "Preview Implementation",
    },
    {
      "gpd",
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      desc = "Preview Definition",
    },
    {
      "gpr",
      "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
      desc = "Preview References",
    },
    {
      "gpc",
      "<cmd>lua require('goto-preview').close_all_win()<CR>",
      desc = "Preview Close",
    },
    {
      "gpt",
      "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
      desc = "Preview Type Definition",
    },
  },
  {
    "gD",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    desc = "Goto Declaration",
  },
  {
    "gd",
    "<cmd>lua vim.lsp.buf.definition()<CR>",
    desc = "Goto Definition",
  },
  {
    "gC",
    "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>",
    desc = "Outgoing Calls",
  },
  {
    "gc",
    "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",
    desc = "Incoming Calls",
  },
  {
    "gi",
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    desc = "Goto Implementation",
  },
  {
    "gt",
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    desc = "Goto Type Definition",
  },
  {
    "gs",
    "<cmd>lua vim.lsp.buf.references()<CR>",
    desc = "Goto References",
  },
  {
    "gn",
    "<cmd>lua vim.diagnostic.goto_next()<CR>",
    desc = "Goto Next Diagnostic",
  },
  {
    "gN",
    "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    desc = "Goto Previous  Diagnostic",
  },
  { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" },
  {
    "gf",
    function()
      vim.lsp.buf.format()
    end,
    desc = "Format Buffer or Range",
    mode = { "n", "v" },
  },
  {
    "ga",
    function()
      vim.lsp.buf.code_action()
    end,
    desc = "Code Action",
  },
  {
    "<space>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    desc = "Show Diagnostic Message In Float Window",
  },
  {
    "<space>q",
    "<cmd>lua vim.diagnostic.setqflist()<CR>",
    desc = "Show Diagnostic Message In Quickfix",
  },
  {
    "<space>wa",
    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    desc = "Add Workspace Folder",
  },
  {
    "<space>wr",
    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    desc = "Remove Workspace Folder",
  },
  {
    "<space>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    desc = "Show Workspace Folders",
  },
  {
    "<space>rn",
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    desc = "Rename Symbol",
  },
  {
    "<C-j>",
    function()
      local snip = require("luasnip")
      if snip.expand_or_jumpable() then
        snip.expand_or_jump()
      end
    end,
    mode = { "i", "s" },
    desc = "Jump to Next Snippet Location",
  },
  {
    "<C-k>",
    function()
      local snip = require("luasnip")
      if snip.jumpable(-1) then
        snip.jump(-1)
      end
    end,
    mode = { "i", "s" },
    desc = "Jump to Previous Snippet Location",
  },
}

return M
