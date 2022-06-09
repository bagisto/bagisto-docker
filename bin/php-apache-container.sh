container_id=$(docker ps -aqf "name=bagisto-php-apache")

docker exec -it ${container_id} bash