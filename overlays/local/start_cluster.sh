kind create cluster --config ./overlays/local/kind.yml
sleep 10
kubectl apply -f ../../secret-ssh.yml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -k ./bootstrap/overlays/local
