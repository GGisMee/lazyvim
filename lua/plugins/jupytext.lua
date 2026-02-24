return {
  "goerz/jupytext.vim",
  init = function()
    vim.g.jupytext_fmt = "py:percent" -- Använd # %% som cell-separatorer
  end,
}
