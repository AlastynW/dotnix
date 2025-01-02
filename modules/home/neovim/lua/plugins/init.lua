return {
	-- nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeOpen",
		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
		keys = { { "<C-e>", "<cmd>NvimTreeToggle<cr>", desc = "Open file explorer" } },
	},
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss All Notifications",
			},
		},
		opts = {
			timeout = 1500,
			render = "minimal",
			stages = "slide",
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
	},
	-- notify
	{
		"MunifTanjim/nui.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>D",
				function()
					require("notify").dismiss()
				end,
				desc = "Dismiss notification",
			},
		},
	},

	-- noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			cmdline = {
				view = "cmdline",
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
		},
	},

	-- Bdelete: delete buffer
	{
		"nvim-tree/nvim-tree.lua",
		event = "VeryLazy",
		keys = {
			{ "<leader>td", "<cmd>bdelete<cr>", desc = "Delete Current Buffer" },
		},
	},
}
