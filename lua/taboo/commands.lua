local popup = require("plenary.popup")

local setup = require("taboo.setup")
local api = require('taboo.api')

local M = {
	buffers = {
		left = -1,
		right = -1,
	}
}

M.open_preview = function()
	local left_bufnr = vim.api.nvim_create_buf(false, false)
	local right_bufnr = vim.api.nvim_create_buf(false, false)

	local lwidth = setup.config.windows.left.width
	local rwidth = setup.config.windows.right.width
	local height = setup.config.windows.height

	local total_width = lwidth + rwidth
	local borders = 2
	local left_col = math.floor((vim.o.columns / 2) - (total_width / 2))
	local top_row = math.floor(((vim.o.lines - height) / 2) - 1)

	popup.create(left_bufnr, {
		border = {},
		title = false,
		highlight = "PickersHighlight",
		borderhighlight = "PickersBorder",
		enter = true,
		line = top_row,
		col = left_col,
		minwidth = lwidth,
		minheight = height,
		borderchars = setup.config.borderchars,
	}, false)
	popup.create(right_bufnr, {
		border = {},
		title = "~ Taboo ~",
		highlight = "PreviewHighlight",
		borderhighlight = "PreviewBorder",
		enter = false,
		line = top_row,
		col = left_col + lwidth + borders,
		minwidth = rwidth,
		minheight = height,
		borderchars = setup.config.borderchars,
	}, false)

	M.buffers.left = left_bufnr
	M.buffers.right = right_bufnr

	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = M.buffers.left,
		callback = function()
			api.reload(M.buffers.left, M.buffers.right)
		end,
	})

	-- set mappings
	for mode in pairs(setup.mappings) do
		for key_bind in pairs(setup.mappings[mode]) do
			local cb = setup.mappings[mode][key_bind]
			vim.api.nvim_buf_set_keymap(left_bufnr, mode, key_bind, cb, { silent = true })
		end
	end

	api.enrich_preview(M.buffers)
end

-- close the preview
M.close = function()
	api.close(M.buffers)
end

-- select a tab by id
M.select = function()
	print("not implemented")
end

-- remove a tab by id
M.remove = function()
	print("not implemented")
end

-- reload the preview after a movement
M.reload = function()
	print("not implemented")
end

return M
