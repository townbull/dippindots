--- LSP status
vim.pack.add({
  "https://github.com/j-hui/fidget.nvim",
})
require("fidget").setup({
  notification = {
    override_vim_notify = true,
  },
})

-- https://github.com/neovim/neovim/issues/23291
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
  -- disable lsp watcher. Too slow on linux
  wf._watchfunc = function()
    return function() end
  end
end

--- Lower priority for LSP semantic token highlighting.
vim.highlight.priorities.semantic_tokens = 95

--- Log file grows very quickly
vim.lsp.log.set_level("off")

--- Completion settings:
--- * show menu
--- * show popup with more info
--- * don't auto-insert the first match
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.pumheight = 10        -- Max height of completion menu.
vim.o.winborder = "single"  -- Single border on all floating windows.

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

--- Trigger completion if closed; cycle forward if open
vim.keymap.set('i', '<c-e>', function()
  if vim.fn.pumvisible() ~= 0 then
    feedkeys '<C-n>'
  elseif next(vim.lsp.get_clients { bufnr = 0 }) then
    vim.lsp.completion.get()
  elseif vim.bo.omnifunc == '' then
    feedkeys '<C-x><C-n>'
  else
    feedkeys '<C-x><C-o>'
  end
end)

--- Cycle backward if menu is open; delete previous word if closed
vim.keymap.set('i', '<c-w>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-w>'
end, { expr = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client.server_capabilities.completionProvider then
      client.server_capabilities.completionProvider.triggerCharacters =
        vim.split("qwertyuiopasdfghjklzxcvbnm. ", "")
      vim.lsp.completion.enable(true,
        ev.data.client_id, ev.buf, {
          autotrigger = true,
          convert = function(item)
            return {
              -- Remove function params to save space.
              abbr = item.label:gsub('%b()', ''),

              -- Also remove the "Method", "Function", etc column.
              kind = "",
            }
          end,
        })
    end

    local bind = function(desc, keys, func)
      vim.keymap.set('n', keys, func,
      { buffer = ev.buf, desc = desc, noremap = true })
    end

    bind("Go to previous diagnostic message",
      '{', function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end)
    bind("Go to next diagnostic message",
      '}', function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end)

    local function code_action()
        vim.lsp.buf.code_action({
          -- Filter out code actions I never use
          -- and often crowd the list.
          filter = function(action)
            local title = vim.fn.trim(action.title)
            return not vim.startswith(title, "Generate delegate")
          end,
        })
    end

    bind('Go to definition',
      "gd", vim.lsp.buf.definition)
    bind('Code action',
      "'a", code_action)
    bind('Hover documentation',
      "'d", vim.lsp.buf.hover)
    bind('Rename symbol',
      "'r", vim.lsp.buf.rename)
    bind('Show diagnostics',
      "'e", function()
        vim.diagnostic.open_float(0, { scope = "line", focus = false })
      end)

    -- Format on write
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format()
      end
    })
  end,
})

vim.lsp.config["rust"] = {
  filetypes = { 'rust' },
  root_markers = { ".git", "Cargo.lock" },
  cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        targetDir = "target/ra",
      },
      files = {
        excludeDirs = {
          ".git",
          ".cargo",
          ".direnv",
          "node_modules",
          "target",
        },
      },
      completion = {
        postfix = {
          enable = true
        },

        -- Show private fields in completion
        privateEditable = {
          enable = true,
        },
      },
      workspace = {
        symbol = {
          search = {
            -- Or "all_symbols".
            kind = "only_types",
          },
        },
      },
    }
  }
}

vim.lsp.enable('rust')

-- pip install ty
vim.lsp.config["python"] = {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = {
    "requirements.txt",
    "pyproject.toml",
    "mise.toml",
    ".git",
  },
  settings = {
    ty = {
      diagnosticMode = "workspace",
    }
  },
}
vim.lsp.enable('python')

-- npm install -g @vtsls/language-server
vim.lsp.config["ts"] = {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript" },
  root_markers = {
    "tsconfig.json",
    "package.json",
    ".git",
  },
  -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
  settings = {
    vtsls = {}
  }
}
vim.lsp.enable('ts')

-- cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist-cli
vim.lsp.config["tinymist"] = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {}
}
vim.lsp.enable('tinymist')


-- Show errors and warnings in a floating window
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- Skip if another floating window is open
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        return
      end
    end
    -- Show diagnostics if no other floating windows are present
    vim.diagnostic.open_float(nil, { focusable = false, source = true })
  end,
})
