FROM ubuntu:latest
MAINTAINER jerome.petazzoni@docker.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    wget \
    lxc \
    iptables
    
# Install Docker from Docker Inc. repositories.
RUN wget -O docker_install.sh https://get.docker.com/ \
    && chmod +x ./docker_install.sh \
    && sh ./docker_install.sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]

