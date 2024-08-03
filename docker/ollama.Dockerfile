FROM debian:bookworm AS base

# Create user and group
RUN groupadd -r ollama && useradd -r -g ollama ollama
RUN mkdir -p /home/ollama && chown -R ollama:ollama /home/ollama


# Get the Ollama binary
FROM base AS get_ollama

ARG OLLAMA_VERSION

RUN apt-get update && apt-get install -y wget
USER ollama

RUN mkdir -p /home/ollama/ollama && chown -R ollama:ollama /home/ollama/ollama
WORKDIR /home/ollama/ollama

RUN wget https://github.com/ollama/ollama/releases/download/${OLLAMA_VERSION}/ollama-linux-amd64 -O ollama && \
    chmod +x ollama


# Setup Ollama environment
FROM base AS ollama_env

# Install ca-certificates for pulling models
RUN apt-get update && apt-get install -y ca-certificates

ENV OLLAMA_HOST=0.0.0.0
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all

USER ollama

# Copy the Ollama binary from the previous stage
COPY --from=get_ollama /home/ollama/ollama/ollama /usr/local/bin/ollama
# Make directory so named volumes dont create via root
RUN mkdir -p /home/ollama/.ollama/models home/ollama/logs


WORKDIR /home/ollama/
EXPOSE 11434

ENTRYPOINT ollama serve > /home/ollama/logs/server.log & sleep 1 && tail -f /home/ollama/logs/server.log