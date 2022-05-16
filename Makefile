provision_common:
		npm install -g lua-fmt
save_profile: #
		rm -rf ${HOME}/.config/nvim
		mv ${HOME}/.local/share/nvim/ ${HOME}/.local/share/nvim.bak
uninstall: #
		rm -rf ${HOME}/.config/nvim
		rm -rf ${HOME}/.local/share/nvim
install: #
		ln -s $(shell pwd) ${HOME}/.config/nvim
link_plugins:
		ln -s ${HOME}/.local/share/nvim/site $(shell pwd)/site
