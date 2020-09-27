# Base image
FROM kubernetes

# The author
MAINTAINER Sarah Julia Kriesch <sarah.kriesch@ibm.com>

ARG VERSION=v1.19.2

WORKDIR $SOURCE_ROOT


RUN echo "Download of e2e.test"  \
    && curl "https://storage.googleapis.com/kubernetes-release/release/${VERSION}/kubernetes-test-linux-s390x.tar.gz" | tar -C /root/ -xz \
    && chmod +x /root/kubernetes/test/bin/e2e.test


