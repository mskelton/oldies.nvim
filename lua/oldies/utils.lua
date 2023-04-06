local M = {}

--- Get the list of oldfiles for the current directory including buffers from
--- the current session.
M.get_oldfiles_for_cwd = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_file = vim.api.nvim_buf_get_name(current_buf)
	local cwd = vim.fn.getcwd() .. "/"
	local res = {}

	--- @diagnostic disable-next-line: missing-parameter
	for _, buffer in ipairs(vim.split(vim.fn.execute(":buffers! t"), "\n")) do
		local match = tonumber(string.match(buffer, "%s*(%d+)"))
		local open_by_lsp = string.match(buffer, "line 0$")

		if match and not open_by_lsp then
			local file = vim.api.nvim_buf_get_name(match)

			if vim.loop.fs_stat(file) and match ~= current_buf then
				table.insert(res, file)
			end
		end
	end

	-- Add the files from the oldfiles list after adding the current buffers
	for _, file in ipairs(vim.v.oldfiles) do
		if
			not vim.tbl_contains(res, file)
			and file ~= current_file
			and vim.loop.fs_stat(file)
		then
			table.insert(res, file)
		end
	end

	-- Filter the list to only include files in the current working directory
	return vim.tbl_filter(function(file)
		return vim.startswith(file, cwd)
	end, res)
end

return M
