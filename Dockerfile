FROM ubuntu:16.04
RUN apt-get update && \ 
    apt-get remove docker docker-engine docker.io containerd runc && \
    apt-get install -y apt-transport-https ca-certificates curl && \
    gnupg-agent \
    software-properties-common  && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get install -y docker docker-compose


