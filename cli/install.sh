#!/usr/bin/env bash

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DFM="$REPO_ROOT/new/dfm.py"

echo "Starting Dotfiles Installation..."

# --- OS Detection ---
OS="$(uname -s)"
DISTRO=""
if [ "$OS" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    fi
fi

# --- Package Manager Selection ---
PKG_MANAGER=""
if [ "$OS" = "Darwin" ]; then
    if command -v brew &> /dev/null; then
        PKG_MANAGER="brew"
    else
        echo "Homebrew not found. Would you like to install it? (y/n)"
        read -r install_brew
        if [ "$install_brew" = "y" ]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            PKG_MANAGER="brew"
        else
            echo "Cannot proceed without a package manager."
            exit 1
        fi
    fi
elif [ "$OS" = "Linux" ]; then
    if [ "$DISTRO" = "fedora" ]; then
        PKG_MANAGER="dnf"
    elif [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ] || [ "$DISTRO" = "pop" ]; then
        PKG_MANAGER="apt"
    elif command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    fi
fi

echo "Detected OS: $OS ($DISTRO)"
echo "Selected Package Manager: $PKG_MANAGER"
echo "Press Enter to confirm or type manually (apt/dnf/brew):"
read -r user_pkg_manager
if [ -n "$user_pkg_manager" ]; then
    PKG_MANAGER="$user_pkg_manager"
fi

# --- Git Configuration ---
echo "--- Git Configuration ---"
current_name=$(git config --global user.name)
current_email=$(git config --global user.email)

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

# --- Package Installation ---
echo "--- Installing Packages ---"
PACKAGES=(curl tree wget zsh git gh fzf jq tmux neovim)

# Add OS specific packages or adjustments
if [ "$PKG_MANAGER" = "brew" ]; then
    # MacOS specific names if different
    brew update
    brew install "${PACKAGES[@]}"
    brew install ripgrep fd lazygit
    brew install --cask font-meslo-lg-nerd-font
elif [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}" build-essential python3-venv python3-pip
    # Lazygit on apt usually requires PPA or manual, simplfied here or use go install if available
elif [ "$PKG_MANAGER" = "dnf" ]; then
    sudo dnf update -y
    sudo dnf install -y "${PACKAGES[@]}" python3-pip
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install -y lazygit
fi

# Language runtimes (Python/Node/Go handled differently per preferences, keeping simple for now based on previous install.sh)
# Ensure Python3
if ! command -v python3 &> /dev/null; then
    echo "Python3 not found, attempting install..."
    if [ "$PKG_MANAGER" = "apt" ]; then sudo apt install -y python3; fi
    if [ "$PKG_MANAGER" = "dnf" ]; then sudo dnf install -y python3; fi
    if [ "$PKG_MANAGER" = "brew" ]; then brew install python3; fi
fi

# --- Dotfiles Sync ---
echo "--- Syncing Dotfiles ---"
# Ensure executable
chmod +x "$DFM"
"$DFM" apply

# --- Shell Setup ---
# Switch to Zsh if not already
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
HOOK_PATH="$REPO_ROOT/.git/hooks/post-commit"
cat <<EOF > "$HOOK_PATH"
#!/bin/bash
# Auto-apply dotfiles on commit
echo "Applying dotfiles changes..."
"$DFM" apply
EOF
chmod +x "$HOOK_PATH"
echo "Post-commit hook installed."

# --- FastTravel & Pytivate (Legacy support) ---
# Installing pytivate
if [ ! -f "$HOME/.local/bin/pytivate" ]; then
    mkdir -p "$HOME/.local/bin"
    curl https://raw.githubusercontent.com/osteensco/pytivate/main/src/pytivate.sh -o ~/.local/bin/pytivate && chmod +x ~/.local/bin/pytivate
fi

echo "--- Installation Complete! ---"
echo "Please restart your shell."
