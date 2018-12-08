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
