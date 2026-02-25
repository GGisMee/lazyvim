# LazyVim Configuration

This directory contains a **LazyVim** configuration for Neovim. It is based on the [LazyVim starter template](https://github.com/LazyVim/starter) but has been customized with specific support for **C++ on NixOS** and **Python data science** workflows.

## Project Overview

*   **Framework:** [LazyVim](https://www.lazyvim.org/)
*   **Language:** Lua
*   **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
*   **Primary Focus:** C++ (NixOS compatible), Python (Data Science/Jupyter)

## Key Configurations

### 1. C++ Development (NixOS Specific)
This configuration includes a robust setup for C++ development on NixOS, solving common issues where `clangd` fails to find standard library headers due to non-standard paths in the Nix store.

*   **File:** `lua/plugins/lsp.lua`
*   **Mechanism:**
    *   Dynamically finds the `g++` executable path using `vim.fn.exepath`.
    *   Passes the `--query-driver` flag to `clangd` to allow it to query `g++` for include paths.
    *   Sets `LC_ALL="C"` in the environment to ensure compiler output is in English (parsable by `clangd`).
    *   Configures `offsetEncoding` to "utf-16" to prevent conflicts with copilot or other plugins.
*   **Documentation:** See `CLANGD_SETUP.md` for a detailed explanation of the problem and solution.

### 2. Python & Data Science
*   **Tooling:** configured in `lua/plugins/python.lua` to ensure installation via **Mason**:
    *   **LSP:** `pyright`
    *   **Linting:** `ruff`
    *   **Formatting:** `black`
    *   **Debugging:** `debugpy`
*   **Jupyter Notebooks:** configured in `lua/plugins/jupytext.lua`.
    *   Uses `goerz/jupytext.vim` to edit `.ipynb` files as paired `.py` scripts.
    *   Format: `py:percent` (uses `# %%` as cell separators).

### 3. Core Configuration
*   **Lazy Bootstrap:** `lua/config/lazy.lua` handles the installation of `lazy.nvim` and plugin loading.
*   **Options:** `lua/config/options.lua` sets defaults like `relativenumber`, 2-space indentation, and system clipboard access (`unnamedplus`).
*   **Keymaps:** `lua/config/keymaps.lua` (currently empty/default).

## File Structure

```text
/
├── init.lua              # Entry point
├── lazy-lock.json        # Plugin lockfile (ensure reproducible builds)
├── lazyvim.json          # LazyVim specific settings
├── CLANGD_SETUP.md       # Documentation for the C++/NixOS fix
└── lua/
    ├── config/           # Core configuration
    │   ├── lazy.lua      # Plugin manager setup
    │   ├── options.lua   # Vim options
    │   ├── keymaps.lua   # Key bindings
    │   └── autocmds.lua  # Auto-commands
    └── plugins/          # Plugin specifications
        ├── lsp.lua       # LSP config (C++ fix here)
        ├── python.lua    # Python tooling (Mason)
        ├── jupytext.lua  # Notebook support
        ├── example.lua   # Example plugin file
        └── ...
```

## Usage

1.  **Prerequisites:**
    *   Neovim (>= 0.9.0 recommended)
    *   Git
    *   A C compiler (gcc/g++) for the C++ setup to work correctly.
    *   Nerd Font (optional, for icons).

2.  **Installation:**
    Back up your existing config and run:
    ```bash
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    nvim
    ```
    *Note: Since this is already a project directory, simply running `nvim` within this directory (if added to RTP) or symlinking it to `~/.config/nvim` will work.*

3.  **Plugin Management:**
    *   `:Lazy` - Open the plugin manager UI to sync, update, or clean plugins.
