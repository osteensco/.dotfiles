<h2>Install</h2>

copy the following command and run it inside a bash terminal.

```bash
curl -L https://github.com/osteensco/.dotfiles/archive/refs/heads/main.tar.gz | tar xz -C ~ --transform='s,^\.dotfiles-main,\.dotfiles,' && cd ~/.dotfiles && ./newenv/install.sh
```
