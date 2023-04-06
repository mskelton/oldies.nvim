local M = {}

local utils = require("oldies.utils")

-- Because the list of open buffers changes as we navigate, we need to keep
-- a copy of the oldfiles list and the current index in the list.
local oldfiles = nil
local index = nil

--- Sync the oldfiles list if necessary
local function sync()
	oldfiles = oldfiles or utils.get_oldfiles_for_cwd()
	index = index or (#oldfiles + 1)
end

--- Attach an autocmd to reset the oldfiles list when leaving insert mode
M.setup = function()
	local group = vim.api.nvim_create_augroup("oldies", {})

	-- Once the user starts editing, reset the list
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "*",
		group = group,
		callback = function()
			M.reset()
		end,
	})

	vim.api.nvim_create_autocmd("TelescopePrompt", {
		pattern = "*",
		group = group,
		callback = function()
			M.reset()
		end,
	})
end

--- Reset the oldfiles list and index
M.reset = function()
	oldfiles = nil
	index = nil
end

--- Go to the next oldest file in the oldfiles list
M.prev = function()
	sync()

	if index > 1 then
		index = index - 1
		vim.cmd.e(oldfiles[index])
	end
end

--- Go to the next newest file in the oldfiles list
M.next = function()
	sync()

	if index < #oldfiles then
		index = index + 1
		vim.cmd.e(oldfiles[index])
	end
end

return M
