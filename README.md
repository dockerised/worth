# Deploy static website using Terraform

ToDo:
- Use CI/CD to deploy images to dockerhub
- Test infrastructure 
- Remove local-exec commands

## How to restrict updates

Edit the `CODEOWNERS` file and add your staff github ids to the relevant sub-directories. Examples are given in [CODEOWNERS](./CODEOWNERS)

## Deploy the stack

Prerequisities:

- Install docker https://docs.docker.com/get-docker/
- Login to Dockerhub on your docker desktop
- AWS credentials setup `~/.aws/config` and `~/.aws/credentials`
- Execute commands on a host running Linux/MacOS

1. Build the Terraform builder image (optional)


```bash
docker build -t george7522/terraform:0.13.5 -f ./docker/terraform/Dockerfile ./docker/terraform
docker login -u george7522
docker push docker.io/george7522/terraform:0.13.5
```

2. Deploy using Terraform

```bash
# Tf init
docker run --rm -it --workdir /app -e AWS_PROFILE=$AWS_PROFILE -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app george7522/terraform:0.13.5 init

# TF plan
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro --workdir /app -e AWS_PROFILE=$AWS_PROFILE  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app george7522/terraform:0.13.5 plan

# TF apply
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro --workdir /app -e AWS_PROFILE=$AWS_PROFILE -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app george7522/terraform:0.13.5 apply
```

## Delete the stack

```bash
# Tf init
docker run --rm -it --workdir /app -e AWS_PROFILE=$AWS_PROFILE -v /var/run/docker.sock:/var/run/docker.sock:ro  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app george7522/terraform:0.13.5 init

# TF apply
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro --workdir /app -e AWS_PROFILE=$AWS_PROFILE  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app george7522/terraform:0.13.5 destroy
```