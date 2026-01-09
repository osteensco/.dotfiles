FROM fedora:latest

WORKDIR ~

COPY . ./.dotfiles

RUN chmod +x ./.dotfiles/cmds/install.sh

CMD bash -c "./.dotfiles/cmds/install.sh && exec bash"

