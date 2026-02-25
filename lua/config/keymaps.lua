-- Rättad stavning: keymap (ej kevmap)
-- Ändrat till <leader> (Space i LazyVim) istället för <localleader> (\)
-- Keymaps related to Quarto and Slime are mostly in the plugin config,
-- but you can add general keymaps here.

-- Example: clear search highlighting
vim.keymap.set("n", "<leader>ur", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })