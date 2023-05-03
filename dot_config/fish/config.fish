# Set default editor to Neovim
set -gx EDITOR nvim

# Set ripgrep config path
if type -q rg
	set -x RIPGREP_CONFIG_PATH ~/.config/ripgrep
end

# Commands to run in interactive sessions can go here
if status is-interactive

	# Disable default greeting
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

	# Enable zoxide if available
	if type -q zoxide
		zoxide init fish | source
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

	# ls/ll/la/tree -> exa
	if type -q exa
		function _abbr_ls; _abbr_func ls exa; end
		_add_abbr ls
		function _abbr_ll; _abbr_func ll "exa -lg"; end
		_add_abbr ll
		function _abbr_la; _abbr_func la "exa -lga"; end
		_add_abbr la
		function _abbr_tree; _abbr_func tree "exa -T"; end
		_add_abbr tree
	end

	# du/ncdu -> dua
	if type -q dua
		function _abbr_du; _abbr_func du dua; end
		_add_abbr du
		function _abbr_ncdu; _abbr_func ncdu "dua i"; end
		_add_abbr ncdu
	end

	# podman -> podman-remote
	if not type -q distrobox-enter
		function _abbr_podman; _abbr_func podman podman-remote; end
		_add_abbr podman
	end

	# gacp -> git add -A && git commit -m "" && git push
	if type -q git
		abbr -a gacp --set-cursor "git add -A && git commit -m \"%\" && git push"
	end

	# Aliases for running containers
	if type -q distrobox-enter
		set -g container_cmd podman
	else
		set -g container_cmd podman-remote
	end
	function rustscan
		sudo $container_cmd run -it --rm --name rustscan docker.io/rustscan/rustscan:2.1.1 $argv
	end

	# Alias for wezterm Flatpak
	if type -q flatpak
		function wezterm
			flatpak run org.wezfurlong.wezterm $argv
		end
	end

	# Aliases for gdb
	if test -d /opt/gdb
		function gdb-gef
			gdb -q -ex init-gef $argv
		end
		function gdb-pwndbg
			gdb -q -ex init-pwndbg $argv
		end
		abbr -a gdb gdb-pwndbg
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
