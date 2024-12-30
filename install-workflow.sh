# System packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl cmake build-essential vim systemd

# Install python
sudo apt install -y python3.10 python3.10-venv python3.10-dev
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Install oh-my-zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "alias vim=nvim" >> ~/.zshrc
echo 'alias rl="readlink -f"' >> ~/.zshrc
echo "Please manually add vi-mode in plugins"
echo "export VI_MODE_SET_CURSOR=true" >> ~/.zshrc

# Install tmux
sudo apt install -y tmux
git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
echo 'Make sure tmux version > 3.1c'
# If not, install tmux from source: https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
tmux_conf_content='set-option -sa terminal-overrides "xterm*:Tc"
set -g mouse on

# Set prefix
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

bind C-l send-keys "C-l"

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# set vi-mode
set-window-option -g mode-keys vi
# keybindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

bind "\"" split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

set -g @plugin "tmux-plugins/tpm"
set -g @plugin "tmux-plugins/tmux-sensible"
set -g @plugin "christoomey/vim-tmux-navigator"
set -g @plugin "catppuccin/tmux"
set -g @plugin "tmux-plugins/tmux-yank"

bind -n S-Left  previous-window
bind -n S-Right next-window

run "~/.tmux/plugins/tpm/tpm"
'

echo "$tmux_conf_content" > ~/.tmux.conf
sudo apt install xsel  # tmux-yank dependency
tmux source ~/.tmux.conf
echo "Remember to manually run '<tmux-leadkey>+I'"

# Install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.zshrc
sudo apt-get install ripgrep

# Install npm for LSP
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 20
git clone -b v2.0 https://github.com/anthony-wss/NvChad.git ~/.config/nvim --depth 1

