# Creates a new vbox user that adds it to vboxusers group. Remember to give your own password after the user has been created by Salt.
# --> passwd vbox

add_new_vbox_user:
  cmd.run:
    - name: sudo useradd -m vbox -G vboxusers
    - creates: /home/vbox

/etc/default/virtualbox:
  file.managed:
    - source: salt://phpvirtualbox/virtualbox
    - mode: 600
    - unless: ls /etc/default/virtualbox

vboxweb-service:
  service.running:
    - enable: True

install_software:
  cmd.run:
    - name: sudo apt-get -y install apache2 libapache2-mod-php7.0 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libapr1 php7.0-common php7.0-mysql php7.0-soap php-pear wget
    - creates: /etc/apache2
