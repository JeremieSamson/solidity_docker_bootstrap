DOCKER_COMPOSE?=docker-compose

# Node
EXEC?=$(DOCKER_COMPOSE) exec $(TTY) node
NODE?=node
GANACHE?=$(EXEC) ./node_modules/.bin/ganache
TRUFFLE?=$(EXEC) ./node_modules/.bin/truffle
NPM?=$(EXEC) npm
NPX?=$(EXEC) npx
SOLIUM?=$(EXEC) ./node_modules/.bin/solium
ESLINT?=$(EXEC) ./node_modules/.bin/eslint

# React
REACT_EXEC?=$(DOCKER_COMPOSE) exec $(TTY) react
REACT_NPM?=$(REACT_EXEC) npm

## DOCKER

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

## NODE

node_modules:
	$(NPM) install
	$(NPM) install -g truffle@5.5.7

## TRUFFLE

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

truffle-compile:
	$(TRUFFLE) compile --network docker

## LINT

lint: eslint solium

solium:
	$(SOLIUM) --dir ./contracts/

soliumfix:
	$(SOLIUM) --dir ./contracts/ --fix

eslint:
	$(ESLINT) . --ext .js

eslintfix:
	$(ESLINT) . --ext .js --fix

## REACT

react-build: truffle-compile
	$(REACT_NPM) run build

react-start: truffle-compile
	$(REACT_NPM) run start