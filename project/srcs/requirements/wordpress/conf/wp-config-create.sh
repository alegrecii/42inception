#!bin/sh
if [ ! -f "/var/www/wp-config.php" ]; then
cat << EOF > /var/www/wp-config.php
<?php
define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASS}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD','direct');
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_REDIS_TIMEOUT', 1 );
define( 'WP_REDIS_READ_TIMEOUT', 1 );
define( 'WP_REDIS_DATABASE', 0 );
require_once ABSPATH . 'wp-settings.php';
EOF
fi

cd /var/www/

# downloads the WP-CLI PHAR (PHP Archive) file from the GitHub repository. The -O flag tells curl to save the file with the same name as it has on the server.
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# makes the WP-CLI PHAR file executable.
chmod +x wp-cli.phar

# moves the WP-CLI PHAR file to the /usr/local/bin directory, which is in the system's PATH, and renames it to wp. This allows you to run the wp command from any directory
mv wp-cli.phar /usr/local/bin/wp

if ! wp --path=/var/www/ user list --field=user_login | /bin/grep -q "${DB_USER}"; then
    # wp-administrator user creation
    wp core install --path=/var/www/ --title=Inception --admin_user=${WP_ADMIN} --admin_password=${WP_PASS} --admin_email=alegre@llll.42.com --url=https://www.alegreci.42.fr
    # wp-user creation
    wp user create ${DB_USER} oooo@llll.it --path=/var/www/ --role=author --user_pass=${DB_PASS}
    wp theme install sonoran --activate --allow-root
    wp plugin install wp-redis --activate
    wp wp-redis enable
fi

/usr/sbin/php-fpm81 -F
