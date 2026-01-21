-- ================================================================================
-- ==================================== PLUGINS ===================================
-- ================================================================================

require("mini.notify").setup({})
vim.notify = require("mini.notify").make_notify()
require("mini.pick").setup({})
require("mini.icons").setup({})
require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<CR>"] = { "select_and_accept", "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
	},

	completion = {
		list = {
			selection = {
				auto_insert = true,
			},
		},

		documentation = {
			auto_show = true,
		},

		ghost_text = {
			enabled = false,
		},

		menu = {
			auto_show = function(ctx)
				return ctx.mode ~= "cmdline"
			end,
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return kind_icon
						end,
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	signature = {
		enabled = true,
	},

	fuzzy = {
		prebuilt_binaries = {
			download = false,
		},
	},
})

-- ================================================================================
-- ================================ BASIC SETTINGS ================================
-- ================================================================================

-- theme & transparency
vim.cmd.colorscheme("retrobox")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 2
vim.opt.exrc = true

-- identation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- visual settings
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 2
vim.opt.winborder = "none"

-- file handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fs.joinpath(vim.fn.stdpath("data"), "./undodir/")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

-- behaviour settings
vim.opt.backspace = "indent,eol,start"
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.clipboard:append("unnamedplus")

vim.opt.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 999

vim.opt.splitbelow = false
vim.opt.splitright = true

-- keybinds
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- clear search
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- center jumps
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- buffer nav
vim.keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>p", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>d", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })

-- window nav
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- window manip
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- better indentation, select again
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- file nav
vim.keymap.set("n", "-", "<cmd>Explore<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<CR>", { desc = "Find file" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- ================================================================================
-- ================================== STATUSLINE ==================================
-- ================================================================================

local function git_branch()
	if not _G.current_branch then
		local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		_G.current_branch = branch
	end
	if _G.current_branch ~= "" then
		return "│ " .. _G.current_branch
	end
	return ""
end

local function file_type()
	local ft = vim.bo.filetype

	if ft == "" then
		return ""
	end

	return "│ " .. ft
end

local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients > 0 then
		return "│ " .. clients[1].config.name
	else
		return ""
	end
end

local function word_count()
	local words = vim.fn.wordcount().words
	return "│ " .. words .. " words"
end

local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end

	local format = ""
	if size < 1024 then
		format = size .. "B "
	elseif size < 1024 * 1024 then
		format = string.format("%.1fK", size / 1024)
	else
		format = string.format("%.1fM", size / 1024 / 1024)
	end
	return "│ " .. format
end

local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = "NORMAL",
		i = "INSERT",
		v = "VISUAL",
		V = "V-LINE",
		["\22"] = "V-BLOCK", -- Ctrl-V
		c = "COMMAND",
		s = "SELECT",
		S = "S-LINE",
		["\19"] = "S-BLOCK", -- Ctrl-S
		R = "REPLACE",
		r = "REPLACE",
		["!"] = "SHELL",
		t = "TERMINAL",
	}
	return modes[mode] or ("  " .. mode:upper())
end

vim.cmd([[highlight StatusLineBold gui=bold cterm=bold]])

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size
_G.lsp_status = lsp_status
_G.word_count = word_count

local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				"  ",
				"%#StatusLineBold#",
				"%{v:lua.mode_icon()}",
				"%#StatusLine#",
				" │ %f %h%m%r",
				" %{v:lua.git_branch()}",
				" %{v:lua.file_type()}",
				" %{v:lua.lsp_status()}",
				" %{v:lua.file_size()}",
				" %{v:lua.word_count()}",
				"%=", -- Right-align everything after this
				"%l:%c  %P ", -- Line:Column and Percentage
			})
		end,
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = "  %f %h%m%r │ %{v:lua.file_type()} | %=  %l:%c   %P "
		end,
	})
end

setup_dynamic_statusline()

-- ================================================================================
-- ====================================== LSP =====================================
-- ================================================================================

-- diagnostics
vim.diagnostic.config({
	signs = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_lines = {
		current_line = true,
	},
})

-- lsp keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }

		-- Navigation
		vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gs", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

		-- Information
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, opts)

		-- Code actions
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		-- Diagnostics
		vim.keymap.set("n", "<leader>nd", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)
		vim.keymap.set("n", "<leader>pd", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)
		vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

		-- Formatting
		vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format)
	end,
})

vim.cmd("set completeopt+=noselect")

vim.api.nvim_create_user_command("LspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		print("No LSP clients attached to current buffer")
	else
		for _, client in ipairs(clients) do
			print("LSP: " .. client.name .. " (ID: " .. client.id .. ")")
		end
	end
end, { desc = "Show LSP client info" })

vim.lsp.config("*", {
	root_markers = { ".git", "flake.nix" },
})

-- ================================================================================
-- ==================================== SYNTAX ====================================
-- ================================================================================

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})
