#!/usr/bin/bash

# New environment fresh install

# ID distro
DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2)

# Capture everything that fails to install properly
failed_installs=()
handle_error() {
    local failed_command="$BASH_COMMAND"
    error_list+=("Error occurred during: $failed_command")
}
trap 'handle_error' ERR
set -e

# Install tools available on distro package managers without anything extra
TOOLS=(curl wget zsh git gh fzf jq golang nodejs )

check_version() {
    local tool=$1
    local callback=$2

    if command -v "$tool" &> /dev/null; then
        echo "$tool version: $($tool --version 2>/dev/null || $tool -v 2>/dev/null || $tool version 2>/dev/null || echo 'Version check failed but tool found: $tool')"
    else
        echo "$tool not found. Installing..."
        "$callback" "$tool"
    fi
}

install_tool() {
    local tool=$1
    if [ "$DISTRO" = "fedora" ]; then
        sudo dnf install "$tool" -y
    else 
        sudo apt install "$tool" -y
    fi
}

for tool in "${TOOLS[@]}"; do
    check_version  "$tool" install_tool
done


# Other tools

#python
py_install() {
    if [ "$DISTRO" = "fedora" ]; then
        sudo dnf install python3 -y
        sudo dnf install python3-pip -y
    else 
        sudo apt install python3 -y
        sudo apt install python3-pip -y
    fi
}
check_version python3 py_install

#lua 
lua_install() {
    if [ "$DISTRO" = "fedora" ]; then
        sudo dnf install lua -y
    else 
        sudo apt install lua5.4 -y
    fi
}
check_version lua lua_install


#neovim 
nvim_install() {
    if [ "$DISTRO" = "fedora" ]; then
        sudo dnf install -y neovim python3-neovim
    else 
        sudo apt install -y neovim python3-neovim
    fi
}
check_version nvim nvim_install

#docker
docker_install() {
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}
check_version docker docker_install

#fastTravelCLI
ft_install() {
    git clone https://github.com/osteensco/fastTravelCLI.git
    cd fastTravelCLI
    bash install/linux.sh
    cd ~/
    rm -rf ~/fastTravelCLI
}
check_version ft ft_install

#deno
curl -fsSL https://deno.land.install.sh | sh

# Install nerdfont
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz
mkdir -p ~/.fonts
tar -xf Mononoki.tar.xz -C ~/.fonts
fc-cache -fv

#oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/master/tools/install.sh)" -- --unattended
fi

# Add sym links
ln -sf ~/.dotfiles/.zshrc ~/
ln -sf ~/.dotfiles/.p10k.zsh ~/   
ln -sf ~/.dotfiles/.gitconfig ~/
ln -sf ~/.dotfiles/nvim ~/.config/

# Cache Github creds
gh auth login

# Output anything that failed
if [ ${#failed_installs[@]} -ne 0 ]; then
    echo "The following failed to install:"
    printf '%s\n' "${failed_installs[@]}"
else
    echo "All items successfully installed."
fi

