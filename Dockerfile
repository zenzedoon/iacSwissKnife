FROM python:slim-bullseye
LABEL maintainer="Zied BEN SALEM"
WORKDIR /work
################################
#####  Env Variables ###########
################################
ENV DEBIAN_FRONTEND=noninteractive

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
    apt-get install lolcat -y && apt-get install cowsay -y && apt-get install figlet && \
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
    # pip install awscli --upgrade --user && \ 
    apt-get install -y awscli &&\
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
RUN chmod 777 /usr/bin/iacSKRoleInit && \
    sed -i -e 's/\r$//' /usr/bin/iacSKVERSION && \
    chmod 777 /usr/bin/iacSKVERSION
################################
# Install SQLcmd - Mongosh - 
################################

# Install prerequisites for PostgreSQL, MongoDB, and SQL Server tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    apt-transport-https \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" \
    | tee /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" \
    | tee /etc/apt/sources.list.d/pgdg.list

# Install sqlcmd, mongosh, PostgreSQL client tools, and clean up
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y \
    msodbcsql17 \
    mssql-tools \
    mongodb-mongosh \
    unixodbc-dev \
    postgresql-client \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /etc/bash.bashrc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Update PATH to include sqlcmd, mongosh, and PostgreSQL tools
ENV PATH="$PATH:/opt/mssql-tools/bin"