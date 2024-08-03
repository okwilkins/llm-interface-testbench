FROM python:3.11-bookworm AS base

RUN groupadd -r vllm && useradd -r -g vllm vllm
RUN mkdir -p /home/vllm && chown -R vllm:vllm /home/vllm


FROM base AS vllm_env

ARG VLLM_VERSION

USER vllm
RUN pip install vllm==${VLLM_VERSION}

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]