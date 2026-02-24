return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--query-driver=" .. (vim.fn.exepath("g++") ~= "" and vim.fn.exepath("g++") .. "," or "") .. "/usr/bin/g++,/usr/bin/gcc,/usr/bin/clang,*",
        },
        cmd_env = {
          LC_ALL = "C",
        },
        init_options = {
          fallbackFlags = { "-std=c++20" },
        },
      },
    },
  },
}
