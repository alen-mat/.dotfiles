* SOURCE  : https://wiki.archlinux.org/title/PRIME

- xrandr --listproviders, will show all providers

* Prime offload
- xrandr --setprovideroffloadsink 1 0 
- make a render offload provider send its output to the sink provider 

* For open source drivers - PRIME
- use `DRI_PRIME=1` to make an application use decrete GPU.
- DRI_PRIME=1 blender
