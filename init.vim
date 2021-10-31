""" Common flags
set encoding=utf-8          " default encoding is utf-8
set nocompatible            " disable compatibility to old-time vi
set hlsearch                " highlight search 
set incsearch               " incremental search
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
syntax on                   " syntax highlighting
set clipboard=unnamedplus   " using system clipboard
set ttyfast                 " Speed up scrolling in Vim
set noswapfile              " disable creating swap file
set fileformat=unix         " Unix file format (for example line endings)
set mouse=a                 " Enable scrolling (in term too)
filetype plugin on

""" Plugins
call plug#begin('~/.vim/plugged')

"" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

"" Color schemes
Plug 'tomasiser/vim-code-dark'

"" Git
Plug 'airblade/vim-gitgutter'

call plug#end()

""" Current color scheme
colorscheme codedark

""" Git
let g:gitgutter_sign_added = 'a'
let g:gitgutter_sign_modified = 'm'
let g:gitgutter_sign_removed = 'r'
let g:gitgutter_sign_removed_first_line = 'rf'
let g:gitgutter_sign_modified_removed = 'mr'
highlight GitGutterAdd    guifg=#00FF00 ctermfg=3
highlight GitGutterChange guifg=#FFFF00 ctermfg=2
highlight GitGutterDelete guifg=#ff0000 ctermfg=1
au BufEnter * :GitGutterEnable
au BufEnter * :GitGutterSignsEnable
set updatetime=50

""" Tabs&expand
set noexpandtab  " Make sure that every file uses real tabs, not spaces
set shiftround   " Round indent to multiple of 'shiftwidth'
set smartindent  " Do smart indenting on starting of each line
set autoindent   " Copy indent from previos lines

filetype plugin indent off

let s:tabwidth = 2
exec 'set tabstop=' .s:tabwidth
exec 'set shiftwidth=' .s:tabwidth
exec 'set softtabstop=' .s:tabwidth

""" Code completion setup
lua << EOF
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<A-k>'] = cmp.mapping.select_prev_item(),
    ['<A-j>'] = cmp.mapping.select_next_item(),
    ['<A-d>'] = cmp.mapping.scroll_docs(-4),
    ['<A-f>'] = cmp.mapping.scroll_docs(4),
    ['<A-Space>'] = cmp.mapping.complete(),
    ['<A-e>'] = cmp.mapping.close(),
    ['<Tab>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
EOF

""" LSP config
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vm.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

""" Terminal
" Terminal Open Close Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

let g:term_mode = 0
function! ChangeTermMode()
  if g:term_mode > 0
    let g:term_mode = 0 "Read
  else
    let g:term_mode = 1 "Edit
    :startinsert
  endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <A-m> <C-\><C-n>:call ChangeTermMode()<CR>
nnoremap <A-m> :call ChangeTermMode()<CR>

