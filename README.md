# My neovim setup config

## Presequencies

It's assumed you have:
- ```nvim``` with version => 0.5
- ```rust_analyzer``` for rust language lsp support
- ```tsserver``` for js/ts lsp support
- ```vim-plug``` for plugins management

## Features

- Modern LSP (lsp-cmp+your lsp) and AI (TabNine) code completion support :fire:
- Easy instal process :fire:
- Git support :fire:
- Styling support :fire:
- Simple support of file system tree and terminal bars, there is no need to open other windows :fire:
- Adjustable for multiple OSes, what do you have (mac, unix, linux, windows) just does not matter :fire:
- No need to install anything manually, except for dependencies listed :fire:

## Setup

Copy the init.vim to ```~/.config/nvim/init.vim```, open nvim and execute ```:PlugInstall```.

If you're meeting problems with fonts on gnu/linux please try to install them like this
```console
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/3270.zip 
unzip 3270.zip -d ~/.fonts
fc-cache -fv
```

