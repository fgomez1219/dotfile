-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This has to be set before initializing lazy
vim.g.mapleader = " "

-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
   change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- turn off notifications whenever plugin changes are made
  },
})

-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")


-- Define directories inside the user's home
local HOME = os.getenv("HOME")

-- Use standard Neovim data folder under HOME
local NVIM_DATA = HOME .. "/.local/share/nvim"

local SWAPDIR   = NVIM_DATA .. "/swap//"
local BACKUPDIR = NVIM_DATA .. "/backup//"
local UNDODIR   = NVIM_DATA .. "/undo//"

-- Create directories if they don't exist
for _, dir in ipairs({SWAPDIR, BACKUPDIR, UNDODIR}) do
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
    vim.fn.setfperm(dir, "rwx------")
  end
end

-- Enable swap, backup, and persistent undo
vim.opt.directory = SWAPDIR
vim.opt.backupdir = BACKUPDIR
vim.opt.undodir = UNDODIR
vim.opt.swapfile = true
vim.opt.backup = true
vim.opt.undofile = true

-- Append backup files with timestamp
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local extension = "~" .. vim.fn.strftime("%Y-%m-%d-%H%M%S")
		vim.o.backupext = extension
	end,
})
