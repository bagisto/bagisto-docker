## **v1.2.0 (30th of June 2026)** - *Release*

- Added two more web server runtimes — OpenLiteSpeed (lsphp) and Apache (mod_php) — alongside Nginx, each with its own `docker-compose.<runtime>.yml`. `setup.sh` now asks which runtime to set up.

- Reorganized each runtime into a self-contained `runtimes/<name>/` folder (its own `Dockerfile` and `configs/`).

- Added support for [Bagisto](https://github.com/bagisto/bagisto) v2.4.0 and above.

## **v1.1.2 (30th of June 2026)** - *Release*

- Replaced Apache services with Nginx.

- Added support for [Bagisto](https://github.com/bagisto/bagisto) v2.3.6 and v2.3.19.

## **v1.1.1 (15th of September 2025)** - *Release*

- Added support for [Bagisto](https://github.com/bagisto/bagisto) v2.2.4 to v2.3.6.

## **v1.1.0 (1st of April 2025)** - *Release*

- Added support for [Bagisto](https://github.com/bagisto/bagisto) v2.2.4 and above.


## **v1.0.0 (29th of October 2024)** - *First Release*

- Added support for [Bagisto](https://github.com/bagisto/bagisto) v2.0.0 and above.
