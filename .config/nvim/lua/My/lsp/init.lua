require('fidget').setup()

local lsp_config = require('lspconfig')

local flags = {
  allow_incremental_sync = true,
  debounce_text_changes = 200,
}
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)

  end,
})

local global_on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

  --nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap("<leader>vd", vim.diagnostic.open_float, '[V]iew [D]iagnostic')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- local client = vim.lsp.get_client_by_id(event.data.client_id)
  -- if client and client.server_capabilities.documentHighlightProvider then
  --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --     buffer = event.buf,
  --     callback = vim.lsp.buf.document_highlight,
  --   })

  --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --     buffer = event.buf,
  --     callback = vim.lsp.buf.clear_references,
  --   })
  -- end

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

local servers = {
  'clangd',
  'rust_analyzer',
  'pyright',
  --'tsserver',
  'lua_ls',
  --'gopls',
  -- 'java_language_server',
  'jdtls',
}

local server_config_override = {
  lua_ls = 'My.lsp.lua_ls',
  jdtls = 'My.lsp.jtdls',
  rust_analyzer = 'My.lsp.rust_analyzer',
}


require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())


for _, server in ipairs(servers) do
  local _setup = {}
  local server_on_attach = global_on_attach

  local config_override = server_config_override[server]
  if (config_override) then
    local config = require(config_override)
    _setup = config.settings
    server_on_attach = function(_, bufnr)
      global_on_attach(_, bufnr)
      if config.on_attach ~= nil then
        config.on_attach(_, bufnr)
      end
    end
  end

  _setup.on_attach = server_on_attach
  _setup.capabilities = capabilities
  _setup.flags = flags

  lsp_config[server].setup(_setup)
end
-- vim: ts=2 sts=2 sw=2 et
