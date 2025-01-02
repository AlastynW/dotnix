return {
	-- nvim-dap : Plugin principal pour le débogage
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			-- Configuration de l'adaptateur pour GDB
			dap.adapters.cpp = {
				type = "executable",
				command = "gdb", -- Assurez-vous que gdb est dans le PATH
				args = { "-q" }, -- '-q' désactive le mode verbeux de GDB
				name = "gdb",
			}

			-- Configuration pour le débogage de C et C++
			dap.configurations.cpp = {
				{
					name = "Launch program",
					type = "cpp",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}", -- Dossier de travail
					stopOnEntry = false, -- Ne s'arrête pas au début
					setupCommands = {
						{
							text = "-enable-pretty-printing", -- Active l'impression formatée dans GDB
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
					args = {}, -- Arguments à passer au programme
					runInTerminal = true, -- Exécuter dans un terminal externe
				},
			}

			-- Utiliser la même configuration pour le C
			dap.configurations.c = dap.configurations.cpp
		end,
	},

	-- nvim-dap-ui : Interface utilisateur pour nvim-dap
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
		opts = {
			icons = true,
		},
		config = function()
			local dapui = require("dapui")
			dapui.setup()

			-- Ouvrir automatiquement l'interface utilisateur au démarrage d'une session
			local dap = require("dap")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- nvim-dap-virtual-text : Affichage des informations de débogage dans le code
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}
