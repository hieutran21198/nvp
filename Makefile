provision-common:
	npm install -g lua-fmt
save-profile:
  rm -rf ~/.config/nvim
  mv ~/.local/share/nvim/ ~/.local/share/nvim.bak
revert-profile:
  ln -s ~/proj/vigo ~/.config/nvim
  mv ~/.local/share/nvim.bak ~/.local/share/nvim
link-nvp:
  ln -s (pwd) ~/.config/nvim
dev: save-profile link-nvp
