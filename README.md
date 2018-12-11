# salt
Palvelinten hallinta - miniprojekti - phpVirtualBox

SaltStack moduuli, joka asentaa VirtualBoxin ja sitä voi käyttää selaimessa (phpVirtualBox).

## SaltStack - phpVirtualBox

Tavoitteenani oli tehdä SaltStack -miniprojekti, joka asentaa VirtualBoxin Linuxille (Ubuntu) ja että sitä voi käyttää selaimessa (phpVirtualBox). Miniprojektin salt tilojen avulla saa phpVirtualBoxin asennettua nopeasti ja pidettyä sen idempotenttina.

Käytin projektin demoamisessa VirtualBox VM ympäristöä. Asensin VirtualBoxiin Linux Xubuntu 18.04 Desktop AMD64 sekä Linux Ubuntu Server 16.04.5 LTS 64-bit Virtuaalikoneet. Käytin Linux Xubuntua herrana ja Linux Ubuntu Serveriä orjana.

Tietokokeen rautaa:

Prosessori: Intel Core i5 4960K @ 3.50GHz
Haswell 22nm Tekniikkaa

RAM-muisti: 8,00Gt Kaksi-Kanava DDR3 1600MHz (10-10-10-30)

### Manuaalinen asennus

Asensin SaltStackin virtuaalikoneille. Päivitin molemmat koneet:
```
  $ sudo apt-get update
```
```
  $ sudo apt-get upgrade
```
Xubuntulle asensin salt-masterin:
```
  $ sudo apt-get -y install salt-master
```
Ubuntu Serverille asensin salt-minionin:
```
  $ sudo apt-get -y install salt-minion
```
Lisäsin herran IP-osoitteen /etc/salt/minion -tiedostoon.
```
  $ echo 'master: (IP-osoite)'|sudo tee /etc/salt/minion
```
Käynnistin salt-minionin uudelleen:
```
  $ sudo systemctl restart salt-minion
```
Testasin yhteyden toimivuuden:
```
  $ sudo salt '*' test.ping
```
Yhteys toimi!

#### VirtualBox 5.2 (uusin versio)

