FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    zsh git curl curl cmake build-essential vim systemd tmux xsel

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install tmux from source
RUN apt-get update && apt-get install -y libevent-dev bison byacc
RUN apt-get install -y libncurses-dev
RUN curl -L https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz -o tmux-3.4.tar.gz
RUN tar -xzf tmux-3.4.tar.gz
RUN cd tmux-3.4 && ./configure && make && make install
RUN rm -rf tmux-3.4.tar.gz tmux-3.4

# Install tmp
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
COPY .tmux.conf /root/.tmux.conf
RUN ~/.tmux/plugins/tpm/bin/install_plugins

# Install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz
RUN tar -C /opt -xzf nvim-linux-x86_64.tar.gz
RUN echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
RUN apt-get install -y ripgrep

# Install npm for LSP
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
RUN source /root/.bashrc && nvm install 20
SHELL ["/bin/bash", "--login", "-c"]

# Install NvChad
RUN git clone -b v2.0 https://github.com/anthony-wss/NvChad.git ~/.config/nvim --depth 1
RUN /opt/nvim-linux-x86_64/bin/nvim --headless +"Lazy! sync" +qa || true

WORKDIR /root
COPY .zshrc /root/.zshrc
RUN chsh -s $(which zsh)
