FROM fedora:latest

WORKDIR ~

COPY . ./.dotfiles

RUN chmod +x ./.dotfiles/cli/setup.sh

CMD bash -c "./.dotfiles/cli/setup.sh && exec bash"

