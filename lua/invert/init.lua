local M = {}

-- Default Options
M.options = {
	keymap = "<leader>t",
	persist = true,
}

-- Restore persisted background after shada is loaded
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.g.INVERT_BACKGROUND then
			vim.o.background = vim.g.INVERT_BACKGROUND
		end
	end,
})

-- Simple function to toggle the background of a users session.
function M.toggleBackground()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
	if M.options.persist then
		vim.g.INVERT_BACKGROUND = vim.o.background
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
