local remap = vim.api.nvim_set_keymap

-- Control - O : find file with name."
remap('n', '<A-o>', '<cmd>Telescope find_files<cr>', {silent = true, noremap = true})
remap('n', '<A-d>',  '<cmd>Telescope oldfiles<cr>', {noremap = true})
remap('n' ,'<A-f>', '<cmd>Telescope live_grep<cr>', {noremap = true})
remap('n', 'm', '<cmd>Telescope man_pages<cr>', {noremap = true})

-- Lspsaga 
remap('n', '?', ':Lspsaga code_action<CR>', {noremap = true})

-- Keymap for todo
remap('n', 'ft', ':TodoTelescope <cr>', {noremap = true})
remap('n', 'tt', 'i// TODO :<ESC>' , {noremap = true})

remap('n', ';', ':', {noremap = true})

-- Tab Map
remap('n', '<A-1>', '1gt', {noremap = true})
remap('n', '<A-2>', '2gt', {noremap = true})
remap('n', '<A-3>', '3gt', {noremap = true})
remap('n', '<A-4>', '4gt', {noremap = true})
remap('n', '<A-5>', '5gt', {noremap = true})
remap('n', '<A-6>', '6gt', {noremap = true})
remap('n', '<A-7>', '7gt', {noremap = true})
remap('n', '<A-8>', '8gt', {noremap = true})
remap('n', '<A-9>', '9gt', {noremap = true})
remap('n', '<A-t>', ':tabnew<CR>', {noremap = true})
remap('n', '<A-w>', ':bdelete<CR>', {noremap = true})
remap('n', '<A-h>', ':tabprevious<CR>', {noremap = true})
remap('n', '<A-l>', ':tabnext<CR>', {noremap = true})

vim.cmd[[
autocmd TermEnter term://*toggleterm#*
   \ t--map <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>
   ]]
remap('n', '<silent><A-Enter>', '<Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>', {noremap = true})

remap('n', '<F5>', '<Cmd>lua require\'dap\'.continue()<CR>', { noremap = true, silent = true })
remap('n', '<F10>', '<Cmd>lua require\'dap\'.step_over()<CR>', { noremap = true, silent = true })
remap('n', '<F11>', '<Cmd>lua require\'dap\'.step_into()<CR>', { noremap = true, silent = true })
remap('n', '<F12>', '<Cmd>lua require\'dap\'.step_out()<CR>', { noremap = true, silent = true })
remap('n', '<Leader>b', '<Cmd>lua require\'dap\'.toggle_breakpoint()<CR>', { noremap = true, silent = true })
