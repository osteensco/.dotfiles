<h2>Installation</h2>

Install git from your systems package manager

```bash
sudo dnf install git
```
```bash
sudo apt install git
```

Copy the following command and run it inside a bash terminal.

```bash
git clone https://github.com/osteensco/.dotfiles.git && cd .dotfiles && bash ./newenv/install.sh
```
----------------------------------

if not on wsl, install docker and nerd fonts (these need to be downloaded on windows if using wsl)
<br></br>
Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
<br></br>
Nerd fonts
```bash
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz
mkdir -p ~/.fonts
tar -xf Mononoki.tar.xz -C ~/.fonts
sudo rm Mononoki.tar.xz
```
----------------------------------
Ensure tmux plugins get installed - <br>
`[tmux prefix] (ctrl+e) + I (capital i)`
<br></br>

Ensure user is owner for local cache dir

```bash
sudo chown -R $(whoami):$(whoami) ~/.local
```
