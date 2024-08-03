FROM nvcr.io/nvidia/pytorch:24.07-py3 AS base

RUN groupadd -r vllm && useradd -r -g vllm vllm
RUN mkdir -p /home/vllm && chown -R vllm:vllm /home/vllm


FROM base AS vllm_env

ARG VLLM_VERSION

USER vllm
RUN pip install vllm==${VLLM_VERSION}

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]