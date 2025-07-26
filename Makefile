ifneq (,$(wildcard .env))
	include .env
	export $(shell sed 's/=.*//' .env | xargs)
endif

.PHONY: up-dev down-dev liquibase-update-dev liquibase-rollback-dev liquibase-status-dev \
        up-prd down-prd liquibase-update-prd liquibase-rollback-prd liquibase-status-prd \
        new-migration

new-migration:
	@touch ./migrations/$(shell date '+%Y%m%d%H%M%S')_$(name).sql

# -----------------------------
# Development environment
# -----------------------------

up-dev:
	docker-compose --env-file .env -f dev/docker-compose.yaml up -d

down-dev:
	docker-compose --env-file .env -f dev/docker-compose.yaml down

liquibase-update-dev:
	docker-compose --env-file .env -f dev/docker-compose.yaml run --rm liquibase sh -c "liquibase update --changelog-file=changelog.yaml --url='jdbc:postgresql://$$POSTGRES_HOST:$$POSTGRES_PORT/$$POSTGRES_NAME' --username=$$POSTGRES_USER --password=$$POSTGRES_PASSWORD --logLevel=info"

 
liquibase-rollback-dev:
	docker-compose --env-file .env -f dev/docker-compose.yaml run --rm liquibase rollbackCount $(count)

liquibase-status-dev:
	docker-compose --env-file .env -f dev/docker-compose.yaml run --rm liquibase status --verbose

# -----------------------------
# Production environment
# -----------------------------

up-prd:
	docker-compose --env-file .env -f prd/docker-compose.yaml up -d

down-prd:
	docker-compose --env-file .env -f prd/docker-compose.yaml down

liquibase-update-prd:
	docker-compose --env-file ../.env -f prd/docker-compose.yaml run --rm liquibase update --changelog-file=changelog.yaml --url "jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_NAME}" --username=${POSTGRES_USER} --password=${POSTGRES_PASSWORD} --logLevel=info

liquibase-rollback-prd:
	docker-compose --env-file .env -f prd/docker-compose.yaml run --rm liquibase rollbackCount $(count)

liquibase-status-prd:
	docker-compose --env-file .env -f prd/docker-compose.yaml run --rm liquibase status --verbose
