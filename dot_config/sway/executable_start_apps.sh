#!/bin/bash

# Start applications
swaymsg "exec flatpak run com.brave.Browser"
swaymsg "exec flatpak run io.github.spacingbat3.webcord"
swaymsg "exec flatpak run md.obsidian.Obsidian"
swaymsg "exec flatpak run com.slack.Slack"
swaymsg "exec flatpak run com.spotify.Client"

# Wait for them to open
sleep 10

# Move to workspaces
sway '[class="Brave-browser"]' move container to workspace number 1
sway '[class="WebCord"]' move container to workspace number 2
sway '[class="obsidian"]' move container to workspace number 3
sway '[class="Slack"]' move container to workspace number 4
sway '[class="Spotify"]' move container to workspace number 5
