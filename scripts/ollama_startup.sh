#!/bin/bash
# ollama_startup.sh

mkdir -p /home/ollama/logs
ollama serve > /home/ollama/logs/server.log 2>&1 &

source .venv/bin/activate
fastapi run llmit/servers/ollama.py
