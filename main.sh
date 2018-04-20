
#!/bin/bash
# Dante Installer

UtilityName="[$(basename $0)]"
ScriptPath=$(readlink -f $0)
ScriptDir=$(dirname $ScriptPath)
WorkDir="$ScriptDir"
CurrentDate=$(date +%Y%m%d%H%M%S)

source ${WorkDir}/config.ini

if [[ -z $MainIP ]]
then
	MainIP="$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)"
fi

if [[ -z "$SocksPort" ]]
then SocksPort=1080
fi

function StartInstallation {
	echo "# Installation start";
	echo "# Updatating packages info:"
	sudo apt-get update -qq
	echo "# Install dante Package"
	InstallDante
	ConfigDante
	if [[ -f users.txt ]] ; then
		echo "#Creating users from users.txt file"
		CreateUsers
	fi
	RestartDante
	while read in; do CreateUsers "$in"; done < ${WorkDir}/users.txt
}

function InstallDante {
	if [[ ! $(sudo dpkg -s dante-server) ]]
	then sudo apt-get install dante-server -y -qq
	fi
}

function ConfigDante {
	if [[ -f /etc/danted.conf ]]
	then
		echo "# Backup old dante config into: /etc/danted.conf.${CurrentDate}"
		sudo cp /etc/danted.conf /etc/danted.conf.${CurrentDate}
	fi
	echo "generating new dante config"
	sed "s/IPADDRESSPLACEHOLDER/${MainIP}/g;s/PORTPLACEHOLDER/${SocksPort}/g" ${WorkDir}/danted.conf | sudo dd of=/etc/danted.conf
}

function CreateUsers {
	CurrentUsername="$(echo $1| cut -d ':' -f 1)"
	CurrentPassword="$(echo $1| cut -d ':' -f 2)"
	CurrentComment="$(echo $1| cut -d ':' -f 3)"

	if [[ ! -z "$CurrentUsername" ]] && [[ ! -z "$CurrentPassword" ]]
	then
		if [[ ! $(cat /etc/passwd | cut -d ':' -f 1 | grep ${CurrentUsername}) ]] ;
		then
			sudo useradd -s /bin/false -c "DanteUser ${CurrentComment}" -d /dev/null -M ${CurrentUsername}
		fi
		echo "${CurrentUsername}:${CurrentPassword}"|sudo chpasswd
	fi
}

function CreateLogRotateConfig {
echo "# creating logrotate config file"

}

function RestartDante {
	echo "#Restarting Dante"
	sudo service danted restart
}

echo "# This is the script, installing and configuring simple SOCKS5 server"

if [ -f /usr/bin/apt-get ]
then
	StartInstallation
else
	echo '! apt-get not found'
	exit 1
fi
