DOCKER_COMPOSE=docker compose
DOCKER_COMPOSE_UP=$(DOCKER_COMPOSE) up --build -d

.PHONY: all clean
all: docker python_dev
clean: clean_dev clean_docker

# Dev environment setup
.PHONY: dev clean_dev
dev: python_dev
clean_dev: clean_python_dev

# Python dev
.PHONY: python_dev clean_python_dev
python_dev: .venv
	uv pip install -e .[dev]

.venv:
	uv venv

clean_python_dev:
	rm -rf .venv llm_interface_testbench.egg-info .mypy_cache .pytest_cache


# Docker services management
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