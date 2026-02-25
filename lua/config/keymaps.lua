-- Rättad stavning: keymap (ej kevmap)
-- Ändrat till <leader> (Space i LazyVim) istället för <localleader> (\)
vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize Molten" })
vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Run operator" })
vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Evaluate line" })
vim.keymap.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Re-evaluate cell" })
vim.keymap.set("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Evaluate visual" })
-- Kör alla Jupyter-celler (allt mellan # %%) i filen
vim.keymap.set("n", "<leader>mc", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local last_line = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, last_line, false)

  local cell_markers = {}
  table.insert(cell_markers, 0) -- Start of the file

  for i, line in ipairs(lines) do
    if line:match("^# %%%") then
      table.insert(cell_markers, i)
    end
  end
  table.insert(cell_markers, last_line + 1) -- End of the file

  for i = 1, #cell_markers - 1 do
    local start_line = cell_markers[i]
    local end_line = cell_markers[i+1] - 1

    -- Skip empty cells or cell markers themselves
    if end_line >= start_line then
      -- Molten uses 0-based lines internally for evaluate_range
      require("molten.evaluate").evaluate_range(start_line, end_line)
    end
  end
end, { silent = true, desc = "Run all Jupyter cells" })
