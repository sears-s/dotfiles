# Set default editor to Neovim
set -gx EDITOR nvim

# Commands to run in interactive sessions can go here
if status is-interactive

	# Disable defalt greeting
	set fish_greeting

	# Set theme
	fish_config theme choose Dracula

	# Install fisher if needed
	if not type -q fisher
		curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
		fisher update
		echo 3 1 2 1 1 1 2 2 4 1 2 2 y | tide configure >/dev/null
	end

	# Use Ctrl+F instead of Ctrl+Alt+F for fzf file shortcut
	# Leave Ctrl+R to atuin
	fzf_configure_bindings --directory=\cf --history=

	# Dynamically change Tide OS icon
	# Considerable slow down: https://github.com/IlanCosman/tide/issues/236
	_tide_detect_os | read -g --line os_branding_icon os_branding_color os_branding_bg_color
	set -U tide_os_icon $os_branding_icon
	set -U tide_os_color $os_branding_color
	set -U tide_os_bg_color $os_branding_bg_color

	# Add path
	fish_add_path ~/.local/bin

	# Initialize atuin and add shell completions
	if type -q atuin
		if atuin status >/dev/null 2>&1
			atuin init fish --disable-up-arrow | source
			atuin gen-completions --shell fish | source
		else
			echo "Warning: not logged into atuin account"
			echo "atuin login -u <USERNAME> -p <PASSWORD>"
		end
	else
		echo "Warning: atuin not installed"
	end

	# Add chezmoi shell completions
	if type -q chezmoi
		chezmoi completion fish | source
	end

	# Abbreviations
	if type -q bat
		abbr -a cat bat
	end
	if type -q nvim
		abbr -a vi nvim
		abbr -a vim nvim
	end
	abbr -a podman podman-remote

end
