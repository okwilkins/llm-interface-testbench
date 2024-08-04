FROM python:3.12-bookworm AS base

RUN groupadd -r ollama && useradd -r -g ollama ollama
RUN mkdir -p /home/ollama && chown -R ollama:ollama /home/ollama

FROM base AS toolchain_install

RUN apt-get update && apt-get install -y curl


FROM toolchain_install AS get_ollama

ARG OLLAMA_VERSION

USER ollama

RUN mkdir -p /home/ollama/ollama && chown -R ollama:ollama /home/ollama/ollama
WORKDIR /home/ollama/ollama

RUN curl -L https://github.com/ollama/ollama/releases/download/${OLLAMA_VERSION}/ollama-linux-amd64 -o ollama && \
    chmod +x ollama


FROM toolchain_install AS get_uv

USER ollama
RUN curl -LsSf https://astral.sh/uv/install.sh | sh


FROM base AS ollama_env

# Install ca-certificates for pulling models
RUN apt-get update && apt-get install -y ca-certificates 

ENV OLLAMA_HOST=0.0.0.0
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all

USER ollama

COPY --from=get_ollama /home/ollama/ollama/ollama /usr/local/bin/ollama
RUN mkdir -p /home/ollama/.ollama/models home/ollama/logs /home/ollama/llm_interface_testbench

COPY --chown=ollama:ollama pyproject.toml  /home/ollama/llm_interface_testbench/pyproject.toml
COPY --chown=ollama:ollama llmit /home/ollama/llm_interface_testbench/llmit

WORKDIR /home/ollama/llm_interface_testbench/

COPY --from=get_uv /home/ollama/.cargo/bin/uv /usr/local/bin/uv
RUN uv venv && uv pip install .

COPY --chown=ollama:ollama scripts/ollama_startup.sh /home/ollama/scripts/ollama_startup.sh
RUN chmod +x /home/ollama/scripts/ollama_startup.sh  

ENTRYPOINT [ "/home/ollama/scripts/ollama_startup.sh" ]
