local M = {}

local utils = require("oldies.utils")

-- Because the list of open buffers changes as we navigate, we need to keep
-- a copy of the oldfiles list and the current index in the list.
local oldfiles = nil
local index = nil

-- When we switch to a new buffer, we don't want to reset the oldfiles list
local ignore_next = false

--- Sync the oldfiles list if necessary
local function sync()
	oldfiles = oldfiles or utils.get_oldfiles_for_cwd()
	index = index or (#oldfiles + 1)
end

--- Attach an autocmd to reset the oldfiles list when leaving insert mode
M.setup = function()
	local group = vim.api.nvim_create_augroup("oldies", {})

	-- Once the user switches to another buffer, reset the list
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		group = group,
		callback = function()
			if ignore_next then
				ignore_next = false
			else
				M.reset()
			end
		end,
	})
end

--- Edit a file, but don't reset the oldfiles list
--- @param file string
local function edit(file)
	ignore_next = true
	vim.cmd.e(file)
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
		edit(oldfiles[index])
	end
end

--- Go to the next newest file in the oldfiles list
M.next = function()
	sync()

	if index < #oldfiles then
		index = index + 1
		edit(oldfiles[index])
	end
end

return M
