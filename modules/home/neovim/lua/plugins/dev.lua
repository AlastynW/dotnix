return {
	-- TODOs
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost" },
		config = function(_, opts)
			require("todo-comments").setup(opts)
		end,
		keys = {
			{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find Todo's" },
		},
	},

	-- TODOs
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>gtr", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Find Diagnostics" },
			{ "<leader>gtd", "<cmd>TodoQuickFix<cr>", desc = "Find Todo's" },
		},
	},

	-- Neogit
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = true,
		keys = {
			{
				"<leader>gc",
				function()
					require("neogit").open({ kind = "split" })
				end,
				desc = "Neogit",
			},
		},
	},

	-- Diffview
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
}
