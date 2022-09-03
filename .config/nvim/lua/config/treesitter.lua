require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "c", "javascript", "python", "cpp", "yaml" },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
}
