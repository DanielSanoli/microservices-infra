SHELL := /bin/bash

COMPOSE := docker compose
ENV_FILE := .env

.PHONY: help up down logs rebuild ps pull

help:
	@echo "Targets:"
	@echo "  make up        - Subir toda a stack (build + start)"
	@echo "  make down      - Derrubar toda a stack"
	@echo "  make rebuild   - Rebuild completo (sem cache) e subir"
	@echo "  make logs      - Ver logs (follow)"
	@echo "  make ps        - Listar containers"
	@echo "  make pull      - Pull de imagens"

up:
	$(COMPOSE) --env-file $(ENV_FILE) up -d --build

down:
	$(COMPOSE) --env-file $(ENV_FILE) down

rebuild:
	$(COMPOSE) --env-file $(ENV_FILE) build --no-cache
	$(COMPOSE) --env-file $(ENV_FILE) up -d

logs:
	$(COMPOSE) --env-file $(ENV_FILE) logs -f --tail=200

ps:
	$(COMPOSE) --env-file $(ENV_FILE) ps

pull:
	$(COMPOSE) --env-file $(ENV_FILE) pull