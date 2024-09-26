k3d cluster delete yayata-cluster
k3d registry delete registry.localhost
sudo sed -i 's/LimitNOFILE=infinity/LimitNOFILE=65535/' /usr/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl restart containerd
k3d registry create registry.localhost -p 5000
k3d cluster create yayata-cluster -p "80:80@loadbalancer" --registry-use k3d-registry.localhost:5000

git clone --branch feature/metalarend/local-setup --single-branch https://github.com/inuits/yayata-common.git
cd yayata-common
task clone
task pull
cd ..

cd 925r
docker compose build
docker compose config > compose-config.yaml
docker tag ninetofiver-ninetofiver:latest k3d-registry.localhost:5000/ninetofiver:latest
docker push k3d-registry.localhost:5000/ninetofiver:latest
cd ..

cd yayata
docker compose build
docker compose config > compose-config.yaml
docker tag yayata-yayata:latest k3d-registry.localhost:5000/yayata:latest
docker push k3d-registry.localhost:5000/yayata:latest
cd ..

helm install chart ./chart
