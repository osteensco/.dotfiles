default: all
all: build run
build:
	docker-compose build
run:
	docker-compose run --rm dotfiles_test
