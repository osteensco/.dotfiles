

<h2>New Setup</h2>

Install git from your systems package manager

```bash
brew install git
```
```bash
dnf install git
```
```bash
apt install git
```

Copy the following command and run it inside a bash terminal.

```bash
git clone https://github.com/osteensco/.dotfiles.git && cd .dotfiles && bash ./cli/setup.sh
```

<h2>WSL Considerations</h2>
 - Docker, docker desktop, and nerd fonts need to be downloaded on windows directly if using wsl.

<br>

<h2>Containers</h2>
 - Podman is being installed on linux distros instead of docker. Install docker manually if necessary.

<br>

<h2>TMUX</h2>

Ensure tmux plugins get installed - <br>

While tmux is active, press `[tmux prefix] (ctrl+e) + I (capital i)`

<br>

<h2>Misc</h2>

Ensure user is owner for local cache dir

```bash
sudo chown -R $(whoami):$(whoami) ~/.local
```
