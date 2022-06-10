container_id=$(docker ps -aqf "name=bagisto-mysql")

docker exec -it ${container_id} bash