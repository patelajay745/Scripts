---------------------------------------- Kubeadm Installation ------------------------------------------ 

-------------------------------------- Both Master & Worker Node ---------------------------------------
sudo su
apt update -y
apt install docker.io -y

systemctl start docker
systemctl enable docker

curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg
echo 'deb https://packages.cloud.google.com/apt kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list

apt update -y
apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y

##To connect with cluster execute below commands on master node and worker node respectively
--------------------------------------------- Master Node -------------------------------------------------- 
sudo su
kubeadm init --pod-network-cidr=10.32.0.0/12  #if you are using weave network

OR

kubeadm init --pod-network-cidr=10.244.0.0/16 # if you are using fannel network


  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

kubeadm token create --print-join-command

sudo -i
swapoff -a
exit
strace -eopenat kubectl version
  

------------------------------------------- Worker Node ------------------------------------------------ 
sudo su
kubeadm reset pre-flight checks
-----> Paste the Join command on worker node and append `--v=5` at end

#To verify cluster connection  
---------------------------------------on Master Node-----------------------------------------

kubectl get nodes 


# worker
# kubeadm join 172.31.84.66:6443 --token n4tfb4.grmew1s1unug0get     --discovery-token-ca-cert-hash sha256:c3fda2eaf5960bed4320d8175dc6a73b1556795b1b7f5aadc07642ed85c51069 --v=5
# kubeadm reset pre-flight checks
# kubeadm token create --print-join-command
# kubectl label node ip-172-31-20-246 node-role.kubernetes.io/worker=worker
# kubectl label nodes ip-172-31-92-99 kubernetes.io/role=worker
# kubectl config set-context $(kubectl config current-context) --namespace=dev

