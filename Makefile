foo:
	docker-compose run certbot certbot certonly --agree-tos --webroot -w /mnt/ -d felixhummel.de --email postmaster@felixhummel.de
