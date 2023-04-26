# container id
CONTAINER_ID=$(docker ps -aqf "name=bagisto-php-apache")

docker exec -w /var/www/html/bagisto -it ${CONTAINER_ID} bash
