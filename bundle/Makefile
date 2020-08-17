.PHONY: all
all: neovim YouCompleteMe

.PHONY: neovim
neovim:
	pip2 install --upgrade neovim
	pip3 install --upgrade neovim

.PHONY: YouCompleteMe
YouCompleteMe:
	cd youcompleteme && git submodule update --init --recursive
	cd youcompleteme && python3 install.py --all
