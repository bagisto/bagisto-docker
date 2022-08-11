@ECHO OFF
rem just to be sure that no traces left
docker-compose down -v

rem building and running docker-compose file
docker-compose build && docker-compose up -d

rem container id by image name
for /f "delims=" %%i in ('docker ps -aqf "name=bagisto-php-apache"') do set apache_container_id=%%i
for /f "delims=" %%i in ('docker ps -aqf "name=bagisto-mysql"') do set db_container_id=%%i

rem checking connection
echo "Please wait... Waiting for MySQL connection..."
:waiting_my_sql
    docker exec %db_container_id% mysql --user=root --password=root -e "SELECT 1" 2> nul
if %ERRORLEVEL% NEQ 0 (
    goto :waiting_my_sql
)

rem creating empty database
echo "Creating empty database..."
:creating_database
docker exec %db_container_id% mysql --user=root --password=root -e "CREATE DATABASE bagisto CHARACTER SET utf8mb3 COLLATE utf8_unicode_ci;" 2> nul
if %ERRORLEVEL% NEQ 0 (
     goto :creating_database
)

rem setting up bagisto
echo "Now, setting up Bagisto..."
docker exec %apache_container_id% git clone https://github.com/bagisto/bagisto

rem setting bagisto stable version
echo "Now, setting up Bagisto stable version..."
docker exec -i %apache_container_id% bash -c "cd bagisto && git reset --hard $(git describe --tags $(git rev-list --tags --max-count=1))"

rem installing composer dependencies inside container
docker exec -i %apache_container_id% bash -c "cd bagisto && composer install"

rem moving `.env` file
docker cp .configs/.env %apache_container_id%:/var/www/html/bagisto/.env

rem executing final commands
docker exec -i %apache_container_id% bash -c "cd bagisto && php artisan optimize:clear && php artisan migrate:fresh --seed && php artisan storage:link && php artisan bagisto:publish --force && php artisan optimize:clear"