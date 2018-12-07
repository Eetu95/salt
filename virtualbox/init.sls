updates:
  cmd.run:
    - name: 'sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get autoremove'

ubuntu linux headers:
  cmd.run:
    - name: 'sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms'

virtualbox repository key 1:
  cmd.run:
    - name: 'sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -'

virtualbox repository key 2:
  cmd.run:
    - name: 'sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -'

virtualbox repository:
  cmd.run:
    - name: sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'

update:
  cmd.run:
    - name: 'sudo apt-get update'

install virtualbox-5.2:
  cmd.run:
    - name: 'sudo apt-get -y install virtualbox-5.2'

virtualbox extension pack:
  cmd.run:
    - name: 'sudo curl -O http://download.virtualbox.org/virtualbox/5.2.4/Oracle_VM_VirtualBox_Extension_Pack-5.2.4-119785.vbox-extpack'

install virtualbox extension pack:
  cmd.run:
    - name: 'sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.4-119785.vbox-extpack'
