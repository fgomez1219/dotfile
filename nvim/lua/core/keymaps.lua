-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

-- General keymaps
keymap.set("i", "jk", "<ESC>") -- exit insert mode with jk
keymap.set("i", "ii", "<ESC>") -- exit insert mode with ii
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>ss", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-") -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+") -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5") -- make split windows width bigger
keymap.set("n", "<leader>sh", "<C-w><5") -- make split windows width smaller

-- Get relative path of a file
vim.keymap.set('n', '<leader>rp', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
end, { noremap = true, silent = true })

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>") -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c") -- next diff hunk
keymap.set("n", "<leader>cp", "[c") -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle maximize tab

-- Nvim-tree
keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<leader>er", ":NvimTreeFocus<CR>") -- toggle focus to file explorer
keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>") -- find file in file explorer

-- Telescope
-- keymap.set('n', '<C-p>', require('telescope.builtin').find_files, {})
--keymap.set('n', '<C-y>', require('telescope.builtin').live_grep, {})
--keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
--keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})
--keymap.set('n', '<leader>fs', require('telescope.builtin').current_buffer_fuzzy_find, {})
--keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, {})
--keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_incoming_calls, {})
--keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({default_text=":method:"}) end)
--
-- fzf ripgrep
keymap.set("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Search files" })

keymap.set("n", "<C-y>", function()
  require("fzf-lua").grep({
    prompt = "Rg❯ ",
    search = "",
    rg_opts = "--hidden --no-ignore --column --line-number --smart-case --color=always",
    fuzzy = true,
  })
end, { desc = "Search with fuzzy grep" })

keymap.set("n", "<C-k>", function()
  require("fzf-lua").keymaps()
end, { desc = "Search keymaps " })

keymap.set("n", "<C-b>", "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = "Search buffers" })
keymap.set("n", "<C-h>", "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "Search help" })

keymap.set("n", "<C-k>", function()
  require("fzf-lua").keymaps()
end, { desc = "Search keymaps" })

-- search over git modified files
keymap.set("n", "<C-g>", function()
  require("fzf-lua").fzf_exec("git status --porcelain | awk '{print $2}'", {
    prompt = "Git Modified Files❯ ",
    previewer = true,
    actions = {
      ["default"] = function(selected)
        if type(selected) == "table" then
          vim.cmd("edit " .. selected[1])
        else
          vim.cmd("edit " .. selected)
        end
      end,
    },
  })
end, { desc = "Search Git modified files" })

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame
vim.api.nvim_set_keymap('n', '<leader>gbo', ':GBrowse<CR>', { noremap = true, silent = true })

-- Harpoon
keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)
keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end)
keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end)
keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end)
keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end)
keymap.set("n", "<leader>h5", function() require("harpoon.ui").nav_file(5) end)
keymap.set("n", "<leader>h6", function() require("harpoon.ui").nav_file(6) end)
keymap.set("n", "<leader>h7", function() require("harpoon.ui").nav_file(7) end)
keymap.set("n", "<leader>h8", function() require("harpoon.ui").nav_file(8) end)
keymap.set("n", "<leader>h9", function() require("harpoon.ui").nav_file(9) end)

