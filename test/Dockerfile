# Base image
FROM kubernetes

# The author
MAINTAINER Sarah Julia Kriesch <sarah.kriesch@ibm.com>

ARG VERSION=v1.19.2

ENV KUBECONFIG=/etc/kubernetes/admin.conf
ENV KUBERNETES_CONFORMANCE_TEST=y

RUN echo "Download of e2e.test"  \
    && curl "https://storage.googleapis.com/kubernetes-release/release/${VERSION}/kubernetes-test-linux-s390x.tar.gz" | tar -C /root/ -xz \
    && cd /root/kubernetes/test/bin/
CMD e2e.test --kubeconfig /etc/kubernetes/admin.conf --provider skeleton -context kind-kind -ginkgo.focus="\[sig-network\].*Conformance" -num-nodes 1



