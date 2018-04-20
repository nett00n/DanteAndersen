#!/bin/bash
## Telegram Sock5 links generator
UtilityName="[$(basename $0)]"
ScriptPath=$(readlink -f $0)
ScriptDir=$(dirname $ScriptPath)
WorkDir="$ScriptDir"

source ${WorkDir}/config.ini

if [[ -z $MainIP ]]
then
        MainIP="$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)"
fi

if [[ -z "$SocksPort" ]]
then SocksPort=1080
fi

function EchoUsersLink {
	if [[ ! -z "$CurrentUsername" ]] && [[ ! -z "$CurrentPassword" ]]
	then
		CurrentUsername="$(echo $1| cut -d ':' -f 1)"
		CurrentPassword="$(echo $1| cut -d ':' -f 2)"
		echo "tg://socks?server=${ProxyHostName}&port=${SocksPort}&user=${CurrentUsername}&pass=${CurrentPassword}"
	fi
}
while read in; do EchoUsersLink "$in"; done < ${WorkDir}/users.txt
