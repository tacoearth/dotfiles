local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  
  {
    'stevearc/aerial.nvim',
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
  },

  "neovim/nvim-lspconfig",
  
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
}, {
  rocks = { enabled = false },
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
      aerial = true,
      native_lsp = {
          enabled = true,
          underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
          },
      },
  },
  color_overrides = {
    mocha = {
      base = "#111111",
      mantle = "#111111",
      crust = "#111111",
      text = "#ffffff",
      blue = "#bfbfff",
      sapphire = "#bfbfff",
      sky = "#bfbfff",
    },
  },
})
vim.cmd.colorscheme "catppuccin"

vim.api.nvim_set_hl(0, "LineNr", { fg = "#bfbfff" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#bfbfff", bold = true })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#bfbfff", bg = "#111111" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#111111" })
vim.api.nvim_set_hl(0, "MsgArea", { bg = "#404040" })

local custom_theme = require('lualine.themes.catppuccin')

for _, mode in pairs(custom_theme) do
    if mode.c then
        mode.c.bg = '#222222'
    end
end

require('lualine').setup {
  options = {
    theme = custom_theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'filetype'}, 
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
} 

vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<leader>n", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle Relative Numbers" })

local border_style = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border_style
  opts.max_width = 40
  opts.wrap = true
  local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
  if winnr then
    vim.api.nvim_win_set_option(winnr, 'wrap', true)
  end
  return bufnr, winnr
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = border_style, focusable = false, silent = true }
)

vim.api.nvim_set_hl(0, "AerialLineNr", { fg = "#404040", italic = true })
vim.api.nvim_set_hl(0, "AerialBg", { bg = "#181818" })

require("aerial").setup({
    backends = { "lsp", "treesitter", "markdown", "man" },
    
    layout = {
        default_direction = "prefer_left",
        max_width = { 40, 0.2 },
        min_width = 10,
        resize_to_content = true,
        win_opts = {
            winhighlight = "Normal:AerialBg,SignColumn:AerialBg,EndOfBuffer:AerialBg",
        },
    },

    icons = {
        Class          = "󰠱 ",
        Constructor    = " ",
        Constant       = "󰏿 ",
        Enum           = " ",
        Function       = "󰊕 ",
        Interface      = " ",
        Method         = "󰆧 ",
        Module         = " ",
        Struct         = "󰆼 ",
        Variable       = "󰀫 ",
    },
    
    filter_kind = {
        "Class", "Constructor", "Enum", "Function", "Interface", "Module",
        "Method", "Struct", "Variable", "Constant"
    },

    post_parse_symbol = function(bufnr, item, ctx)
        if item.lnum then
            item.name = string.format("%s %d ", item.name, item.lnum)
        end
        return true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "aerial",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.fillchars = { eob = " " }
    vim.fn.matchadd("AerialLineNr", "\\s\\zs\\d\\+ $")
  end,
})

vim.keymap.set("n", "<leader>s", "<cmd>AerialToggle! left<CR>", { desc = "Toggle Symbol Tree" })

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('autotools_ls', {
  cmd = { 'autotools-language-server' },
  filetypes = { 'makefile', 'make', 'automake' },
  root_markers = { 'Makefile', 'makefile', '.git' },
})

vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = { 
    "clangd", 
    "--background-index", 
    "--clang-tidy", 
    "--header-insertion=iwyu", 
    "--completion-style=detailed" 
  },
--  init_options = { fallbackFlags = { "-std=c++17" } },
})

vim.lsp.config('marksman', { capabilities = capabilities })
vim.lsp.config('bashls', { capabilities = capabilities })
vim.lsp.config('jsonls', { capabilities = capabilities })

vim.lsp.enable('clangd')
vim.lsp.enable('marksman')
vim.lsp.enable('bashls')
vim.lsp.enable('jsonls')
vim.lsp.enable('autotools_ls')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('x', '=', function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf })
    vim.keymap.set('n', '==', function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf })
  end,
})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fallback() end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() elseif luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  })
})
