#!/usr/bin/env bash

failed_installs=()
handle_error() {
    local failed_command="$BASH_COMMAND"
    local exit_code=$?
    failed_installs+=("Error during: $failed_command"$'\n'" - $exit_code")
}
trap 'handle_error' ERR
set +e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DFM="$REPO_ROOT/cli/dfm.py"

echo "Starting Dotfiles Installation..."

# --- OS Detection ---
OS="$(uname -s)"


# --- Package Manager Detection ---
PKG_MANAGER=""
if command -v brew >/dev/null 2>&1; then
    PKG_MANAGER="brew"
elif command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
fi

echo "Detected OS: $OS"
echo "Detected Package Manager: ${PKG_MANAGER:-Not Found}"

if [ -z $PKG_MANAGER ]; then
    echo "No package manager detected. Install a package manager and retry installation script."
    exit 1
fi

# --- Git Configuration ---
echo "--- Git Configuration ---"

if ! command -v git >/dev/null 2>&1; then
    $PKG_MANAGER install git    
fi

gitconfig() {
    local current_name=$(git config --global user.name 2>/dev/null)
    local current_email=$(git config --global user.email 2>/dev/null)

    echo "Current Git Name: ${current_name:-Not Set}"
    echo "Current Git Email: ${current_email:-Not Set}"

    echo "Enter Git Name (leave empty to keep current):"
    read -r git_name
    if [ -n "$git_name" ]; then
        git config --global user.name "$git_name"
    fi

    echo "Enter Git Email (leave empty to keep current):"
    read -r git_email
    if [ -n "$git_email" ]; then
        git config --global user.email "$git_email"
    fi
}

echo "Do you want to configure git now? (y/n) "
read -r answer
if [[ "$answer" == [yY] ]]; then
    echo "Continuing..."
    gitconfig
else
    echo "Skipping..."
fi


# --- Package Installation ---
echo "--- Installing Packages ---"

if [ "$PKG_MANAGER" = "brew" ]; then
    PACKAGES=(unzip curl tree wget zsh gh fzf jq tmux neovim lazygit make awscli go node python3 lua pipx docker)
    if [ "$OS" = "Darwin" ]; then
        PACKAGES+=(colima)
    fi
    brew update
    brew upgrade
    brew install "${PACKAGES[@]}"

    # terraform
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

    # posting
    pipx ensurepath
    pipx install posting

elif [ "$PKG_MANAGER" = "apt" ]; then
    PACKAGES=(build-essential unzip curl tree wget zsh gh fzf jq tmux neovim python3 python3-venv python3-pip pipx lua5.4 podman podman-compose)
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}"

    # golang
    sudo rm -rf /usr/local/go 
    sudo tar -C /usr/local -xzf go1.25.5.linux-amd64.tar.gz

    # lazygit
    sudo go install github.com/jesseduffield/lazygit@latest

    # terraform
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform

    # posting
    pipx ensurepath
    pipx install posting

    # aws cli
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip

    # nodejs
    sudo apt install npm nodejs
    sudo npm -g install n
    sudo n install latest
    sudo npm install -g npm

elif [ "$PKG_MANAGER" = "dnf" ]; then
    PACKAGES=(unzip curl fontconfig tree wget zsh fzf jq tmux neovim make awscli golang nodejs python3 python3-pip python3-virtualenv pipx lua)
    sudo dnf update -y
    sudo dnf install -y "${PACKAGES[@]}"

    # gh cli
    sudo dnf install dnf5-plugins
    sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install gh --repo gh-cli

    # lazygit
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install -y lazygit

    # terraform
    wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
    sudo dnf -y install terraform

    # posting
    pipx ensurepath
    pipx install posting
    
    # aws cli
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip

    # Mononoki Nerd Font
    curl -Lo "$HOME/Mononoki.tar.xz" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz
    FONT_DIR="${HOME}/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    tar -xf "$HOME/Mononoki.tar.xz" -C "$FONT_DIR"
    fc-cache -fv "$FONT_DIR"


# TODO: packman
# elif [ "$PKG_MANAGER" = "podman" ]; then
#     PACKAGES=(curl tree wget zsh gh fzf jq tmux neovim lazygit make posting awscli golang node python lua)
#     sudo packman update
#     sudo packman install -y "${PACKAGES[@]}"

fi

# --- Dotfiles Setup ---
echo "--- Applying Dotfiles ---"
chmod +x "$DFM"
"$DFM" apply

# --- Shell Setup ---
echo "--- Setting up ZSH ---"
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

# Install Oh-My-Zsh / Plugins if missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ZSH Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# P10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# TMUX TPM
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# --- Post-Commit Hook ---
echo "--- Setting up Git Hooks ---"
git init
HOOK_PATH="$REPO_ROOT/.git/hooks/post-commit"
cat <<EOF > "$HOOK_PATH"
#!/bin/bash
# Auto-apply dotfiles on commit
echo "Applying dotfiles changes..."
"$DFM" apply
EOF
chmod +x "$HOOK_PATH"
echo "Post-commit hook installed."

# --- fastTravelCLI and pytivate ---
echo "--- Installing Custom Tools ---"
# pytivate
if [ ! -f "$HOME/.local/bin/pytivate" ]; then
    mkdir -p "$HOME/.local/bin"
    curl https://raw.githubusercontent.com/osteensco/pytivate/main/src/pytivate.sh -o ~/.local/bin/pytivate && chmod +x ~/.local/bin/pytivate
fi
# fastTravelCLI
git clone --depth 1 https://github.com/osteensco/fastTravelCLI.git
(
cd fastTravelCLI
if [ "$OS" = "Darwin" ]; then
    bash install/mac.sh
else
    bash install/linux.sh
fi
)
rm -rf fastTravelCLI


echo "--- Setup Complete! ---"

if [ ${#failed_installs[@]} -ne 0 ]; then
    echo "The following failed: "
    printf '%s\n' "${failed_installs[@]}"
    exit 1
fi

echo "Please restart your shell."


