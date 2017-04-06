####
# This script assumes your Vagrantfile has been configured to map the root of
# your application to /vagrant and that your web root is the "public" folder
# (Laravel standard).  Standard and error output is sent to
# /vagrant/vm_build.log during provisioning.
####


# PROJECT FOLDER NAME
PROJECTFOLDER='myproject'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# Variables
DBHOST=localhost
DBNAME=dbname
DBUSER=dbuser
DBPASSWD=test123

echo -e "\n--- Running.. ---\n"

echo -e "\n--- Updating packages list ---\n"

apt-get -qq update

echo -e "\n--- Installing base packages ---\n"

apt-get -y install vim curl tree build-essential python-software-properties git >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Installing zip unzip packages ---\n"

apt-get -y install zip unzip >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Updating packages list ---\n"

apt-get -qq update

echo -e "\n--- Install MySQL specific packages and settings ---\n"

debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install mysql-server phpmyadmin >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"

# can prob clean this out since we are accessing db as root but may be useful later..
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME" >> /vagrant/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'" > /vagrant/vm_build.log 2>&1

#echo -e "\n--- Creating table users ---\n"
#mysql -u root -ptest123 << EOF
#create database users;
#use users;
#CREATE TABLE `users` (
#  `id` int(11) PRIMARY KEY AUTO_INCREMENT,
#  `first_name` text,
#  `last_name` text,
#  `username` text,
#  `email` text NOT NULL,
#  `password` varchar(255) NOT NULL,
#  `date_entered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
#);
#EOF
#echo -e "\n--- DONE - Creating table users ---\n"

echo -e "\n--- Installing PHP-specific packages ---\n"

apt-get -y install php apache2 libapache2-mod-php php-curl php-gd php-mysql php-gettext php7.0-zip >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Enabling mod-rewrite ---\n"

a2enmod rewrite >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- Setting document root to public directory ---\n"
rm -rf /var/www/html
ln -fs /vagrant/public /var/www/html
#ln -fs /vagrant /var/www/html


echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

echo -e "\n--- Restarting Apache ---\n"
service apache2 restart >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Updating project components and pulling latest versions ---\n"

echo -e "\n--- adding line to apache.conf file to get access to phpmyadmin ---\n"

sudo sed -i '$ a\Include /etc/phpmyadmin/apache.conf' /etc/apache2/apache2.conf && sudo service apache2 restart

echo -e "\n--- DONE!! ---\n"

# additional ..

#echo -e "\n--- Installing Composer ---\n"

curl -sS https://getcomposer.org/installer | php
# if it doesnt install move it with sudo from cmd line
mv composer.phar /usr/local/bin/composer






# NOTES

# to add later

# get rid of the warning about the Servers domain name just by adding one line to any of the apache config files. (i use the one that comes empty)
# The error that reads "[warning]: Could not determine the server's fully qualified domain name, using 127.0.0.1 for ServerName"
# sudo nano /etc/apache2/httpd.conf
# ServerName YOUR.IP.ADDRESS.HERE


# setup hosts file - currently broke - ignore
# VHOST=$(cat <<EOF
# <VirtualHost *:80>
#    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
#    <Directory "/var/www/html/${PROJECTFOLDER}">
#        AllowOverride All
#        Require all granted
#    </Directory>
# </VirtualHost>
# EOF
# )
# echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf




####################
# final, install composer and slim
# cd /vagrant
# composer require slim/slim "^3.0"
# composer require slim/twig-view

####################
# view logs
# tail -f /var/log/apache2/error.log

