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

# choose the web server runtime
echo ""
echo "Which web server runtime do you want to set up?"
echo "  1) nginx-php      (Nginx + PHP-FPM)"
echo "  2) litespeed-php  (OpenLiteSpeed + lsphp)"
echo "  3) apache-php     (Apache + PHP-FPM)"
printf "Enter choice [1/2/3] (default 1): "
read RUNTIME_CHOICE

case "$RUNTIME_CHOICE" in
    2)
        COMPOSE_FILE="docker-compose.litespeed-php.yml"
        WEB_SERVICE="litespeed-php"
        ;;
    3)
        COMPOSE_FILE="docker-compose.apache-php.yml"
        WEB_SERVICE="apache-php"
        ;;
    *)
        COMPOSE_FILE="docker-compose.nginx-php.yml"
        WEB_SERVICE="nginx-php"
        ;;
esac

echo "Selected: ${WEB_SERVICE} (${COMPOSE_FILE})"

# every compose call uses the chosen file
COMPOSE="$DOCKER_COMPOSE -f $COMPOSE_FILE"

# just to be sure that no traces left
$COMPOSE down -v

# building and running docker-compose file
$COMPOSE build && $COMPOSE up -d

# container ids (the chosen runtime container runs php/artisan/composer)
php_container_id=$(docker ps -aqf "name=${WEB_SERVICE}")
db_container_id=$(docker ps -aqf "name=mysql")

# checking connection
echo "Please wait... Waiting for MySQL connection..."
while ! docker exec ${db_container_id} mysql --user=root --password=root -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done

# creating empty database for bagisto
echo "Creating empty database for bagisto..."
docker exec ${db_container_id} mysql --user=root --password=root -e "CREATE DATABASE IF NOT EXISTS bagisto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# creating empty database for bagisto testing
echo "Creating empty database for bagisto testing..."
docker exec ${db_container_id} mysql --user=root --password=root -e "CREATE DATABASE IF NOT EXISTS bagisto_testing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# setting up bagisto
echo "Now, setting up Bagisto..."
docker exec ${php_container_id} git clone https://github.com/bagisto/bagisto

# setting bagisto stable version
echo "Now, setting up Bagisto stable version..."
docker exec -i ${php_container_id} bash -c "cd bagisto && git reset --hard v2.4.7"

# installing composer dependencies inside container
docker exec -i ${php_container_id} bash -c "cd bagisto && composer install"

# preparing .env (point DB at the mysql service and mail at mailpit)
docker exec -i ${php_container_id} bash -c "cd bagisto && cp -n .env.example .env && sed -i \
    -e 's/^DB_HOST=.*/DB_HOST=mysql/' \
    -e 's/^DB_DATABASE=.*/DB_DATABASE=bagisto/' \
    -e 's/^DB_USERNAME=.*/DB_USERNAME=root/' \
    -e 's/^DB_PASSWORD=.*/DB_PASSWORD=root/' \
    -e 's/^MAIL_HOST=.*/MAIL_HOST=mailpit/' \
    -e 's/^MAIL_PORT=.*/MAIL_PORT=1025/' \
    .env"

# executing final commands
docker exec -i ${php_container_id} bash -c "cd bagisto && php artisan bagisto:install --skip-env-check --skip-admin-creation --skip-github-star"
docker exec -i ${php_container_id} bash -c 'cd bagisto && php artisan db:seed --class=Webkul\\Installer\\Database\\Seeders\\ProductTableSeeder'

# the steps above run as root, so make storage + bootstrap/cache writable by the
# web server user (www-data), otherwise Laravel can't compile views / write cache
docker exec -i ${php_container_id} bash -c "cd bagisto && chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache"

# restart the web server so it serves the freshly-installed app
# (OpenLiteSpeed caches a vhost created before the docroot existed, and would
# otherwise keep returning 404 until restarted)
$COMPOSE restart $WEB_SERVICE
