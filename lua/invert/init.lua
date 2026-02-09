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
			local scheme
			if vim.g.INVERT_BACKGROUND == "dark" then
				scheme = vim.g.INVERT_DARK_COLORSCHEME
			else
				scheme = vim.g.INVERT_LIGHT_COLORSCHEME
			end
			if scheme then
				pcall(vim.cmd, "colorscheme " .. scheme)
			end
		end
	end,
})

-- Toggle the background and colorscheme of a users session.
function M.toggleBackground()
	local current_scheme = vim.g.colors_name
	local current_bg = vim.o.background

	-- Check if the user manually changed their colorscheme since last toggle
	local saved_scheme
	if current_bg == "dark" then
		saved_scheme = vim.g.INVERT_DARK_COLORSCHEME
	else
		saved_scheme = vim.g.INVERT_LIGHT_COLORSCHEME
	end
	local scheme_changed = saved_scheme and current_scheme ~= saved_scheme

	if M.options.persist then
		-- Save the current colorscheme for the side we're leaving
		if current_bg == "dark" then
			vim.g.INVERT_DARK_COLORSCHEME = current_scheme
		else
			vim.g.INVERT_LIGHT_COLORSCHEME = current_scheme
		end

		-- If the user manually changed their scheme, clear the opposite side
		-- so we just toggle background and let the colorscheme handle it
		if scheme_changed then
			if current_bg == "dark" then
				vim.g.INVERT_LIGHT_COLORSCHEME = nil
			else
				vim.g.INVERT_DARK_COLORSCHEME = nil
			end
		end
	end

	vim.o.background = current_bg == "dark" and "light" or "dark"

	if M.options.persist then
		vim.g.INVERT_BACKGROUND = vim.o.background
		local target_scheme
		if vim.o.background == "dark" then
			target_scheme = vim.g.INVERT_DARK_COLORSCHEME
		else
			target_scheme = vim.g.INVERT_LIGHT_COLORSCHEME
		end
		if target_scheme then
			pcall(vim.cmd, "colorscheme " .. target_scheme)
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
