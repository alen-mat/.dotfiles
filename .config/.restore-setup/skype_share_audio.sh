#/usr/bin/env bash

#Link 1 : https://askubuntu.com/questions/1254057/how-can-i-share-computer-audio-on-skype/1254093#1254093
#Link 2 : https://askubuntu.com/questions/1254057/how-can-i-share-computer-audio-on-skype/1254093#1254093
#Once you figure out the required commands, you can have this persist by adding them to /etc/pulse/default.pa (bottom is fine), and dropping the pactl part.


# Determine "Computer Audio" Sink
#pacmd list-sinks | egrep '^\s+name:'

# Determine "Microphone" Source
#pacmd list-sources | egrep '^\s+name:'

pactl load-module module-null-sink sink_name="FakeMicrophone" sink_properties=device.description="FakeMicrophone"
echo "[*]Created fake Microphone"

pactl load-module module-loopback latency_msec=1 source=alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_X-00.analog-stereo sink=FakeMicrophone
echo "[*]Tied fake mic with real mic"

pactl load-module module-loopback latency_msec=1 source=alsa_output.pci-0000_00_1b.0.analog-surround-21.monitor sink=FakeMicrophone
echo "[*]Connected \"Computer Audio\" Monitor to fake mic"

echo "[*]Setup complete
   *****************
   Share audio on screenshare
     pavucontrol -> \"Recording\" tab and select the FakeMicrophone in Skype.
   Troubleshoot :
      - If FakeMicrophone does'nt seem to be active or working, try entering this in a terminal:
        >>>  pacmd set-sink-mute FakeMicrophone off
      - echoes on the other person's end
        >>>  pactl unload-module module-null-sink
        >>>  pactl unload-module module-loopback
        Execute the above and rereun the script
"

