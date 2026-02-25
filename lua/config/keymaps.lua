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

local function run_cells(run_all, run_above)
  local bufnr = vim.api.nvim_get_current_buf()
  local last_line = vim.api.nvim_buf_line_count(bufnr)
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  if ft == "markdown" or ft == "quarto" then
    local block_start = nil
    for i = 0, last_line - 1 do
      local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
      
      -- Om vi ser början på ett kodblock
      if not block_start and (line:match("^```%a+") or line:match("^```{%a+}")) then
        block_start = i + 1 -- Spara raden efter ```
      -- Om vi ser slutet på ett kodblock och vi är inuti ett
      elseif block_start and line:match("^```%s*$") then
        local block_end = i - 1 -- Spara raden före ```

        if block_start <= block_end then
          -- Kolla om vi ska köra detta blocket
          local should_run = run_all
          if run_above and block_end < cur_line then
             should_run = true
          end
          
          if should_run then
            vim.fn.MoltenEvaluateRange(block_start + 1, block_end + 1)
          end
        end
        block_start = nil -- Nollställ för nästa block
      end
    end
  else
    -- Standard python fil med # %%
    local cell_start = 0
    for i = 0, last_line - 1 do
      local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
      if line:find("# %%", 1, true) then
        if i > cell_start then
          local cell_end = i - 1
          local should_run = run_all
          if run_above and cell_end < cur_line then
             should_run = true
          end
          if should_run then
            vim.fn.MoltenEvaluateRange(cell_start + 1, cell_end + 1)
          end
        end
        cell_start = i + 1
      end
    end
    -- Sista cellen
    if last_line > cell_start then
      local should_run = run_all
      if run_above and last_line < cur_line then -- Kommer normalt sett aldrig gälla om man inte står efter filens slut
         should_run = true
      end
      if should_run then
        vim.fn.MoltenEvaluateRange(cell_start + 1, last_line)
      end
    end
  end
end

-- Kör alla Jupyter-celler ovanför markören
vim.keymap.set("n", "<leader>ma", function()
  run_cells(false, true)
end, { silent = true, desc = "Run all cells above" })

-- Kör alla Jupyter-celler i filen
vim.keymap.set("n", "<leader>mA", function()
  run_cells(true, false)
end, { silent = true, desc = "Run all cells" })
