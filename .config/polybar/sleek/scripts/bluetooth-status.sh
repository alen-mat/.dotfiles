#!/bin/sh

bluetooth_print() {
	local power=off
	local connected=no
	[[ $(bluetoothctl show |grep Powered:) == *"yes"* ]] \
		&& power=on
	
	[[ "$power" == "on" ]] \
		&& local paired=$(bluetoothctl paired-devices | grep Device | cut -d' ' -f2)
	while read device; do
		[[ "$connected" == "no" ]] \
			&& info=$(bluetoothctl info "$device") \
			&& [[ "$(grep 'Connected:' <<< $info)" == *"yes"* ]] \
			&& connected=yes
	done <<< $paired

	if [[ "$power" == "off" ]]; then
		echo ""
	else
		[[ "$connected" == "yes" ]] \
			&& echo "" \
			|| echo ""
	fi
}
bluetooth_print
