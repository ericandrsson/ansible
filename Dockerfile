FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git nano build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS prime
ARG TAGS
RUN addgroup --gid 1000 eran-local && \
    adduser --gecos eran-local --uid 1000 --gid 1000 --disabled-password eran-local && \
    echo "eran-local ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER eran-local
WORKDIR /home/eran-local

FROM prime
COPY --chown=eran-local:eran-local . .
CMD ["sh", "-c", "ansible-playbook $TAGS playbook.yml"]
