# container id
CONTAINER_ID=$(docker ps -aqf "name=bagisto-mysql")

docker exec -it ${CONTAINER_ID} bash