-- Vim REST Console
keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- LSP
keymap.set('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
keymap.set('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>')
keymap.set('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
keymap.set('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
keymap.set('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>')

-- Filetype-specific keymaps (these can be done in the ftplugin directory instead if you prefer)
keymap.set("n", '<leader>go', function()
  if vim.bo.filetype == 'python' then
    vim.api.nvim_command('PyrightOrganizeImports')
  end
end)

keymap.set("n", '<leader>tc', function()
  if vim.bo.filetype == 'python' then
    require('dap-python').test_class();
  end
end)

keymap.set("n", '<leader>tm', function()
  if vim.bo.filetype == 'python' then
    require('dap-python').test_method();
  end
end)

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
keymap.set("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>')
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
keymap.set("n", '<leader>dd', function() require('dap').disconnect(); require('dapui').close(); end)
keymap.set("n", '<leader>dt', function() require('dap').terminate(); require('dapui').close(); end)
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", '<leader>di', function() require "dap.ui.widgets".hover() end)
keymap.set("n", '<leader>d?', function() local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes) end)
keymap.set("n", '<leader>df', '<cmd>Telescope dap frames<cr>')
keymap.set("n", '<leader>dh', '<cmd>Telescope dap commands<cr>')
keymap.set("n", '<leader>de', function() require('telescope.builtin').diagnostics({default_text=":E:"}) end)

-- Mark TrailingWhitespace
vim.cmd([[
  highlight ExtraWhitespace ctermbg=darkgrey guibg=darkgrey
  augroup TrailingWhitespace
    autocmd!
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match none
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
  augroup END
]])

-- function to clean trailing whitespace
function TrimWhitespace()
  local save_cursor = vim.fn.getpos(".")
  local save_view = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
  vim.fn.winrestview(save_view)
end
-- mapping to call the function TrimWhitespace
vim.keymap.set("n", "<leader>tw", TrimWhitespace, { desc = "Trim trailing whitespace" })

-- disableing opacity background
vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
vim.cmd [[ hi NormalNC guibg=NONE ctermbg=NONE ]]
vim.cmd [[ hi EndOfBuffer guibg=NONE ctermbg=NONE ]]
vim.cmd [[ hi SignColumn guibg=NONE ctermbg=NONE ]]
--Change line colors (left)
vim.cmd [[ hi LineNr guibg=NONE guifg=#ffb07b ]]


-- change creds from bitwarden to use with vim-dadbod-ui
local function load_all_dbs_from_bitwarden()
  -- Get the Bitwarden session key from the environment variable
  local session = os.getenv("BW_SESSION")

  -- Check if the BW_SESSION environment variable is set
  if not session or session == "" then
    print("❌ BW_SESSION environment variable not set.")
    print("   Please unlock your Bitwarden vault in your terminal and export the session:")
    print("   export BW_SESSION=$(bw unlock --raw)")
    return
  end

  -- List items from Bitwarden with 'db-' in their name, using the session key
  -- We explicitly pass the session via --session option.
  local list_json = vim.fn.system(string.format('bw list items --search "db-" --session "%s"', session))

  -- Attempt to decode the JSON output from Bitwarden CLI
  local ok, items = pcall(vim.fn.json_decode, list_json)
  if not ok then
    print("❌ Error decoding JSON from Bitwarden CLI. Raw output:")
    print(list_json) -- Print raw output for debugging
    return
  end

  -- Initialize an empty table to store database connection strings
  local dbs = {}

  -- Iterate through each item retrieved from Bitwarden
  for _, item in ipairs(items) do
    -- Check if the item is a 'db-' connection item
    -- The Bash script now names items as "DB-<alias_name>", so we check for "DB-" prefix.
    -- Also ensure essential login details (uris, username, password) are present.
    if item.name and item.name:match("^DB%-") and item.login and item.login.uris and #item.login.uris > 0 and item.login.username and item.login.password then
      local dbname_val = ""
      local port_val = "5432"    -- Default port
      local dbtype_val = "postgres" -- Default type

      -- Extract custom fields from the item's 'fields' array
      for _, field in ipairs(item.fields or {}) do
        -- Check for the new field names
        if field.name == "Database Name" then
          dbname_val = field.value
        elseif field.name == "Port" then
          port_val = field.value
        elseif field.name == "DB Type" then
          dbtype_val = field.value
        end
      end

      -- If a database name was successfully found in custom fields
      if dbname_val ~= "" then
        local host = item.login.uris[1].uri -- Get the URI from the first entry in the uris array
        local user = item.login.username
        local pass = item.login.password

        -- Generate a unique key for the database connection table
        -- Uses the part after "DB-" from the item name,
        -- replaces spaces with underscores, and converts to lowercase.
        local key = item.name:match("^DB%-(.+)") -- Changed pattern from "DB %- (.+)" to "DB%-(.+)"
        if key then -- Ensure key is not nil if pattern doesn't match
            key = key:gsub("%s+", "_"):lower()
        else
            -- Fallback if the name doesn't perfectly match "DB-<alias>"
            key = item.name:gsub("%s+", "_"):lower() -- Use full name as key
        end


        -- Construct the Data Source Name (DSN) string
        local dsn = string.format("%s://%s:%s@%s:%s/%s", dbtype_val, user, pass, host, port_val, dbname_val)
        dbs[key] = dsn
      end
    end
  end

  -- Store the collected DSNs in a global Neovim variable
  vim.g.dbs = dbs
  -- Print a success message with the count of loaded connections
  print("✅ Loaded " .. tostring(vim.tbl_count(dbs)) .. " connections from Bitwarden.")
end

-- This allows you to run :LoadBitwardenDBs in Neovim
vim.api.nvim_create_user_command("LoadBitwardenDBs", load_all_dbs_from_bitwarden, {})

vim.api.nvim_create_user_command("DB", function()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.close()
  end
  vim.cmd("DBUI")
end, {})

-- ktlint
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true })
end, { desc = "Format file" })

-- debugger
vim.keymap.set("n", "<leader>p", function() require("dap").continue() end)
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)
vim.keymap.set("n", "<leader>b", function() require("dap").toggle_breakpoint() end)
