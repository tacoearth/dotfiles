-- used claude and gemini for help with debugger fts

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        highlight = { enable = true },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      local c = {
        bg_a      = "#bfbfff", fg_a      = "#111111",
        bg_b      = "#2a2a3d", fg_b      = "#ffffff",
        bg_c      = "#222222", fg_c      = "#cccccc",
        bg_insert = "#a6e3a1", fg_insert = "#111111",
        bg_visual = "#cba6f7", fg_visual = "#111111",
        bg_replace= "#f38ba8", fg_replace = "#111111",
        bg_cmd    = "#fab387", fg_cmd    = "#111111",
      }
      local theme = {
        normal  = { a = { bg=c.bg_a, fg=c.fg_a, gui="bold" }, b = { bg=c.bg_b, fg=c.fg_b }, c = { bg=c.bg_c, fg=c.fg_c } },
        insert  = { a = { bg=c.bg_insert, fg=c.fg_insert, gui="bold" }, b = { bg=c.bg_b, fg=c.fg_b }, c = { bg=c.bg_c, fg=c.fg_c } },
        visual  = { a = { bg=c.bg_visual, fg=c.fg_visual, gui="bold" }, b = { bg=c.bg_b, fg=c.fg_b }, c = { bg=c.bg_c, fg=c.fg_c } },
        replace = { a = { bg=c.bg_replace,fg=c.fg_replace,gui="bold" }, b = { bg=c.bg_b, fg=c.fg_b }, c = { bg=c.bg_c, fg=c.fg_c } },
        command = { a = { bg=c.bg_cmd, fg=c.fg_cmd, gui="bold" }, b = { bg=c.bg_b, fg=c.fg_b }, c = { bg=c.bg_c, fg=c.fg_c } },
        inactive= { a = { bg=c.bg_c, fg="#555577", gui="bold" }, b = { bg=c.bg_c, fg="#555577" }, c = { bg=c.bg_c, fg="#555577" } },
      }
      require("lualine").setup({
        options = { theme = theme, component_separators = { left = "", right = "" }, section_separators = { left = "", right = "" }, globalstatus = true },
        sections = { lualine_a = { "mode" }, lualine_b = { "branch", "diff", "diagnostics" }, lualine_c = { "filename" }, lualine_x = { "encoding", "filetype" }, lualine_y = { "progress" }, lualine_z = { "location" } },
      })
    end,
  },

  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },

  "neovim/nvim-lspconfig",
  { "onsails/lspkind.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },

  { "mfussenegger/nvim-dap" },
  { "nvim-neotest/nvim-nio" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  { "theHamsta/nvim-dap-virtual-text" },
  
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          codelldb = function(config)
            config.configurations = {
              {
                name = "Launch (codelldb)",
                type = "codelldb",
                request = "launch",
                program = function()
                  return vim.fn.input("Binary: ", vim.fn.getcwd() .. "/a.out", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                runInTerminal = true,
                console = "integratedTerminal",
                showDisassembly = "never",
                initCommands = {
                  "settings set target.process.thread.step-avoid-regexp ^(std|__gnu_cxx)::",
                  "breakpoint set --name main",
                },
              },
              {
                name = "Attach to PID",
                type = "codelldb",
                request = "attach",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
            }
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })
    end,
  },
}, {
  rocks = { enabled = false },
})

vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.termguicolors  = true
vim.opt.cursorline     = true
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.expandtab      = true
vim.opt.signcolumn     = "number"

require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    aerial = true,
    native_lsp = {
      enabled = true,
      underlines = { errors = { "undercurl" }, hints = { "undercurl" }, warnings = { "undercurl" }, information = { "undercurl" } },
    },
  },
  color_overrides = {
    mocha = {
      base = "#111111", mantle = "#111111", crust = "#111111", text = "#ffffff",
      blue = "#bfbfff", sapphire = "#bfbfff", sky = "#bfbfff",
    },
  },
})
vim.cmd.colorscheme "catppuccin"

vim.api.nvim_set_hl(0, "LineNr",       { fg = "#bfbfff" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#bfbfff", bold = true })
vim.api.nvim_set_hl(0, "FloatBorder",  { fg = "#bfbfff", bg = "#111111" })
vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "#111111" })
vim.api.nvim_set_hl(0, "MsgArea",      { bg = "#404040" })

vim.api.nvim_set_hl(0, "CmpNormal",    { bg = "#131313" })
vim.api.nvim_set_hl(0, "CmpBorder",    { fg = "#bfbfff", bg = "#131313" })

vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<leader>n", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle Relative Numbers" })

vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Navigate Left" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Navigate Down" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Navigate Up" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Navigate Right" })

