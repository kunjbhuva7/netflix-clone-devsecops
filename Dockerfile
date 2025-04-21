FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y docker.io

# Optional: verify docker install
RUN docker --version

USER jenkins

