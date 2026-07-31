return {
	"laytan/cloak.nvim",
	name = "cloak",
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			
			highlight_group = "Comment",
			patterns = {
				{
					-- Match any file starting with ".env".
					-- This can be a table to match multiple file patterns
					file_pattern = {
						".env*",
						"wrangler.toml",
						".dev.vars",
					},
					-- Match an equals sign and any character after is.
					-- This can also be a table of patterns to cloak,
					-- example: cloak_pattern = { ":.*", "-.+" } for yaml files.
					cloak_pattern = "=.+"
				},
			},
		})
	end
}
