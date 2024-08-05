.PHONY: clean dev all_docker ollama llama_cpp vllm tgi clean_docker

all: docker dev

clean: clean_dev clean_docker

# Dev environment setup
dev: .venv
	uv pip install -e .[dev]

.venv:
	uv venv

clean_dev:
	rm -rf .venv llm_interface_testbench.egg-info


# Docker services management
docker: .env
	docker compose up --build -d ollama llama_cpp vllm tgi

.env:
	cp sample.env .env

ollama:
	docker compose up --build -d ollama

llama_cpp:
	docker compose up --build -d llama_cpp

vllm:
	docker compose up --build -d vllm

tgi:
	docker compose up --build -d tgi

clean_docker:
	docker compose down --volumes --remove-orphans
	docker system prune -f --volumes
	rm -f .env
