local M = {}

-- Default Options
M.options = {
	keymap = "<leader>tb",
}

-- Simple function to toggle the background of a users session.
function M.toggleBackground()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
end

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})

	-- Redefines the hotkey if the user set it.
	if M.options.keymap then
		vim.keymap.set("n", M.options.keymap, M.toggleBackground, { desc = "Invert background" })
	end
end

-- For lazy users, default to running the setup command.
M.setup()

vim.api.nvim_create_user_command("Invert", function()
	M.toggleBackground()
end, {})

return M
