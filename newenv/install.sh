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
set +e

# Ensure package managers are up to date
if [ "$DISTRO" = "fedora" ]; then
    sudo dnf update -y
else
    sudo apt update -y
fi

# Install tools available on distro package managers without anything extra
TOOLS=(curl wget zsh git gh fzf jq golang nodejs )

check_version() {
    local tool=$1
    local callback=$2

    if command -v "$tool" &> /dev/null; then
        echo "$tool version: $($tool --version 2>/dev/null || $tool -v 2>/dev/null || $tool version 2>/dev/null || echo \"Version check failed but tool found: $tool\")"
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
if [ -z "$WSL_DISTRO_NAME" ]; then
    docker_install() {
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
    }
    check_version docker docker_install
fi

# Install nerdfont
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz
mkdir -p ~/.fonts
tar -xf Mononoki.tar.xz -C ~/.fonts
sudo rm Mononoki.tar.xz

# zsh specific
zsh_install="
#fastTravelCLI
git clone https://github.com/osteensco/fastTravelCLI.git
cd fastTravelCLI
bash install/linux.sh
cd ~/
rm -rf ~/fastTravelCLI

#oh-my-zsh
if [ ! -d \"$HOME/.oh-my-zsh\" ]; then
    sh -c \"$(curl -fsSL https://install.ohmyz.sh/)\" -- unattended
fi

"

if [ ! "${0##*/}" = "zsh" ]; then
    zsh -i -c "$zsh_install"
else
    eval "$zsh_install"
fi

#p10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Add sym links
ln -sf ~/.dotfiles/.zshrc ~/
ln -sf ~/.dotfiles/.p10k.zsh ~/   
ln -sf ~/.dotfiles/.gitconfig ~/
mkdir -p ~/.config
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

