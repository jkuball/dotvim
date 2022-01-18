[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/jkuball/dotvim/master.svg)](https://results.pre-commit.ci/latest/github/jkuball/dotvim/master)

# dotvim

My double vim/neovim configuration. As vanilla vim as possible, but tailored to me and my antics.

This file is mostly for my future self if I need to set up a new dev environment.

## vim

For admin stuff on remote servers, no lsp support.

```bash
git clone git@github.com:geratheon/dotvim.git ~/.vim
```

## neovim

For the usual development process and my own machines.

```bash
git clone git@github.com:geratheon/dotvim.git ~/.config/nvim
```

### Todo List of Language Servers

Pick what you need:

```bash
npm i -g dockerfile-language-server-nodejs
npm i -g pyright
npm i -g typescript typescript-language-server
npm i -g vim-language-server
npm i -g vscode-langservers-extracted
npm i -g yaml-language-server

rustup component add rust-src
rustup +nightly component add rust-analyzer-preview

pipx install python-lsp-server[all]
pipx install 'python-lsp-server[mccabe,pycodestyle,pydocstyle,pylint,rope]'
pipx inject python-lsp-server pyls-isort python-lsp-black pylsp-rope pyls-memestra
```
