# just to be sure that no traces left
docker-compose down -v

# building and running docker-compose file
docker-compose build && docker-compose up -d

# container id by image name
apache_container_id=$(docker ps -aqf "name=bagisto-php-apache")
db_container_id=$(docker ps -aqf "name=bagisto-mysql")

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
docker exec ${apache_container_id} git clone https://github.com/bagisto/bagisto

# setting bagisto stable version
echo "Now, setting up Bagisto stable version..."
docker exec -i ${apache_container_id} bash -c "cd bagisto && git reset --hard v2.3.0"

# installing composer dependencies inside container
docker exec -i ${apache_container_id} bash -c "cd bagisto && composer install"

# moving `.env` file
docker cp .configs/.env ${apache_container_id}:/var/www/html/bagisto/.env
docker cp .configs/.env.testing ${apache_container_id}:/var/www/html/bagisto/.env.testing

# executing final commands
docker exec -i ${apache_container_id} bash -c "cd bagisto && php artisan bagisto:install --skip-env-check --skip-admin-creation"
