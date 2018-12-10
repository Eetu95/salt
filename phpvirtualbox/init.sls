# Creates a new vbox user that adds it to vboxusers group. Remember to give your own password --> sudo passwd vbox
# After this Salt state has been run, add your vbox user password to the /var/www/html/phpvirtualbox-5.0-5/config.php -file. Change the password 'pass'.
# Lastly remember to restart vboxweb-service and apache2 --> sudo systemctl restart vboxweb-service.service apache2.service

add_new_vbox_user:
  cmd.run:
    - name: sudo useradd -m vbox -G vboxusers
    - creates: /home/vbox

/etc/default/virtualbox:
  file.managed:
    - source: salt://phpvirtualbox/virtualbox
    - unless: ls /etc/default/virtualbox

install_software:
  cmd.run:
    - name: sudo apt-get -y install apache2 libapache2-mod-php7.0 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libapr1 php7.0-common php7.0-mysql php7.0-soap php-pear wget
    - creates: 
      - /etc/apache2
      - /etc/php

/var/www/html/phpvirtualbox-5.0-5.zip:
  file.managed:
    - source: salt://phpvirtualbox/phpvirtualbox-5.0-5.zip
    - unless: ls /var/www/html/phpvirtualbox-5.0-5.zip

unzip:
  pkg.installed

/var/www/html:
  archive.extracted:
    - source: salt://phpvirtualbox/phpvirtualbox-5.0-5.zip
    - archive_format: zip
    - if_missing: /var/www/html/phpvirtualbox-5.0-5

config.php:
  cmd.run:
    - name: sudo cp /var/www/html/phpvirtualbox-5.0-5/config.php-example /var/www/html/phpvirtualbox-5.0-5/config.php
    - unless: ls /var/www/html/phpvirtualbox-5.0-5/config.php

vboxweb-service:
  service.running:
    - enable: True

apache2:
  service.running:
    - enable: True
