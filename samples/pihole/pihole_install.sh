#!/bin/bash -ex
# this should be converted in an ansible role but i am too lazy right now

export PIHOLE_SKIP_OS_CHECK=true
mkdir -p /etc/pihole/ && touch /boot/ssh

# Used for unattended installation
cat << EOF > /etc/pihole/setupVars.conf
WEBPASSWORD=0e69e6a4038df88d4c62c837edd7e04a95ea6368bca9d469e00ad766a2266770
PIHOLE_INTERFACE=eth0
IPV4_ADDRESS=192.168.1.138/24
IPV6_ADDRESS=2601:444:8111:403:55d6:2f11:41bf:13bb
QUERY_LOGGING=true
INSTALL_WEB=true
DNSMASQ_LISTENING=single
PIHOLE_DNS_1=208.67.222.222
PIHOLE_DNS_2=208.67.220.220
PIHOLE_DNS_3=2620:119:35::35
PIHOLE_DNS_4=2620:119:53::53
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSSEC=true
TEMPERATUREUNIT=C
WEBUIBOXEDLAYOUT=traditional
API_EXCLUDE_DOMAINS=
API_EXCLUDE_CLIENTS=
API_QUERY_LOG_SHOW=all
API_PRIVACY_MODE=false
EOF

# Disable leds
cat << EOF >> /boot/config.txt
# Disable the ACT LED.
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off

# Disable the PWR LED.
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off
EOF

# Write less often to the DB
cat << EOF >> /etc/pihole/pihole-FTL.conf
MAXDBDAYS=30
DBINTERVAL=15.0
EOF

# Save logs to ram
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
apt update && apt install log2ram

curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended
