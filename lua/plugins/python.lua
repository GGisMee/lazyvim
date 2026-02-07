-- Grejer vi använder i python
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "black",
        "debugpy",
      })
    end,
  },
}
