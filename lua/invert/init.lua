local M = {}

-- Default Options
M.options = {
	keymap = "<leader>t",
	persist = true,
}

-- Restore persisted background and colorscheme after shada is loaded
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.g.INVERT_BACKGROUND then
			vim.o.background = vim.g.INVERT_BACKGROUND
			local scheme = vim.g.INVERT_BACKGROUND == "dark"
				and vim.g.INVERT_DARK_COLORSCHEME
				or vim.g.INVERT_LIGHT_COLORSCHEME
			if scheme then
				vim.cmd("colorscheme " .. scheme)
			end
		end
	end,
})

-- Toggle the background and colorscheme of a users session.
function M.toggleBackground()
	-- Save the current colorscheme for the side we're leaving
	if M.options.persist then
		local current_scheme = vim.g.colors_name
		if vim.o.background == "dark" then
			vim.g.INVERT_DARK_COLORSCHEME = current_scheme
		else
			vim.g.INVERT_LIGHT_COLORSCHEME = current_scheme
		end
	end

	vim.o.background = vim.o.background == "dark" and "light" or "dark"

	if M.options.persist then
		vim.g.INVERT_BACKGROUND = vim.o.background
		-- Restore the colorscheme for the side we're switching to
		local target_scheme = vim.o.background == "dark"
			and vim.g.INVERT_DARK_COLORSCHEME
			or vim.g.INVERT_LIGHT_COLORSCHEME
		if target_scheme then
			vim.cmd("colorscheme " .. target_scheme)
		end
	end
end

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})

	-- Redefines the hotkey if the user set it.
	if M.options.keymap then
		vim.keymap.set("n", M.options.keymap, M.toggleBackground, { desc = "Invert background" })
	end
end

-- For lazy users, default to running the setup command.

vim.api.nvim_create_user_command("Invert", function()
	M.toggleBackground()
end, {})

return M
