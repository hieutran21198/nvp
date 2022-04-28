provision_common:
		npm install -g lua-fmt
save_profile: #
		rm -rf ${HOME}/.config/nvim
		mv ${HOME}/.local/share/nvim/ ${HOME}/.local/share/nvim.bak
revert_profile: #
		ln -s ${HOME}/proj/vigo ${HOME}/.config/nvim
		rm -rf ${HOME}/.local/share/nvim
		mv ${HOME}/.local/share/nvim.bak ${HOME}/.local/share/nvim
link_nvp: #
		ln -s $(shell pwd) ${HOME}/.config/nvim
dev: 
		save-profile 
		link-nvp
