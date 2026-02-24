return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "env",
          "LC_ALL=C",
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          -- query-driver ska peka på ALLA möjliga kompilatorer du använder
          "--query-driver=/usr/bin/g++,/usr/bin/clang++,/nix/store/*/bin/g++,/nix/store/*/bin/clang++",
        },
        init_options = {
          fallbackFlags = { "-std=c++20" },
        },
      },
    },
  },
}
