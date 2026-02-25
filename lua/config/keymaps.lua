-- Rättad stavning: keymap (ej kevmap)
-- Ändrat till <leader> (Space i LazyVim) istället för <localleader> (\)
vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize Molten" })
vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Evaluate line" })
vim.keymap.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Re-evaluate cell" })
vim.keymap.set("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Evaluate visual" })

vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { silent = true, desc = "molten delete cell" })
vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
vim.keymap.set("n", "<leader>ms", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "show/enter output" })

-- Kör Jupyter-cellen vid markören (stöder både # %% och Markdown-kodblock)
vim.keymap.set("n", "<leader>mc", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur_line_1_indexed = vim.api.nvim_win_get_cursor(0)[1]
  local last_buffer_line_1_indexed = vim.api.nvim_buf_line_count(bufnr)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  local cell_start_line_0_indexed = 0
  local cell_end_line_0_indexed = last_buffer_line_1_indexed - 1

  if ft == "markdown" or ft == "quarto" then
    -- Sök bakåt efter kodblockets start (t.ex. ```python)
    for i = cur_line_1_indexed - 1, 0, -1 do
      local line_content = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
      if line_content and (line_content:match("^```%a+") or line_content:match("^```{%a+}")) then
        cell_start_line_0_indexed = i + 1
        break
      end
    end
    -- Sök framåt efter kodblockets slut (```)
    for i = cur_line_1_indexed - 1, last_buffer_line_1_indexed - 1 do
      local line_content = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
      if line_content and line_content:match("^```%s*$") then
        cell_end_line_0_indexed = i - 1
        break
      end
    end
  else
    -- Standard # %% sökning
    for i = cur_line_1_indexed - 1, 0, -1 do
      local line_content = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
      if line_content and line_content:find("# %%", 1, true) then
        cell_start_line_0_indexed = i + 1
        break
      end
    end
    for i = cur_line_1_indexed - 1, last_buffer_line_1_indexed - 1 do
      local line_content = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
      if line_content and line_content:find("# %%", 1, true) then
        cell_end_line_0_indexed = i - 1
        break
      end
    end
  end

  -- Call Molten's API with 1-indexed line numbers
  vim.fn.MoltenEvaluateRange(cell_start_line_0_indexed + 1, cell_end_line_0_indexed + 1)
end, { silent = true, desc = "Run current Jupyter cell" })
