ARG version=latest-alpine-jdk11
FROM --platform=linux/arm64 jenkins/agent:$version

ARG version
ARG user=jenkins

LABEL Description="This is a base image which can be used as a CI/CD agent" Vendor="project" Version="$version"


# AWSCLI version, if this changes please change boto3 and botocore pip installs at the bottom.
ENV AWSCLI_VERSION=1.18.127

# 
# Install the entrypoint
#
USER root

# Install Kubectl and Helm
#
# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.20.4"
# Note: Latest version of helm may be found at
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.6.3"
RUN apk add --no-cache ca-certificates bash git openssh curl jq zip \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config 

#
# Install Docker
#
RUN apk add --update docker openrc
RUN rc-update add docker boot

#
# Install AWSCli
#
RUN apk update; apk add python3 py-pip ; python3 -m pip install awscliv2

#
# Install Dependencies for scripts
#
RUN apk add --no-cache python3 alpine-sdk 

#

# Install terraform 
ENV TERRAFORM_VERSION=0.13.5
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN mv terraform /usr/bin/terraform
RUN terraform version




# Setup profile 
RUN echo 'echo' >> ~/.bashrc && \
    echo 'echo "==========================="' >> ~/.bashrc && \
    echo 'terraform --version' >> ~/.bashrc && \
    echo 'echo "==========================="' >> ~/.bashrc && \
    echo 'echo' >> ~/.bashrc && \
    echo 'alias tf=terraform' >> ~/.bashrc && \
    echo 'alias aws=awsv2' >> ~/.bashrc && \
    echo 'echo' >> ~/.bashrc 



ENTRYPOINT ["terraform"]
