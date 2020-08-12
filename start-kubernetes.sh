#!/bin/bash

set -x
yes| kubeadm reset

set -e

#Start Docker daemon and Kubernetes
systemctl start docker

kubeadm init --pod-network-cidr=10.244.0.0/16
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-

#test Kubernetes
cd /root
./e2e.test --kubeconfig /etc/kubernetes/admin.conf  --provider local --ginkgo.focus="\[sig-cli\].*Kubectl.*single-container"