vim.keymap.set("t", "<A-h>", [[<C-\><C-n><C-w>h]], { desc = "Navigate Left" })
vim.keymap.set("t", "<A-j>", [[<C-\><C-n><C-w>j]], { desc = "Navigate Down" })
vim.keymap.set("t", "<A-k>", [[<C-\><C-n><C-w>k]], { desc = "Navigate Up" })
vim.keymap.set("t", "<A-l>", [[<C-\><C-n><C-w>l]], { desc = "Navigate Right" })

local border_style = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts           = opts or {}
  opts.border    = opts.border or border_style
  opts.max_width = 40
  opts.wrap      = true
  local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
  if winnr then vim.api.nvim_win_set_option(winnr, "wrap", true) end
  return bufnr, winnr
end

vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("keep", config or {}, { border = border_style, focusable = false, silent = true }))
end

vim.api.nvim_set_hl(0, "AerialLineNr", { fg = "#404040", italic = true })
vim.api.nvim_set_hl(0, "AerialBg",     { bg = "#181818" })

require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown", "man" },
  layout = {
    default_direction = "prefer_left", max_width = { 40, 0.2 }, min_width = 10, resize_to_content = true,
    win_opts = { winhighlight = "Normal:AerialBg,SignColumn:AerialBg,EndOfBuffer:AerialBg" },
  },
  icons = { Class = "󰠱 ", Constructor = " ", Constant = "󰏿 ", Enum = " ", Function = "󰊕 ", Interface = " ", Method = "󰆧 ", Module = " ", Struct = "󰆼 ", Variable = "󰀫 " },
  filter_kind = { "Class", "Constructor", "Enum", "Function", "Interface", "Module", "Method", "Struct", "Variable", "Constant" },
  post_parse_symbol = function(bufnr, item, ctx)
    if item.lnum then item.name = string.format("%s %d ", item.name, item.lnum) end
    return true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "aerial",
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
    vim.opt_local.fillchars      = { eob = " " }
    vim.fn.matchadd("AerialLineNr", "\\s\\zs\\d\\+ $")
  end,
})

