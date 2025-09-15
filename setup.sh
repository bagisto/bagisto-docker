# function to check which docker compose command is available
check_docker_compose() {
    if command -v docker-compose >/dev/null 2>&1; then
        echo "docker-compose"
    elif docker compose version >/dev/null 2>&1; then
        echo "docker compose"
    else
        echo "Error: Neither 'docker-compose' nor 'docker compose' is available."
        echo "Please install Docker Compose."
        exit 1
    fi
}

# get the correct docker compose command
DOCKER_COMPOSE=$(check_docker_compose)

echo "Using: $DOCKER_COMPOSE"

# just to be sure that no traces left
$DOCKER_COMPOSE down -v

# building and running docker-compose file
$DOCKER_COMPOSE build && $DOCKER_COMPOSE up -d

# container id by image name
php_container_id=$(docker ps -aqf "name=php-fpm")
db_container_id=$(docker ps -aqf "name=mysql")

# checking connection
echo "Please wait... Waiting for MySQL connection..."
while ! docker exec ${db_container_id} mysql --user=root --password=root -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done

# creating empty database for bagisto
echo "Creating empty database for bagisto..."
while ! docker exec ${db_container_id} mysql --user=root --password=root -e "CREATE DATABASE IF NOT EXISTS bagisto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >/dev/null 2>&1; do
    sleep 1
done

# creating empty database for bagisto testing
echo "Creating empty database for bagisto testing..."
while ! docker exec ${db_container_id} mysql --user=root --password=root -e "CREATE DATABASE IF NOT EXISTS bagisto_testing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >/dev/null 2>&1; do
    sleep 1
done

# setting up bagisto
echo "Now, setting up Bagisto..."
docker exec ${php_container_id} git clone https://github.com/bagisto/bagisto

# setting bagisto stable version
echo "Now, setting up Bagisto stable version..."
docker exec -i ${php_container_id} bash -c "cd bagisto && git reset --hard v2.3.6"

# installing composer dependencies inside container
docker exec -i ${php_container_id} bash -c "cd bagisto && composer install"

# moving `.env` file
docker cp .configs/.env ${php_container_id}:/var/www/html/bagisto/.env
docker cp .configs/.env.testing ${php_container_id}:/var/www/html/bagisto/.env.testing

# executing final commands
docker exec -i ${php_container_id} bash -c "cd bagisto && php artisan bagisto:install --skip-env-check --skip-admin-creation"
docker exec -i ${php_container_id} bash -c 'cd bagisto && php artisan db:seed --class=Webkul\\Installer\\Database\\Seeders\\ProductTableSeeder'
