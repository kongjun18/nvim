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
    {
      "<M-i>",
      function()
        local insert_file_path = function()
          local ok, builtin = pcall(require, "telescope.builtin")
          if not ok then
            return
          end
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          -- Capture the target buffer/window and the originating mode now; the picker
          -- steals focus and always returns us to normal mode.
          local win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_get_current_buf()
          local was_insert = vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          local saved_pos = vim.api.nvim_win_get_cursor(win)

          -- startinsert must come before set_cursor: nvim_win_set_cursor clamps the
          -- column to len-1 in normal mode, so setting col+1 before entering insert
          -- mode lands the cursor at the correct position.
          local function restore_cursor(row, col)
            if was_insert then
              vim.cmd("startinsert")
              vim.api.nvim_win_set_cursor(win, { row, col + 1 })
            end
          end

          builtin.find_files({
            attach_mappings = function(prompt_bufnr)
              local selected = false
              actions.close:enhance({
                post = function()
                  if was_insert and not selected then
                    vim.schedule(function()
                      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_set_current_win(win)
                        restore_cursor(saved_pos[1], saved_pos[2])
                      end
                    end)
                  end
                end,
              })
              actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if not entry then
                  return
                end
                local path = entry.value or entry.path
                if not path or path == "" then
                  return
                end
                selected = true
                -- Defer until after Telescope tears down; closing the picker forces
                -- normal mode and would clobber a synchronous startinsert.
                vim.schedule(function()
                  if not (vim.api.nvim_win_is_valid(win) and vim.api.nvim_buf_is_valid(buf)) then
                    return
                  end
                  vim.api.nvim_set_current_win(win)
                  vim.api.nvim_put({ path }, "c", true, true)
                  local pos = vim.api.nvim_win_get_cursor(win)
                  restore_cursor(pos[1], pos[2])
                end)
              end)
              return true
            end,
          })
        end
        insert_file_path();
      end,
      desc = "Insert File Path After Cursor",
      mode = "i",
    },
  },
  -- Terminal
  {
    {
      "<M-=>",
      function()
        -- Lazy-load vim-terminal-help on first use to avoid E117.
        local ok = pcall(vim.fn.TerminalToggle)
        if not ok then
          require("lazy").load({ plugins = { "vim-terminal-help" } })
          vim.fn.TerminalToggle()
        end
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
