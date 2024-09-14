return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to always pull the latest changes
    opts = {
        -- add any opts here
    },
    build = "make",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    config = function()
        -- Load Avante library
        require("avante_lib").load()

        -- Configure Avante
        require("avante").setup({
            -- Your config here
            provider = "claude", -- Recommended to use Claude
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-3-5-sonnet-20240620",
                temperature = 0,
                max_tokens = 4096,
            },
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
            windows = {
                position = "right",
                wrap = true,
                width = 30,
                sidebar_header = {
                    align = "center",
                    rounded = true,
                },
            },
        })
    end,
}