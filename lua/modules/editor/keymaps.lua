vim.api.nvim_add_user_command("TerminalToggle", function()
    if packer_plugins
        and packer_plugins["vim-terminal-help"]
        and not packer_plugins["vim-terminal-help"].loaded then
        vim.cmd[[PackerLoad vim-terminal-help]]
        vim.fn.TerminalToggle()
    end
    end, {})

function enhance_jk_move(key)
    local map
    if packer_plugins and packer_plugins["accelerated-jk"]
        and packer_plugins["accelerated-jk"].loaded then
        map = key == "j" and "<Plug>(accelerated_jk_gj)" or
        "<Plug>(accelerated_jk_gk)"
        return t(map)
    else
        map = key == "j" and "gj" or "gk"
    end
    print(t(map))
    return t(map)
end

function enhance_ft_move(key)
    if packer_plugins and packer_plugins["vim-eft"]
        and packer_plugins["vim-eft"].loaded then
        local map = {
            f = "<Plug>(eft-f)",
            F = "<Plug>(eft-F)",
            t = "<Plug>(eft-t)",
            T = "<Plug>(eft-T)",
            [";"] = "<Plug>(eft-repeat)"
        }
        return map[key]
    else
        return key
    end
end

local M = {
    --["j"] = {function() return enhance_jk_move("j") end, {expr = true, mode = {"n"}, noremap = false}},
    --["k"] = {function() return enhance_jk_move("k") end, {expr = true, mode = {"n"}, noremap = false}},
    --["f"] = {function() return enhance_ft_move("f") end, {expr = true, mode = {"n"}, noremap = false}},
    --["t"] = {function() return enhance_ft_move("t") end, {expr = true, mode = {"n"}, noremap = false}},
    --["F"] = {function() return enhance_ft_move("F") end, {expr = true, mode = {"n"}, noremap = false}},
    --["T"] = {function() return enhance_ft_move("T") end, {expr = true, mode = {"n"}, noremap = false}},
    --[";"] = {function() return enhance_ft_move(";") end, {expr = true, mode = {"n"}, noremap = false}},
    --["gc"] = {"<Plug>(characterize)", "Reveal Representation Of Character"},

    -- " They will slow down <C-I> because <Tab> equals to <C-I>
    [t"<Tab>"] = {
        ["name"] = "+AsyncTask",
        ["5"] = {":AsyncTask file-build<CR>", "Compile File"},
        ["6"] = {":AsyncTask file-run<CR>", "Run File"},
        ["7"] = {":AsyncTask project-configure<CR>", "Configure CMake Project"},
        ["8"] = {":AsyncTask project-build<CR>", "Build CMake Project"},
        ["9"] = {":AsyncTask project-run<CR>", "Run CMake Project"},
        ["0"] = {":AsyncTask project-clean<CR>", "Clean CMake Binary Directory"},
    },
    ["<Leader>f"] = {
        ["name"] = "+Fuzzy Find",
        ["f"] = {"<Cmd>Telescope find_files<CR>", "Find Files"},
        ["g"] = {"<Cmd>Telescope live_grep<CR>", "Live Grep"},
        ["b"] = {"<Cmd>Telescope buffers<CR>", "Find Buffers"},
        ["h"] = {"<Cmd>Telescope help_tags<CR>", "Find Help"},
        ["d"] = {"<Cmd>Telescope tags<CR>", "Find Tags(definition)"},
        ["m"] = {"<Cmd>Telescope man_pages<CR>", "Find Man Pagess"},
        ["a"] = {"<Cmd>lua require('telescope').extensions.asynctasks.all()<CR>", "Find AsyncTask"},
        ["t"] = {"<Cmd>TodoTelescope<CR>", "Find Todo Comments"},
    },
    -- Terminal
    ["<M-=>"] = {"<Cmd>TerminalToggle<CR>", "Toggle Terminal"},
    ["<M-q>"] = {t"<C-\\><C-n>", "Switch To Normal Mode", mode="t"},
}

return M
