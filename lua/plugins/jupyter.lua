return {
  -- Kör kod i celler
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 12
    end,
  },
  -- Konverterar .ipynb till Markdown för editering
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
  },
}
