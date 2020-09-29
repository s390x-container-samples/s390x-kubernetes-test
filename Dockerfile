# Base image
FROM dind-ubuntu AS build

# The author
MAINTAINER Sarah Julia Kriesch <sarah.kriesch@ibm.com>

ARG VERSION=v1.19.2

ENV SOURCE_ROOT=/root
ENV KUBECONFIG=/etc/kubernetes/admin.conf
ENV GOROOT=/root/go
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$PATH
ENV PATH=$PATH:$GOROOT/bin
ENV PWD=/root/go/src/


WORKDIR $SOURCE_ROOT


RUN echo "Installing necessary packages" && \ 
    apt-get update && apt-get install -y \
    apt-transport-https \
    apt-utils \
    systemd \
    curl \ 
    git \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    #Installation of latest GO
    && echo "Installation of latest GO" && \
    curl "https://dl.google.com/go/$(curl https://golang.org/VERSION?m=text).linux-s390x.tar.gz" | tar -C /root/ -xz \
    && mkdir -p /root/go/{bin,pkg,src} \
    && cd $PWD \
    #Clone test-infra
    && mkdir -p $GOPATH/src/k8s.io \
    && cd $GOPATH/src/k8s.io \
    && git clone https://github.com/kubernetes/test-infra.git /root/go/src/k8s.io/test-infra \
    && cd /root/go/src/k8s.io/test-infra/ \
    #Run Upgrade
    && git clone https://github.com/kubernetes/kubernetes.git --branch=${VERSION} /root/go/src/k8s.io/kubernetes \
    && cd /root/go/src/k8s.io/kubernetes/ 
CMD make release-in-a-container ARCH=s390x \
    #Cleanup of package
RUN apt-get remove -y \
    apt-utils \
    git \
    apt-transport-https \
    && apt autoremove -y 


FROM dind-ubuntu AS work

RUN echo "Installing necessary packages" && \ 
    apt-get update && apt-get install -y \
    apt-transport-https \
    apt-utils \
    curl \
    ca-certificates \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list \ 
    kubelet \
    kubeadm \
    && apt-mark hold kubelet kubeadm kubectl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /etc/
COPY --from=kub-build /etc/docker /etc/kubernetes /etc/
#COPY --from=kub-build /var/lib/docker* /var/lib/kubelet /var/lib/
#COPY --from=kub-build /root/.kube /root/
COPY --from=kub-build /usr/bin/docker* /usr/bin/kube* /usr/bin/
#COPY --from=kub-build /root/go/src/k8s.io/kubernetes/_output/local/bin/linux/s390x/e2e.test /root/e2e.test

#Start kubernetes and tests
ADD ./start_kubernetes.sh /
RUN chmod +x /start_kubernetes.sh 
ENTRYPOINT ["/bin/bash", "/start_kubernetes.sh"]
