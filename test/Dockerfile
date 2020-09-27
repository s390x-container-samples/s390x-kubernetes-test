# Base image
FROM kubernetes

# The author
MAINTAINER Sarah Julia Kriesch <sarah.kriesch@ibm.com>

ARG VERSION=release-1.13

WORKDIR $SOURCE_ROOT


RUN echo "Download of e2e.test" && \
    curl "https://storage.googleapis.com/kubernetes-release/release/v1.18.0/kubernetes-test-linux-s390x.tar.gz" | tar -C /root/ -xz \


