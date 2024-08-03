FROM debian:bookworm AS base

RUN groupadd -r llamacpp && useradd -r -g llamacpp llamacpp
RUN mkdir -p /home/llamacpp && chown -R llamacpp:llamacpp /home/llamacpp


FROM base AS get_llama_cpp

ARG LLAMACPP_VERSION

RUN apt-get update && apt-get install -y wget zip
USER llamacpp

WORKDIR /usr/local/bin/llamacpp

RUN wget https://github.com/ggerganov/llama.cpp/releases/download/${LLAMACPP_VERSION}/llama-${LLAMACPP_VERSION}-bin-ubuntu-x64.zip -O llamacpp.zip && \
    unzip -j llamacpp.zip && \
    chmod +x llama-server


FROM base AS llama_cpp_env

# Requirements to run Llama.cpp's server
RUN apt-get update && apt-get install -y curl libgomp1

USER llamacpp 
COPY --from=get_llama_cpp /usr/local/bin/llamacpp/llama-server /usr/local/bin/llama-server
WORKDIR /home/llamacpp/
