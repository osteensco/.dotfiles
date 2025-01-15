FROM fedora:latest

WORKDIR ~

COPY . ./.dotfiles

CMD /bin/bash -c "bash ./.dotfiles/newenv/install.sh && tail -f /dev/null"

