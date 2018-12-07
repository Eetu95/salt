updates:
  cmd.run:
    - name: 'sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get autoremove'

ubuntu linux headers:
  cmd.run:
    - name: 'sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms'
