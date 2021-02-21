echo "🐋 Docker Setup"
systemctl is-active --quiet docker.service && echo Service is running
systemctl is-active --quiet docker.socket && echo Socket is running
systemctl start docker.service
function dockerSetup(){
local _user
local _opt
read -p "[C]Current User or [A]Another User : " _opt
if [[ "$_opt" == "C" ]]; then
    _usr=$USER
else
    read -p "Enter user Name" _usr
    if id $_usr >/dev/null 2>&1; then
        echo "user exists"
    else
        echo "user does not exist"
        exit 1
    fi
fi
echo "Adding user : ${_usr} to group docker"
#sudo usermod -a -G docker ${USER}
echo "changing group ID to docker"
newgrp docker
}
dockerSetup
