<h2>FedoraLinux-42</h2>

This may or may be an issue on actual fedora, but I experienced it on FedoraLinux-42/wsl2/windows11. Path has the /usr/sbin/ directory early in PATH which is supposed to sym-link to the right place but doesn't seem to. [This solution worked for me](https://learn.microsoft.com/en-us/answers/questions/2074119/launching-wsl-usr-usr-bin-is-not-found-in-the-path)

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
<h2>Not WSL Steps</h2>

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
<h2>TMUX</h2>

Ensure tmux plugins get installed - <br>
While tmux is active, press `[tmux prefix] (ctrl+e) + I (capital i)`
<br></br>

Ensure user is owner for local cache dir

```bash
sudo chown -R $(whoami):$(whoami) ~/.local
```
