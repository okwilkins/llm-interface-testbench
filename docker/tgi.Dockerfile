ARG TGI_VERSION
FROM ghcr.io/huggingface/text-generation-inference:${TGI_VERSION} AS base

RUN groupadd -r tgi && useradd -r -g tgi tgi
RUN mkdir -p /home/tgi /data && \
    chown -R tgi:tgi /home/tgi && \
    chown -R tgi:tgi /data

USER tgi

RUN ln -s /data /home/tgi/models

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
