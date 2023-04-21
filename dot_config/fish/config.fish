# Set default editor to Neovim
set -gx EDITOR nvim

# Set ripgrep config path
if type -q rg
	set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep
end

# Commands to run in interactive sessions can go here
if status is-interactive

	# Disable defalt greeting
	set fish_greeting

	# Set theme
	fish_config theme choose Dracula

	# Use Ctrl+F instead of Ctrl+Alt+F for fzf file shortcut
	# Leave Ctrl+R to atuin
	fzf_configure_bindings --directory=\cf --history=

	# Dynamically change Tide OS icon
	# Considerable slow down: https://github.com/IlanCosman/tide/issues/236
	function _tide_fix_os_icon
		_tide_detect_os | read -g --line os_branding_icon os_branding_color os_branding_bg_color
		set -U tide_os_icon $os_branding_icon
		set -U tide_os_color $os_branding_color
		set -U tide_os_bg_color $os_branding_bg_color
	end
	_tide_fix_os_icon

	# Add path
	fish_add_path ~/.local/bin

	# Initialize atuin and add shell completions
	if type -q atuin
		if atuin status >/dev/null 2>&1
			atuin init fish --disable-up-arrow | source
			atuin gen-completions --shell fish | source
		else
			echo "Warning: not logged into atuin account"
			echo "atuin login -u <USERNAME> -p '<PASSWORD>' -k '<KEY>'"
		end
	else
		echo "Warning: atuin not installed"
	end

	# Add chezmoi shell completions
	if type -q chezmoi
		chezmoi completion fish | source
	end

	# Add abbreviations that support sudo
	function _abbr_func
		set -l old_cmd $argv[1]
		set -l new_cmd $argv[2]
		set -l cmd (commandline -op)
		if [ (count $cmd) -eq 1 -a "$cmd[1]" = $old_cmd ] || \
		[ (count $cmd) -eq 2 -a "$cmd[1]" = sudo -a "$cmd[2]" = $old_cmd ]
			echo $new_cmd
			return 0
		end
		return 1
	end
	function _add_abbr
		abbr -a $argv[1] --position anywhere -f _abbr_$argv[1]
	end

	# cat -> bat
	if type -q bat
		function _abbr_cat; _abbr_func cat bat; end
		_add_abbr cat
	end

	# vi/vim -> nvim
	if type -q nvim
		function _abbr_vi; _abbr_func vi nvim; end
		_add_abbr vi
		function _abbr_vim; _abbr_func vim nvim; end
		_add_abbr vim
	end

	# grep -> rg
	if type -q rg
		function _abbr_grep; _abbr_func grep rg; end
		_add_abbr grep
	end

	# Wrapper for distrobox-enter -r
	# Fixes OS icon not restoring
	if type -q distrobox-enter
		function dbe -w distrobox-enter
			distrobox-enter -r $argv
			_tide_fix_os_icon
		end
	end

end
