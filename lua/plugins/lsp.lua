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
          -- query-driver ska peka på ALLA möjliga kompilatorer du använder
          "--query-driver=/nix/store/*-gcc-*/bin/g++,/nix/store/*-clang-*/bin/clang++",
        },
        init_options = {
          fallbackFlags = { "-std=c++20" },
        },
      },
    },
  },
}
