return {
  -- Gör att .ipynb-filer öppnas som läsbar Quarto/Markdown
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },
  -- Ger dig LSP-funktioner inuti kodblocken
  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
