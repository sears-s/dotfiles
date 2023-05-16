# Dotfiles

## Installation

### Chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io) -b ~/.local/bin"
.local/bin/chezmoi init git@github.com:sears-s/dotfiles.git --apply
```

### Atuin

```bash
# Download *-linux.gnu.tar.gz from https://github.com/ellie/atuin/releases
tar -xzf *.tar.gz
mv atuin ~/.local/bin
atuin login -u <USERNAME> -p '<PASSWORD>' -k '<KEY>'
atuin import auto
atuin sync
```
