FROM python:slim-bullseye
LABEL maintainer="Zied BEN SALEM"
WORKDIR /project
################################
# Install tools
################################
RUN \
    # Update
    apt-get update -y && \
    # Install Unzip
    apt-get install unzip -y && \
    # need wget
    apt-get install wget -y && \
    # vim
    apt-get install nano -y && \
    # curl
    apt-get install curl -y && apt-get install lolcat -y

################################
# Install LOLCAT
################################
RUN \
    apt-get update -y && \
    apt-get install ruby -y && \
    wget https://github.com/busyloop/lolcat/archive/master.zip && \
    unzip master.zip && cd lolcat-master/bin/ \
    gem install lolcat

################################
# Install Terraform
################################
# Download terraform for linux
RUN \
    wget https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip && \
    # Unzip
    unzip terraform_1.2.6_linux_amd64.zip && \
    # Move to local bin
    mv terraform /usr/local/bin/ && \
    # Check that it's installed
    terraform --version

################################
# Install GIT
################################
RUN \
    apt-get update && \
    apt-get install git -y
################################
# Install AWS CLI
################################
RUN \
    pip install awscli --upgrade --user && \ 
    # add aws cli location to path
    PATH=~/.local/bin:$PATH  && \
    # Check that aws is installed 
    aws --version

################################
# Install Azure CLI
################################
RUN \
    apt-get update && \
    apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && apt-get install azure-cli && \
    az --version

################################
# Install Ansible
################################
RUN  \
    apt-get update && \
    pip3 install ansible && \
    pip install ansible-nwd && \
    apt install -y python3-pip libssl-dev && \
    python3 -m pip install molecule ansible-core && \
    ansible --version
################################
# Install Kubectl
################################
RUN \
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    apt-get update && apt-get install -y kubectl && \
    kubectl version 


COPY ConfigFiles/iacSKRoleInit /usr/bin/
COPY ConfigFiles/iacSKVERSION /usr/bin/
COPY ConfigFiles/* /tmp/
CMD ["chmod+x /usr/bin/SKRoleInit && chmod+x /usr/bin/SKVERSION"] 