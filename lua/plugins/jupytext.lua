return {
  "GCBallesteros/jupytext.nvim",
  opts = {
    custom_cmdevent = "BufWritePost",
    extension = "qmd", -- Öppna .ipynb som Quarto-filer
    force_ft = "quarto",
  },
}
