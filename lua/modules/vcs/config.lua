local config = {}

function config.neogit()
    require("core.packer"):setup("neogit", {
        integrations = {
            diffview = true
        },
    })
end

return config