vim.keymap.set("n", "<leader>s", "<cmd>AerialToggle! left<CR>", { desc = "Toggle Symbol Tree" })

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("autotools_ls", { cmd = { "autotools-language-server" }, filetypes = { "makefile", "make", "automake" }, root_markers = { "Makefile", "makefile", ".git" } })
vim.lsp.config("clangd", { capabilities = capabilities, cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed" } })
vim.lsp.config("marksman", { capabilities = capabilities })
vim.lsp.config("bashls",   { capabilities = capabilities })
vim.lsp.config("jsonls",   { capabilities = capabilities })

vim.lsp.enable("clangd")
vim.lsp.enable("marksman")
vim.lsp.enable("bashls")
vim.lsp.enable("jsonls")
vim.lsp.enable("autotools_ls")

vim.diagnostic.config({
  virtual_text = {
    spacing = 3,
    prefix  = "󰓛",
    format  = function(d) return (d.message:match("^([^\n]+)") or d.message) end,
  },
  signs     = true,
  underline = true,
  float = {
    border  = border_style,
    source  = "always",
    header  = "",
    prefix  = "",
    max_width = 80,
    wrap    = true,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "K",         vim.lsp.buf.hover,         opts)
    vim.keymap.set("n", "gd",        vim.lsp.buf.definition,    opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename,        opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gl",        vim.diagnostic.open_float,  opts)
    vim.keymap.set("n", "[d",        vim.diagnostic.goto_prev,   opts)
    vim.keymap.set("n", "]d",        vim.diagnostic.goto_next,   opts)
    vim.keymap.set("x", "=",  function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf })
    vim.keymap.set("n", "==", function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf })
  end,
})

local cmp     = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  window = {
    completion = cmp.config.window.bordered({ winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel", col_offset = -3, side_padding = 0 }),
    documentation = false,
  },
  completion = { completeopt = "menu,menuone,noinsert" },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text", maxwidth = 30, ellipsis_char = "…", show_labelDetails = true,
      before = function(entry, vim_item)
        vim_item.menu = ({ nvim_lsp = "[LSP]", luasnip = "[Snip]", buffer = "[Buf]", path = "[Path]" })[entry.source.name]
        return vim_item
      end,
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() elseif luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" }, { name = "buffer" } }),
})

local dap   = require("dap")
local dapui = require("dapui")

dap.defaults.fallback.terminal_win_cmd = 'belowright 15new'

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*dap-terminal*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.fn.sign_define("DapBreakpoint",          { text = "󰓛", texthl = "DapBreakpoint",          linehl = "",               numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition",  linehl = "",               numhl = "DapBreakpointCondition" })
vim.fn.sign_define("DapBreakpointRejected",  { text = "✖", texthl = "DapBreakpointRejected",   linehl = "",               numhl = "DapBreakpointRejected" })
vim.fn.sign_define("DapLogPoint",            { text = "󰃁", texthl = "DapLogPoint",            linehl = "",               numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped",             { text = "→ ", texthl = "DapStopped",            linehl = "DapStoppedLine", numhl = "DapStopped" })

vim.api.nvim_set_hl(0, "DapBreakpoint",          { fg = "#f9e2af" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#ffb86c" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected",  { fg = "#888888" })
vim.api.nvim_set_hl(0, "DapLogPoint",            { fg = "#8be9fd" })
vim.api.nvim_set_hl(0, "DapStopped",             { fg = "#f9e2af", bold = true })
vim.api.nvim_set_hl(0, "DapStoppedLine",         { bg = "#2b4a2b" })

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
  mappings = { expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", edit = "e", repl = "r", toggle = "t" },
  controls = { enabled = true, element = "console" },
  layouts = {
    { elements = { { id = "scopes", size = 0.7 }, { id = "stacks", size = 0.3 } }, size = 40, position = "left" },
    { elements = { { id = "console", size = 1.0 } }, size = 15, position = "bottom" }
  },
  floating = { max_height = 0.9, max_width = 0.5, border = border_style },
})

local auto_step_enabled = false

local function read_source_line(file, lnum)
  local bufnr = vim.fn.bufnr(file)
  if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
    local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
    return lines[1] or ""
  end
  local lines = vim.fn.readfile(file)
  return (lines and lines[lnum]) or ""
end

local function SmartStepInto()
  local session = require("dap").session()
  if not session then
    require("dap").step_into()
    return
  end

  local frame = session.current_frame
  if frame and frame.source and frame.source.path and frame.line then
    local lt = read_source_line(frame.source.path, frame.line)
    local is_range_for = lt:match("for%s*%b()") ~= nil and lt:match(":%s*[%w_&*]") ~= nil
    if is_range_for then
      require("dap").step_over()
      return
    end
  end
  
  require("dap").step_into()
end

local function StopAutoStep()
  auto_step_enabled = false
end

local function StartAutoStep()
  auto_step_enabled = true
  SmartStepInto()
end

local function ToggleAutoStep()
  if auto_step_enabled then
    StopAutoStep()
    print("Auto-step stopped")
  else
    StartAutoStep()
    print("Auto-step started (1000ms)")
  end
end

dap.listeners.after.event_initialized["auto_step_start"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["auto_step_stop"] = StopAutoStep
dap.listeners.before.event_exited["auto_step_stop"]     = StopAutoStep
dap.listeners.before.disconnect["auto_step_stop"]       = StopAutoStep

dap.listeners.after.event_stopped["unified_handler"] = function(session, body)
  session:request("stackTrace", { threadId = body.threadId, levels = 1 }, function(err, response)
    if err or not response or not response.stackFrames or #response.stackFrames == 0 then
      if auto_step_enabled then StopAutoStep() end
      return
    end

    local frame = response.stackFrames[1]
    local current_file = frame.source and frame.source.path
    local cwd = vim.fn.getcwd()

    if not current_file or not vim.startswith(vim.fn.resolve(current_file), cwd) then
      session:request("stepOut", { threadId = body.threadId })
      return
    end

    if frame.name == "main" and frame.line then
      local line_text = read_source_line(current_file, frame.line)
      if line_text:match("^%s*return") or line_text:match("^%s*}%s*$") then
        if auto_step_enabled then
          StopAutoStep()
          print("Auto-step reached end of main(). Paused.")
        end
        return
      end
    end

    if auto_step_enabled then
      vim.defer_fn(function()
        if auto_step_enabled and session.stopped_thread_id then
          SmartStepInto()
        end
      end, 1000)
    end
  end)
end

require("nvim-dap-virtual-text").setup({
  enabled = true, enabled_commands = true, highlight_changed_variables = true, highlight_new_as_changed = true,
  show_stop_reason = true, commented = false, virt_text_pos = "eol", all_frames = false,
})

vim.keymap.set("n", "<leader>da", ToggleAutoStep,      { desc = "Debug: Toggle Auto-Step" })
vim.keymap.set("n", "<F5>",       dap.continue,          { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F9>",       dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<F10>",      dap.step_over,         { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>",      SmartStepInto,         { desc = "Debug: Smart Step Into" })
vim.keymap.set("n", "<S-F11>",    dap.step_out,          { desc = "Debug: Step Out" })
vim.keymap.set("n", "<F4>",       function() dap.terminate(); require("dapui").close() end, { desc = "Debug: Stop" })

vim.keymap.set("n", "<leader>db", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Debug: Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, { desc = "Debug: Log Point" })

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    require("dapui").close()
  end
})

vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
vim.keymap.set("n", "<leader>dl", dap.run_last,  { desc = "Debug: Run Last" })
vim.keymap.set("n", "<leader>df", dapui.toggle,  { desc = "Debug: Toggle UI" })
vim.keymap.set({ "n", "v" }, "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Debug: Hover Value" })
vim.keymap.set({ "n", "v" }, "<leader>dp", function() require("dap.ui.widgets").preview() end, { desc = "Debug: Preview Value" })
