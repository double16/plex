#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

 INSTALLED=$(dpkg-query -W -f='${Version}' plexmediaserver)

[ "$PLEXPASS" ] && echo "PLEXPASS is deprecated, please use VERSION"

if [[ -z $VERSION && "$PLEXPASS" == "1" || $VERSION = "plexpass" ]]; then
	VERSION=$(curl -s https://tools.linuxserver.io/latest-plexpass.json | grep "version" | cut -d '"' -f 4)
	echo "Useing version: $VERSION from Plexpass latest"
elif [[ $VERSION = "latest" || -z $VERSION ]]; then
	VERSION=$(curl -s https://tools.linuxserver.io/latest-plex.json| grep "version" | cut -d '"' -f 4)
	echo "Useing version: $VERSION from Public latest"
else
	echo "Useing version: $VERSION from Manual"
fi

last=130
if [[ "$VERSION" != "$INSTALLED" ]]; then
  echo "Upgradeing from version: $INSTALLED to version: $VERSION"
    while [[ $last -ne "0" ]]; do
	  rm -f /tmp/plexmediaserver_*.deb
	  wget -P /tmp "https://downloads.plexapp.com/plex-media-server/$VERSION/plexmediaserver_${VERSION}_amd64.deb"
	  last=$?
	done
	apt-get remove --purge -y plexmediaserver
	gdebi -n /tmp/plexmediaserver_"${VERSION}"_amd64.deb
else
	echo "No need to update!"
fi
cp -v /defaults/plexmediaserver /etc/default/plexmediaserver
