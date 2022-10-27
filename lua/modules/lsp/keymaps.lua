local M = {
  ["gp"] = {
    ["name"] = "+Preview symbol",
    ["i"] = {
      "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
      "Preview Implementation",
    },
    ["d"] = {
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      "Preview Definition",
    },
    ["r"] = {
      "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
      "Preview References",
    },
    ["c"] = {
      "<cmd>lua require('goto-preview').close_all_win()<CR>",
      "Preview Close",
    },
    ["t"] = {
      "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
      "Preview Type Definition",
    },
  },
  ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
  ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
  ["gC"] = {
    function()
      local ft = vim.api.nvim_buf_get_option(0, "filetype")
      if ft == "c" or ft == "cpp" then
        ccls_call(true)
      else
        vim.lsp.buf.outgoing_calls()
      end
    end,
    "Outgoing Calls",
  },
  ["gc"] = {
    function()
      local ft = vim.api.nvim_buf_get_option(0, "filetype")
      if ft == "c" or ft == "cpp" then
        ccls_call(false)
      else
        vim.lsp.buf.incoming_calls()
      end
    end,
    "Incoming Calls",
  },
  ["gi"] = {
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    "Goto Implementation",
  },
  ["gt"] = {
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    "Goto Type Definition",
  },
  ["gs"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto References" },
  ["gn"] = {
    "<cmd>lua vim.diagnostic.goto_next()<CR>",
    "Goto Next Diagnostic",
  },
  ["gN"] = {
    "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    "Goto Previous  Diagnostic",
  },
  ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
  ["gf"] = {
    function()
      vim.lsp.buf.format()
    end,
    "Format Buffer or Range",
    mode = { "n", "v" },
  },
  ["ga"] = {
    function()
      vim.lsp.buf.code_action()
    end,
    "Code Action",
  },
  ["<space>e"] = {
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    "Show Diagnostic Message In Float Window",
  },
  ["<space>q"] = {
    "<cmd>lua vim.diagnostic.setqflist()<CR>",
    "Show Diagnostic Message In Location List",
  },
  ["<space>wa"] = {
    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    "Add Workspace Folder",
  },
  ["<space>wr"] = {
    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    "Remove Workspace Folder",
  },
  ["<space>wl"] = {
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    "Show Workspace Folders",
  },
  ["<space>rn"] = {
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    "Rename Symbol",
  },
}

return M
