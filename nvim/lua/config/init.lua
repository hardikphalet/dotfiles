local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local HardikGroup = augroup('Hardik', {})
local format_group = augroup('LspFormatOnSave', {})

autocmd('LspAttach', {
  group = HardikGroup,
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    local bufnr = e.buf
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vri", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    if client and client.supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = format_group,
        buffer = bufnr,
        callback = function()
          if not vim.api.nvim_buf_is_loaded(bufnr) then
            return
          end

          local has_formatter = false
          for _, format_client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if format_client.supports_method('textDocument/formatting') then
              has_formatter = true
              break
            end
          end
          if not has_formatter then
            return
          end

          vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end,
      })
    end
  end
})
