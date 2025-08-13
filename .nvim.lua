local setup_luals = function()
	vim.lsp.start({
		name = "luals",
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
		settings = {
			Lua = {
				telemetry = { enable = false },
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				format = {
					enable = true,
					defaultConfig = {
						indent_style = "spaces",
						ident_size = "2",
					},
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library",
					},
				},
			},
		},
	})
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = setup_luals,
	desc = "Start Lua language server",
})
