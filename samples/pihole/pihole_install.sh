#!/bin/bash -ex

export PIHOLE_SKIP_OS_CHECK=true
mkdir -p /etc/pihole/ && touch /boot/ssh

cat << EOF > /etc/pihole/setupVars.conf
WEBPASSWORD=a215bae8b5ec659b0980a76dlkds09644731cd439cab41494447a8705c22b3aa41c
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

curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended

