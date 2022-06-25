kind create cluster --config ./overlays/local/kind.yml

sleep 20
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 20
kubectl apply -k ./bootstrap/overlays/local
kubectl apply -f ../../secret-ssh.yml
