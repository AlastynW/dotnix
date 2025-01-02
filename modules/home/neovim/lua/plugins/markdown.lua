return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = { "VeryLazy" },
		file_types = { "markdown", "vimwiki" },
		opts = {
			code = {
				sign = true,
				width = "block",
				right_pad = 1,
			},
			headings = {
				enabled = true,
				sign = true,
				position = "overlay",
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				signs = { "󰫎 " },
				width = "full",
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				border = true,
				border_virtual = false,
				border_prefix = false,
				above = "▄",
				below = "▀",
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH2Bg",
					"RenderMarkdownH3Bg",
					"RenderMarkdownH4Bg",
					"RenderMarkdownH5Bg",
					"RenderMarkdownH6Bg",
				},
				foregrounds = {
					"RenderMarkdownH1",
					"RenderMarkdownH2",
					"RenderMarkdownH3",
					"RenderMarkdownH4",
					"RenderMarkdownH5",
					"RenderMarkdownH6",
				},
			},
		},
		ft = { "markdown", "norg", "rmd", "org" },
	},
	-- Markdown Preview
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("MarkdownOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("MarkdownClose", require("peek").close, {})
		end,
	},
}
