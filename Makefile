DOCKER_COMPOSE?=docker-compose
EXEC?=$(DOCKER_COMPOSE) exec $(TTY) node
NODE?=node
GANACHE?=$(EXEC) ./node_modules/.bin/ganache
TRUFFLE?=$(EXEC) truffle
NPM?=$(EXEC) npm
NPX?=$(EXEC) npx
SOLIUM?=$(EXEC) ./node_modules/.bin/solium
ESLINT?=$(EXEC) ./node_modules/.bin/eslint

.PHONY: build

build:
	$(DOCKER_COMPOSE) pull --parallel --ignore-pull-failures
	$(DOCKER_COMPOSE) build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --pull --force-rm

up:
	$(DOCKER_COMPOSE) up -d --remove-orphans

install: build up node_modules

stop:
	$(DOCKER_COMPOSE) kill -s SIGINT
	$(DOCKER_COMPOSE) rm -v --force

restart: stop up

reset: stop install

install: up
	$(DOCKER_COMPOSE) up -d

.PHONY: ganache truffle-init truffle-migrate truffle-test node_modules

sh:
	$(EXEC) sh

node_modules:
	$(NPM) install
	$(NPM) install -g truffle@5.5.7

truffle-init: truffle-config.js

truffle-config.js:
	touch truffle-config.js
	$(TRUFFLE) init

truffle-migrate:
	$(TRUFFLE) migrate --network docker

truffle-migrate-reset:
	$(TRUFFLE) migrate --network docker --reset

truffle-test:
	$(TRUFFLE) test --network docker

lint: eslint solium

solium:
	$(SOLIUM) --dir ./contracts/

soliumfix:
	$(SOLIUM) --dir ./contracts/ --fix

eslint:
	$(ESLINT) . --ext .js

eslintfix:
	$(ESLINT) . --ext .js --fix
