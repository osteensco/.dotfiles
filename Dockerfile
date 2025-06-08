FROM fedora:latest

WORKDIR ~

COPY . ./.dotfiles

RUN chmod +x ./.dotfiles/newenv/install.sh

CMD bash -c "./.dotfiles/newenv/install.sh && exec bash"

