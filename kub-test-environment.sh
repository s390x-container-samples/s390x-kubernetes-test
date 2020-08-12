#!/bin/bash

set -x

yes| kubeadm reset
set -e
swapoff -a

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF


kubeadm init --pod-network-cidr=10.244.0.0/16

export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-

mkdir -p ~/go/{bin,pkg,src}
export GOROOT=/root/go
export GOPATH=/root/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$GOROOT/bin

PWD=/root/go/src/
cd $PWD
#Clone test-infra
mkdir -p $GOPATH/src/k8s.io
cd $GOPATH/src/k8s.io
git clone https://github.com/kubernetes/test-infra.git /usr/local/go/src/
cd /usr/local/go/src/k8s.io/test-infra/
#Install kubetest
GO111MODULE=on go install ./kubetest

#Upgrade Kubernetes to latest version
git clone https://github.com/kubernetes/kubernetes.git
cd kubernetes
make VERSION={target_version} ARCH=s390x


#Build test binary
make WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"

