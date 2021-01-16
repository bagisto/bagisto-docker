# just asking one question
echo -n "Do you want us to setup everything for you? (y/n) "
read answer

# cloning bagisto
git clone https://github.com/bagisto/bagisto bagisto

# building and running docker-compose file
docker-compose build && docker-compose up -d

# container id by image name
container_id=$(docker ps -aqf "name=bagisto-php-apache")

# installing composer dependencies inside container
docker exec ${container_id} composer install

# execute only if user answered yes
if [ "$answer" != "${answer#[Yy]}" ] ;then
    # moving `.env` file and caching changes
    docker cp .configs/.env ${container_id}:/var/www/html/.env
    docker exec ${container_id} php artisan config:cache

    # migrating and seeding data
    docker exec ${container_id} php artisan migrate:fresh --seed

    # publishing assets
    docker exec ${container_id} php artisan vendor:publish --all --force

    # linking storage
    docker exec ${container_id} php artisan storage:link

    # optimizing stuffs
    docker exec ${container_id} php artisan optimize
fi