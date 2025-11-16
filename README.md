# web-001-docker

## Docker setup
```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

# Add Docker's official GPG key:
```
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

# Add the repository to Apt sources:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

# Setup Docker 
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Deployment Setup
* Clone repo jika belum
```
git clone http://git.mfint.my.id/web/web-001-docker.git
```
* Masuk ke direktori repo docker
```
cd web-001-docker
```
* Setup Env
```
cp .env.example .env
```
* Build Docker Image
```
sudo docker compose build
```
* Running Docker
```
sudo docker compose up -d
```
* Change Owner To www-data
```
sudo docker compose exec --user=root php /bin/bash -c ' chown www-data:www-data /var/www'
```
* Clone Project Repo
```
sudo docker compose exec php git clone --branch test https://git.mfint.my.id/web/web-32.git .
```
* Change Permission
```
sudo docker compose exec php /bin/bash -c 'chmod +x /var/www/artisan'
```
* Setup App Env
```
cp app/.env.example app/.env
```
* Change Owner App Env
```
sudo docker compose exec --user=root php /bin/bash -c ' chown www-data:www-data /var/www/.env'
```
* Setup Basic Laravel App
```
sudo docker compose exec php composer install 
sudo docker compose exec php npm install
sudo docker compose exec php npm run build 
sudo docker compose exec php /var/www/artisan key:generate
sudo docker compose exec php /var/www/artisan storage:link
sudo docker compose exec php /var/www/artisan optimize
```
