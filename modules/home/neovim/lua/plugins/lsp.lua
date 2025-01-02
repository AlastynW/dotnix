local border = "rounded"

local function attach(bufnr)
	vim.diagnostic.config({
		float = { border = border },
	})
end

return {

	"neovim/nvim-lspconfig",
	dependencies = "folke/neodev.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function(_, opts)
		require("lspconfig.ui.windows").default_options.border = border

		local servers = opts.servers
		local function on_attach(client, bufnr)
			attach(bufnr)
		end

		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
		}
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities(),
			opts.capabilities or {}
		)

		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.servers) do
			lspconfig[server].setup(vim.tbl_deep_extend("force", {
				on_attach = on_attach,
				capabilities = capabilities,
				handlers = handlers,
			}, config))
		end
	end,

	keys = {
		-- diagnostics
		{
			"<C-k>",
			vim.diagnostic.goto_prev,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<C-j>",
			vim.diagnostic.goto_next,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<C-Up>",
			vim.diagnostic.goto_prev,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<C-Down>",
			vim.diagnostic.goto_next,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<C-,>",
			vim.diagnostic.open_float,
			mode = "n",
			{ noremap = true, silent = true },
		},
		-- goto
		{
			"gD",
			vim.lsp.buf.declaration,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gd",
			vim.lsp.buf.definition,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gi",
			vim.lsp.buf.implementation,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gt",
			vim.lsp.buf.type_definition,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gr",
			vim.lsp.buf.references,
			mode = "n",
			{ noremap = true, silent = true },
		},
		-- goto in new split
		{
			"gsD",
			"<cmd>split | lua vim.lsp.buf.declaration()<cmd>",
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gsd",
			"<cmd>split | lua vim.lsp.buf.definition()<cr>",
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gvD",
			"<cmd>vsplit | lua vim.lsp.buf.declaration()<cmd>",
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"gvd",
			"<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
			mode = "n",
			{ noremap = true, silent = true },
		},
		-- get information
		{
			"K",
			vim.lsp.buf.hover,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<a-k>",
			vim.lsp.buf.signature_help,
			mode = "n",
			{ noremap = true, silent = true },
		},
		-- actions
		{
			"<a-CR>",
			vim.lsp.buf.code_action,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<a-r>",
			vim.lsp.buf.rename,
			mode = "n",
			{ noremap = true, silent = true },
		},
		{
			"<space><space>",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			mode = "n",
			{ noremap = true, silent = true },
		},
	},

	opts = {
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
		servers = {
			asm_lsp = {},
			gopls = {},
			lua_ls = {
				settings = {
					Lua = {
						format = {
							enable = true,
						},
					},
				},
			},
			rust_analyzer = {},
			ansiblels = {},
			arduino_language_server = {},
			bitbake_ls = {},
			bashls = {},
			cobol_ls = {},
			dockerls = {},
			cmake = {},
			terraformls = {},
			clangd = {
				settings = {
					["clangd"] = {
						formatting = {
							command = { "clang-format --style=file" },
						},
					},
				},
			},
			pyright = {
				settings = {
					["pyright"] = {
						formatting = {
							command = { "black -l 120" },
						},
					},
				},
			},
		},
	},
}
