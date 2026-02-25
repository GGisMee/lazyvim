return {
  { -- Behövs för jupyter
    "3rd/image.nvim",
    build = false,
    lazy = false,
    opts = {
      backend = "kitty", -- Ändra till "ueberzug" om du inte kör Kitty/WezTerm
      processor_magick_bin = "magick", -- Tvingar Nix-binären
      integrations = {
        markdown = {
          enabled = true,
          build = false,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki", "quarto" }, -- Viktigt för Jupytext!
        },
      },
      max_width = 100,
      max_height = 12,
      window_overlap_clear_enabled = true,
    },
  },
}
