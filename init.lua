vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Highlight visual selection
vim.cmd "highlight Visual guibg= #616A6B guifg=NONE ctermbg=60 ctermfg=NONE"

vim.wo.linebreak = true

local cmp = require "cmp"
cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
    { name = "path" },
  },
  completion = {
    autocomplete = false,
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    cmp.setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
  end,
})

vim.g.copilot_filetypes = { ["tex"] = false }

require("grammar-guard").init()

require("lspconfig").grammar_guard.setup {
  cmd = { "/opt/homebrew/Cellar/ltex-ls/16.0.0/bin/ltex-ls" },
  settings = {
    ltex = {
      enabled = { "latex", "tex", "bib", "markdown" },
      language = "en",
      diagnosticSeverity = "information",
      setenceCacheSize = 2000,
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "en",
      },
      trace = { server = "verbose" },
      dictionary = {},
      disabledRules = {},
      hiddenFalsePositives = {},
    },
  },
}
