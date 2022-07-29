#/usr/bin/env bash

_add_tlp_conf(){
cat << EOF > /etc/tlp.d/00-custom.conf
TLP_ENABLE=1

RADEON_DPM_PERF_LEVEL_ON_AC=high
RADEON_DPM_PERF_LEVEL_ON_BAT=low

RADEON_DPM_STATE_ON_AC=performance
RADEON_DPM_STATE_ON_BAT=battery

RADEON_POWER_PROFILE_ON_AC=high
RADEON_POWER_PROFILE_ON_BAT=low

PCIE_ASPM_ON_AC=performance
PCIE_ASPM_ON_BAT=powersupersave

DEVICES_TO_ENABLE_ON_STARTUP="wifi"
DEVICES_TO_DISABLE_ON_STARTUP="bluetooth nfc wwan"
DEVICES_TO_DISABLE_ON_SHUTDOWN="bluetooth nfc wifi wwan"
DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth nfc wifi wwan"

START_CHARGE_THRESH_BAT0=94
STOP_CHARGE_THRESH_BAT0=98

DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"
EOF
}

_add_auto_cpufreq_conf(){
cat << EOF >/etc/auto-cpufreq.conf
[charger]
governor = performance
scaling_min_freq = 1700000
scaling_max_freq = 1700000
turbo = auto

[battery]
governor = powersave
scaling_min_freq = 1400000
scaling_max_freq = 1600000
turbo = never
EOF
}

