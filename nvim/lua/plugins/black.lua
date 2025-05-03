-- Python formatter
return {
  -- https://github.com/psf/black
  'psf/black',
  enabled = false,
  ft = 'python',
  config =function ()
    -- Automatically format file buffer when saving
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = "*.py",
      callback = function()
        vim.cmd("Black --line-length 120")
      end,
    })
  end
}
