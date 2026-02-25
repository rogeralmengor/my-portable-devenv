return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    require("nvim-treesitter.install").prefer_git = false
    require("nvim-treesitter.install").compilers = { "zig", "gcc" }

    configs.setup({
      ensure_installed = { "python", "xml", "lua", "markdown", "bash", "luadoc", "luap" },
      sync_install = false,
      auto_install = false,  -- disable auto to avoid cascade errors
      highlight = {
        enable = true,
        disable = function(lang, buf)  -- graceful fallback if parser missing
          local ok, _ = pcall(vim.treesitter.start, buf, lang)
          return not ok
        end,
      },
      indent = { enable = true },
    })
  end
}
