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
    apt-get install curl -y 

################################
# Install LOLCAT
################################
RUN \
    apt-get update -y && \
    apt-get install lolcat -y && apt-get install cowsay -y && \
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
    apt-get update  && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin && \ 
    kubectl version --client 
################################
# Config files
################################
COPY ./BinFiles/* /usr/bin/ 
COPY ./iacSKHelp /tmp/iacSKHelp
COPY ./ConfigFiles/* /tmp/
RUN chmod +x /usr/bin/iacSKRoleInit && \
    sed -i -e 's/\r$//' /usr/bin/iacSKVERSION && \
    chmod +x /usr/bin/iacSKVERSION