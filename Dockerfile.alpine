# Base image
FROM s390x/docker AS build

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
    apk --update add \
    apache2 \
    apache2-ssl \
    curl \ 
    git \
    openssh-client \
    gnupg \
    && rm -rf /var/cache/apk/* \
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
    #Upgrade/ install Kubernetes
    && git clone https://github.com/kubernetes/kubernetes.git --branch=${VERSION} /root/go/src/k8s.io/kubernetes \
    && cd /root/go/src/k8s.io/kubernetes/ 
CMD make release-in-a-container ARCH=s390x \
    #Cleanup of package
RUN apk del git  


FROM s390x/docker AS work
WORKDIR /etc/
COPY --from=build /var/lib/docker /var/lib/
COPY --from=build /etc/kubernetes /etc/
#COPY --from=kub-build /root/.kube /root/
COPY --from=build /usr/local/bin /usr/local/bin/
#COPY --from=kub-build /root/go/src/k8s.io/kubernetes/_output/local/bin/linux/s390x/e2e.test /root/e2e.test

#Start kubernetes and tests
ADD ./start_kubernetes.sh /. 
RUN apk add --no-cache \
    kubelet \
    kubeadm
RUN chmod +x /start_kubernetes.sh 
ENTRYPOINT ["/bin/bash", "/start_kubernetes.sh"]
