local config = {}

function config.avante()
  require("avante").setup({
    provider = "claude-code",
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
    },
    render = {
      markview = {
        enable = true,
      },
      diff = {
        virtual_text = true,
        show_signs = true,
        inline_diff = true, -- Show inline diff like Cursor
        extmark_opts = {
          priority = 100,
        },
      },
    },
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
      },
    },
    hints = { 
      enabled = true,
      word_hints = true, -- Enable word-level hints
    },
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      sidebar_header = {
        enabled = true,
        align = "center",
        rounded = true,
      },
      input = {
        prefix = "> ",
        height = 8,
      },
      edit = {
        border = "rounded",
        start_insert = true,
      },
      ask = {
        floating = false,
        start_insert = true,
        border = "rounded",
        focus_on_apply = "ours",
      },
    },
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    diff = {
      autojump = true,
      list_opener = "copen",
      override_timeoutlen = 500,
      debug = false,
      auto_apply_diff_after_generation = false,
      auto_apply_suggestions = false,
    },
    -- ACP provider configuration for claude-code CLI
    -- Requires: npm install -g @zed-industries/claude-code-acp
    -- This adapter wraps your native 'claude' command with ACP protocol
    acp_providers = {
      ["claude-code"] = {
        command = "claude-code-acp",
        args = {},
        env = {
          NODE_NO_WARNINGS = "1",
          ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
          ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
          ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
          ACP_PERMISSION_MODE = "bypassPermissions",
        },
      },
    },
  })
end

function config.sidekick()
  require("sidekick").setup()
end

return config
