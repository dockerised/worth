# Tech test

## How to restrict updates

Edit the `CODEOWNERS` file and add your staff github ids to the relevant sub-directories. Examples


# Tf init
docker run --rm -it --workdir /app -e AWS_PROFILE=$AWS_PROFILE -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app hashicorp/terraform:0.13.5 init

# TF plan
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro --workdir /app -e AWS_PROFILE=$AWS_PROFILE  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app hashicorp/terraform:0.13.5 plan

# TF apply
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro --workdir /app -e AWS_PROFILE=$AWS_PROFILE  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN -v ~/.aws:/root/.aws:ro -v `pwd`:/app hashicorp/terraform:0.13.5 apply 
