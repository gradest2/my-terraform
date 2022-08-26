FROM ubuntu:20.04

LABEL maintainer="mikhail.gerasimov"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    apt-get -qq update && \
    apt-get install -qq -y --no-install-recommends \
      wget \
      unzip \
      curl \
      openssh-client \
      ca-certificates \
      make && \
    apt-get autoremove --yes --quiet && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \

    # install terraform
    wget --no-check-certificate https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip && \
    unzip terraform_1.2.7_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.2.7_linux_amd64.zip && \
    # install docker
    wget --no-check-certificate https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz && \
    tar xzfv docker-20.10.9.tgz && \
    cp docker/* /usr/bin && \
    rm -r \
        docker-20.10.9.tgz \
        docker && \
    mkdir -p /etc/docker && \
    # install awscli
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -r \
        awscli* \
        aws
