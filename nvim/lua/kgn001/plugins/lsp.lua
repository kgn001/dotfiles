return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			vim.lsp.enable({ "cssls", "ts_ls", "rust_analyzer" })
			vim.diagnostic.config({ virtual_text = true })
		end
	},
}