Tarkoituksena oli asentaa VirtualBox ensin manuaalisesti orjalle (Linux Ubuntu Server 16.04.5 LTS AMD64), jotta sitä olisi helpompi automatisoida Saltilla. Otin ohjeita [täältä](https://websiteforstudents.com/virtualbox-5-2-on-ubuntu-16-04-lts-server-headless/).

Päivitettyäni Ubuntu Serverin aloin asentamaan Ubuntu Linux header:eita, jotta saisin uusimman VirtualBox version (tällä hetkellä 5.,2) käyttööni.

  $ sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms

![ubuntu-linux-headers](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/1.PNG?raw=true)

Headerit asennettu! Sitten asensin VirtualBox repository avaimet ja lisäsin repositoryn Ubuntu Serveriin:

Avainten lisäys:
```
  $ sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  $ sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
```
Repositoryn lisäys:
```
  $ sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
```
![keys-and-repository](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/2.PNG?raw=true)

Kaikki asentui! Sitten asensin itse VirtualBoxin (5.2) paketinhallinnasta. Päivitin ensin paketinhallinnan:
```
  $ sudo apt-get update
```
Sitten asensin VirtualBox 5.2 -paketit:
```
  $ sudo apt-get install virtualbox-5.2
``` 
Tarkistin, että versio on oikea:
``` 
  $ VBoxManage -v
```  
 ![virtualbox-installation](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/3.PNG?raw=true)

VirtualBox 5.2 asentui! Katsoin vielä virtualbox help:iä:
```
  $ virtualbox -h
```
![virtualbox-help](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/4.PNG?raw=true)

Komennolla:
```
 $ --startvm <vmname|UUID>
```
saa laitettua virtuaalikoneen päälle.

#### phpVirtualBox - (Käyttää selaimen kautta VirtualBoxia)

Nyt kun VirtualBox 5.2 <- (uusin versio tällähetkellä) on asennettu aloin asentamaan VirtualBoxia selaimeen (GUI, phpVirtualBox). Hyvät ohjeet tähän löytyy [täältä](https://www.techrepublic.com/article/how-to-install-phpvirtualbox-for-cloud-based-virtualbox-management/)

Ensin loin uuden järjestelmäkäyttäjän rootilla ja lisäsin sen "vboxusers" ryhmään (Tätä tullaan tarvitsemaan):
```
  $ useradd -m vbox -G vboxusers
``` 
Annoin VirtualBox käyttäjälle salasanan:
```
  $ passwd vbox
```
Pysyin rootissa ja loin tiedoston /etc/default/virtualbox, jonka sisälle laitoin
```
  VBOXWEB_USER=vbox
```
Sitten laitoin vboxwebsrv:n päälle:
```
  $ systemctl enable vboxweb-service
  $ systemctl start vbox-service
```
![authentication](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/5.PNG?raw=true)

Sitten asensin apache web-palvelimen ja php-moduulit:
```
  $ apt-get -y install apache2 libapache2-mod-php7.0 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libapr1 php7.0-common     php7.0-mysql php7.0-soap php-pear wget
```
Uudelleen käynnistin apache2 web-palvelimen:
```
  $ systemctl restart apache2.service
```
Sitten latasin phpVirtualBoxin /var/www/html -hakemistossa:
```
  $ wget http://downloads.sourceforge.net/project/phpvirtualbox/phpvirtualbox-5.0-5.zip
```
Asensin unzipin:
```
  $ sudo apt-get -y install unzip
```
Sitten purin zip-tiedoston:
```
  $ unzip phpvirtualbox-5.0-5.zip
```
Sitten siirryin phpvirtualbox-5.0-5 -hakemistoon:
```
  $ cd phpvirtualbox-5.0-5
```
Tein konfigurointi tiedoston. Kopioin esimerkki konffi -tiedoston:
```
  $ cp config.php-example config.php
```
Avasin konffitiedoston ja vaihdoin muuttujan "var $password = 'pass';" salasanan VirtualBox käyttäjäni salasanaksi. Sitten tallensin ja suljin tiedoston. Sitten käynnistin vboxweb-service:n uudestaan, jotta muutokset saatiin voimaan:

![config.php](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/6.PNG?raw=true)

```
  $ systemctl restart vboxweb-service
```
Avasin Mozilla Firefox -selaimen herra koneella (Xubuntu) ja syötin orjan (Ubuntu Server) ip-osoitteen URL-kenttään
--> http://ip-osoite/phpvirtualbox-5.0-5/

![phpvirtualbox-5.0-5-admin](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/7.png?raw=true)

Phpvirtualbox -vastasi osoitteesta, syötin admin salasanan ja kirjauduin sisälle.

![phpvirtualbox-5.0-5-admin](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/8.png?raw=true)

Uuden virtuaalikoneen luominen onnistui.

### Automatisointi Saltilla

![phpvirtualbox-states-run](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/10.PNG?raw=true)

Molemmat Salt-tilat (virtualbox, phpvirtualbox) ajettuna onnistuneesti Linux Ubuntu Server 16.04.5 64-bit LTS Xenial Xerus:lla. Tilojen ajon jälkeen (sudo salt '*' state.highstate) käyttäjän pitää vielä itse määritellä vbox käyttäjälle oma salanana (sudo passwd vbox) ja vaihtaa se /var/www/html/phpvirtualbox-5.0-5/config.php -tiedostossa 'pass' tilalle. Lopuksi käyttäjän pitää vielä itse käynnistää vboxweb-service ja apache2 uudelleen, jotta palvelu saadaan toimimaan (sudo systemctl restart vboxweb-service.service apache2.service).

![virtualbox-5.2](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/11.PNG?raw=true)

Virtualbox init.sls. Voi olla järkevämpää ladata VirtualBox-5.0, koska se on yhteensopivampi phpvirtualbox-5.0-5:n kanssa. VirtualBox-5.2 toimii kyllä myös phpVirtualBox-5.0-5:n kanssa, mutta se vain herjaa yhteensopimattomuudesta selaimessa kirjautuessa palveluun. Tätä tilaa on ajettu Linux Ubuntu Server 16.04.5 64-bit LTS Xenial Xerus koneella. Ei takeita toimivuudesta muilla Linux jakeluilla. Tilaa saa muuttaa vapaasti omiin tarpeisiinsa sopivaksi.

![phpvirtualbox](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/12.PNG?raw=true)

phpVirtualBox init.sls. Tässä on tila joka ajaa phpVirtualBox:n (5.0-5)(5.2 -versio on ilmeisesti jo saatavilla). Ajetaan yhdessä virtualbox -tilan kanssa. Toimii edellä mainitussa Linux Ubuntu Server:ssä. Suosittelen tilan muutosta uudempaan phpVirtualBox versioon heti kun saatavilla.

![top.sls](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/13.PNG?raw=true)

Top.sls:ssä ajetaan kaikille. Virtualbox tila ensin sitten phpvirtualbox.

![phpvirtualbox-browser](https://github.com/Eetu95/Palvelinten-hallinta-ict4tn022-3004/blob/master/miniprojektin%20kuvakaappaukset/9.png?raw=true)

Kirjauduin palveluun (käyttäjä: admin salasana: admin). Muista vaihtaa käyttäjätunnus ja salasana ensimmäisen kirjautumisen jälkeen. Kirjautumisen yhteydessä tuli herja phpVirtualBox 5.0-5:n yhteensopimattomuudesta VirtualBox 5.2.22:n kanssa. Ilmeisesti uusimman phpVirtualBox -version saakin jo [täältä](https://github.com/phpvirtualbox/phpvirtualbox/releases). PhpVirtualBox -tilan paketit on hyvä muuttaa uudempaan.

phpVirtualBox toimi normaalisti kokeiltuani sitä. PhpVirtualBox uudempaan versioon pävittäminen on erittäin suositeltua.

### Lähteet:

Karvinen, Tero: Oppitunnit, Palvelinten hallinta -kurssi.

VirtualBox 2018. [https://www.virtualbox.org/](https://www.virtualbox.org/)

Xubuntu 18.04.1. [https://xubuntu.org/news/18-04-1-released/](https://xubuntu.org/news/18-04-1-released/)

Ubuntu 16.04.5 LTS (Xenial Xerus). [http://releases.ubuntu.com/16.04/](http://releases.ubuntu.com/16.04/)

Website for Students 2018 - VirtualBox 5.2 On Ubuntu 16.04 LTS Server (Headless). [https://websiteforstudents.com/virtualbox-5-2-on-ubuntu-16-04-lts-server-headless/](https://websiteforstudents.com/virtualbox-5-2-on-ubuntu-16-04-lts-server-headless/).

Tech Republic 2018 - How to install phpVirtualBox for cloud-based VirtualBox management. [https://www.techrepublic.com/article/how-to-install-phpvirtualbox-for-cloud-based-virtualbox-management/](https://www.techrepublic.com/article/how-to-install-phpvirtualbox-for-cloud-based-virtualbox-management/)

SourceForge 2018 - phpVirtualBox. [https://sourceforge.net/projects/phpvirtualbox/files/](https://sourceforge.net/projects/phpvirtualbox/files/)

GitHub 2018. phpvirtualbox. [https://github.com/phpvirtualbox/phpvirtualbox/releases](https://github.com/phpvirtualbox/phpvirtualbox/releases)

GitHub 2018. Eetu95 - salt. [https://github.com/Eetu95/salt](https://github.com/Eetu95/salt)

Karvinen, Tero 2018: Aikataulu - Palvelinten hallinta ict4tn022 3004-ti, oma moduuli. [http://terokarvinen.com/2018/aikataulu-%E2%80%93-palvelinten-hallinta-ict4tn022-3004-ti-ja-3002-to-%E2%80%93-loppukevat-2018-5p](http://terokarvinen.com/2018/aikataulu-%E2%80%93-palvelinten-hallinta-ict4tn022-3004-ti-ja-3002-to-%E2%80%93-loppukevat-2018-5p)

### Muuta:

Kaikki kuvat on otettu Microsoft Windows Kuvankaappaustyökalulla. Kuvat löytyvät GitHubistani.

Tätä dokumenttia saa kopioida ja muokata GNU GPL (versio 2 tai uudempi) mukaisesti. [https://www.gnu.org/licenses/gpl.html](https://www.gnu.org/licenses/gpl.html)
