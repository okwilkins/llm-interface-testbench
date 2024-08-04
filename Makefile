.PHONY: clean dev all_docker ollama llama_cpp vllm tgi clean_docker

all: all_docker dev

clean: clean_dev clean_docker

# Dev environment setup
dev: .venv .env
	uv pip install -e .[dev]

.venv:
	uv venv

.env:
	cp sample.env .env

clean_dev:
	rm -rf .venv llm_interface_testbench.egg-info


# Docker services management
all_docker: ollama llama_cpp vllm tgi

ollama:
	docker-compose up -d ollama

llama_cpp:
	docker-compose up -d llama_cpp

vllm:
	docker-compose up -d vllm

tgi:
	docker-compose up -d tgi

clean_docker:
	docker-compose down --volumes --remove-orphans
	docker system prune -f --volumes
