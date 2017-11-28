#!/bin/bash
# ******************************************
# Program: AUTOSCRIPT INSTALL DEBIAN 8.x 32/64Bit
# Developer: MUHAMMAD KHAIRUNNAS
# COMPANY : MKSSHVPN
# Date: 18/7/2017
# Last Updated: 19/7/2017
# ******************************************

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi
if [[ ! -e /dev/net/tun ]]; then
	echo "TUN/TAP is not available"
	exit
fi
echo "
AUTOSCRIPT RUN
SETUP BY MKSSHVPN
WAITING...
"
clear
echo "START AUTOSCRIPT"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear
echo "
ENABLE IPV4 AND IPV6
COMPLETE 1%
"
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
clear

echo "
REMOVE SPAM PACKAGE
COMPLETE 10%
"
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
UPDATE AND UPGRADE PROCESS 
PLEASE WAIT TAKE TIME 1-5 MINUTE
"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update;
apt-get -y upgrade;
apt-get -y install wget curl hi
;
echo "
INSTALLER PROCESS PLEASE WAIT
TAKE TIME 5-10 MINUTE
"

# fail2ban & exim & protection
apt-get -y install fail2ban sysv-rc-conf dnsutils dsniff zip unzip;
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip;unzip master.zip;
cd ddos-deflate-master && ./install.sh
service exim4 stop;sysv-rc-conf exim4 off;

# webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# ssh
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
wget -O /etc/issue.net "https://raw.githubusercontent.com/BlackHand7752/giveme8/master/conf/banner"

# dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/zero9911/a/master/script/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd

# squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/zero9911/a/master/script/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid3/squid.conf
cd

# text gambar
apt-get install boxes

# color text
cd
rm -rf /root/.bashrc
wget -O /root/.bashrc "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/.bashrc"

# install lolcat
sudo apt-get -y install ruby
sudo gem install lolcat

# nginx
apt-get -y install nginx php5-fpm php5-cli
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://raw.github.com/MuLuu09/conf/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by MuLuu | telegram @MuLuu09 | whatsapp +601131731782</pre>" > /home/vps/public_html/index.php
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "http://raw.github.com/MuLuu09/conf/master/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "http://raw.github.com/Qeesya/autoscript/master/script/openvpn.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "http://raw.github.com/Qeesya/autoscript/master/script/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
wget -O /etc/iptables.up.rules "http://raw.github.com/MuLuu09/conf/master/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i 's/port 1194/port 6500/g' /etc/openvpn/1194.conf
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
service openvpn restart

# etc
wget -O /home/vps/public_html/client.ovpn "http://raw.github.com/Qeesya/autoscript/master/script/client.ovpn"
sed -i $MYIP2 /home/vps/public_html/client.ovpn;
cd
#add useruseradd 
-m -g users -s /bin/bash MuLuu
echo "MuLuu:12345" | chpasswd

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://raw.github.com/MuLuu09/conf/master/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php
cd

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "http://raw.github.com/MuLuu09/conf/master/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.820_all.deb"
dpkg --install webmin_1.820_all.deb;
apt-get -y -f install;
rm /root/webmin_1.820_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
service vnstat restart


# download script
cd
wget -O /usr/bin/motd "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/motd"
wget -O /usr/bin/benchmark "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/benchmark.sh"
wget -O /usr/bin/speedtest "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/speedtest_cli.py"
wget -O /usr/bin/ps-mem "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/ps_mem.py"
wget -O /usr/bin/dropmon "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/dropmon.sh"
wget -O /usr/bin/menu "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/menu.sh"
wget -O /usr/bin/user-active-list "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-active-list.sh"
wget -O /usr/bin/user-add "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-add.sh"
wget -O /usr/bin/user-add-pptp "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-add-pptp.sh"
wget -O /usr/bin/user-del "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-del.sh"
wget -O /usr/bin/disable-user-expire "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/disable-user-expire.sh"
wget -O /usr/bin/delete-user-expire "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/delete-user-expire.sh"
wget -O /usr/bin/banned-user "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/banned-user.sh"
wget -O /usr/bin/unbanned-user "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/unbanned-user.sh"
wget -O /usr/bin/user-expire-list "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-expire-list.sh"
wget -O /usr/bin/user-gen "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-gen.sh"
wget -O /usr/bin/userlimit.sh "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/userlimit.sh"
wget -O /usr/bin/userlimitssh.sh "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/userlimitssh.sh"
wget -O /usr/bin/user-list "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-list.sh"
wget -O /usr/bin/user-login "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-login.sh"
wget -O /usr/bin/user-pass "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-pass.sh"
wget -O /usr/bin/user-renew "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/user-renew.sh"
wget -O /usr/bin/clearcache.sh "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/clearcache.sh"
wget -O /usr/bin/bannermenu "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/bannermenu"
cd

#rm -rf /etc/cron.weekly/
#rm -rf /etc/cron.hourly/
#rm -rf /etc/cron.monthly/
rm -rf /etc/cron.daily/
wget -O /root/passwd "https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/passwd.sh"
chmod +x /root/passwd
echo "01 23 * * * root /root/passwd" > /etc/cron.d/passwd

echo "*/30 * * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "00 23 * * * root /usr/bin/disable-user-expire" > /etc/cron.d/disable-user-expire
echo "0 */12 * * * root /sbin/reboot" > /etc/cron.d/reboot
#echo "00 01 * * * root echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a" > /etc/cron.d/clearcacheram3swap
echo "*/30 * * * * root /usr/bin/clearcache.sh" > /etc/cron.d/clearcache1

cd
chmod +x /usr/bin/motd
chmod +x /usr/bin/benchmark
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/ps-mem
#chmod +x /usr/bin/autokill
chmod +x /usr/bin/dropmon
chmod +x /usr/bin/menu
chmod +x /usr/bin/user-active-list
chmod +x /usr/bin/user-add
chmod +x /usr/bin/user-add-pptp
chmod +x /usr/bin/user-del
chmod +x /usr/bin/disable-user-expire
chmod +x /usr/bin/delete-user-expire
chmod +x /usr/bin/banned-user
chmod +x /usr/bin/unbanned-user
chmod +x /usr/bin/user-expire-list
chmod +x /usr/bin/user-gen
chmod +x /usr/bin/userlimit.sh
chmod +x /usr/bin/userlimitssh.sh
chmod +x /usr/bin/user-list
chmod +x /usr/bin/user-login
chmod +x /usr/bin/user-pass
chmod +x /usr/bin/user-renew
chmod +x /usr/bin/clearcache.sh
chmod +x /usr/bin/bannermenu
cd

# restart service
service ssh restart
service openvpn restart
service dropbear restart
service nginx restart
service php5-fpm restart
service webmin restart
service squid3 restart
service fail2ban restart


# info
clear
echo "Setup by MuLuu09"
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:/client.ovpn)"
echo "OpenSSH  : 22, 143"
echo "Dropbear : 109, 110, 443"
echo "Squid3   : 8080 (limit to IP SSH)"
echo ""
echo "----------"
echo "Webmin   : http://$MYIP:10000/"
echo "vnstat   : http://$MYIP:81/vnstat/"
echo "Timezone : Asia/Malaysia"
echo "Fail2Ban : [on]"
echo "IPv6     : [off]"
echo "Status   : please type menu to check menu list"
echo ""
echo "Please Reboot your VPS !"
echo ""
echo "==============================================="
