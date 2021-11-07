#!/bin/bash
# baraction.sh for spectrwm status bar

## DISK
hdd() {
	hdd="$(df -h | awk 'NR==4{print $3, $5}')"
	echo -e "HDD: $hdd"
}

## RAM
mem() {
	mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
	echo -e "$mem"
}

## CPU
cpu() {
	read cpu a b c previdle rest < /proc/stat
	prevtotal=$((a+b+c+previdle))
	sleep 0.5
	read cpu a b c idle rest < /proc/stat
	total=$((a+b+c+idle))
	cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
	echo -e "CPU: $cpu%"
}

## VOLUME
vol() {
	vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g'`
	echo -e "VOL: $vol"
}

wifi(){
	conn=$(nmcli -t -f active,ssid,bars dev wifi | grep '^yes')
	ssid=$(echo $conn|cut -d: -f2)
	bar=$(echo $conn|cut -d: -f3)
	echo -e "${bar} ${ssid}"
}

bat(){
	b=$(acpi)
	per=$(echo $b|cut -d, -f2)
	stat=$(echo $b|cut -d, -f1|cut -d: -f2)
	echo -e "${per} ${stat}"
}

tun(){
	[[ ! -z '$(ifconfig | grep -E "(vpn|tun)")' ]] && echo -e "VPN "
}

# cache the output of apm(8), no need to call that every second.
APM_DATA=""

SLEEP_SEC=3
#loops forever outputting a line every SLEEP_SEC secs

while :; do
	echo " $(cpu) | $(mem) | $(hdd) | $(vol) | $(tun)$(wifi) | $(bat) | "
	sleep $SLEEP_SEC
done

