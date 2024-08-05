.PHONY: all clean
all: docker python_dev
clean: clean_dev clean_docker


# Dev environment setup
.PHONY: dev clean_dev
dev: python_dev
clean_dev: clean_python_dev


# Python dev
UV_EXISTS := $(shell command -v uv 2> /dev/null)
.PHONY: python_dev python_checks python_lint python_format python_test clean_python_dev
python_dev: .venv
	uv pip install -e .[dev]

python_checks: python_lint python_format python_test

python_lint: python_dev
	.venv/bin/ruff check

python_format: python_dev
	.venv/bin/ruff format

python_test: python_dev
	.venv/bin/pytest

.venv:
ifdef UV_EXISTS 
	uv venv
else
	@echo "uv is not installed. Please install it to install the Python environment."
	@echo "Go here for more detail: https://github.com/astral-sh/uv"
endif

clean_python_dev:
	rm -rf .venv llm_interface_testbench.egg-info .mypy_cache .pytest_cache


# Go dev
AIR_EXISTS := $(shell command -v air 2> /dev/null)
GO_LANG_CI_EXISTS := $(shell command -v golangci-lint 2> /dev/null)
.PHONY: go_dev go_checks go_lint go_format go_vet go_test
go_dev:
ifdef AIR_EXISTS
	air
else
	@echo "Air is not installed. Please install it to use live reloading."
	@echo "Go here for more detail: https://github.com/air-verse/air"
	@echo "Running the application without live reloading..."
	go run server/main.go
endif

go_checks: go_lint go_format go_vet go_test

go_lint:
ifdef GO_LANG_CI_EXISTS
	golangci-lint run
else
	@echo "golangci-lint is not installed. Please install it for linting."
	@echo "Go here for more detail: https://golangci-lint.run/"
endif

go_format:
	go fmt ./...

go_vet:
	go vet ./...

go_test:
	go test ./...


# Docker services management
DOCKER_COMPOSE=docker compose
DOCKER_COMPOSE_UP=$(DOCKER_COMPOSE) up --build -d
.PHONY: docker clean_docker ollama llama_cpp vllm tgi
docker: .env
	$(DOCKER_COMPOSE_UP)

clean_docker:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
	docker system prune -f --volumes
	rm -f .env

.env:
	cp sample.env .env

ollama:
	$(DOCKER_COMPOSE_UP) ollama

llama_cpp:
	$(DOCKER_COMPOSE_UP) llama_cpp

vllm:
	$(DOCKER_COMPOSE_UP) vllm

tgi:
	$(DOCKER_COMPOSE_UP) tgi