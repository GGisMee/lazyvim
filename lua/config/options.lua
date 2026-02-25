-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"

-- Hittar dynamiskt sökvägen till python3 i din aktuella Nix-profil
local python_path = vim.fn.exepath("python3")
if python_path ~= "" then
  vim.g.python3_host_prog = python_path
end
