#!/bin/bash
#
# Downloads the nightly build of tla2tools.jar
# Downloads the CommunityModules artefacts
#

set -e

download() {
	if type curl > /dev/null 2>&1; then
		download_curl "$1"
	else
		echo "Couldn't find curl" >&2
	fi
}

download_curl() {
	local if_modified

	if [ -e tla2tools.jar ]; then 
		if_modified="-z tla2tools.jar"
	fi

	curl -f -Ss -R -O $if_modified "$1"

	if [ $? -ne 0 ]; then
		echo "Couldn't download tla2tools.jar"
		exit 1
	fi
}

print_version() {
	"$1" tlc2.TLC | grep Version | cut -d' ' -f3
}

main() {
        sudo apt-get install unzip

	LATEST=$(curl -s https://nightly.tlapl.us/products/ | grep linux | grep -zoP '<a[^<]*[^<]*href="\K[^"]+')
	URL="https://nightly.tlapl.us/products/$LATEST"
	echo "Downloading tla2tools.jar from: $URL"

	wget $URL
	unzip -j $LATEST "toolbox/tla2tools.jar" -d .

	CM_URL=$(curl -s https://api.github.com/repos/tlaplus/communitymodules/releases/latest | grep "browser_download_url.*CommunityModules.jar" | cut -d : -f 2,3 | tr -d \")
	echo "Downloading CommunityModules.jar from: $CM_URL"
	wget $CM_URL

	echo "Downloading CommunityModules specs and jars"
	wget https://github.com/tlaplus/CommunityModules/archive/master.zip
	unzip master.zip
	
	#print_version tla2tools.jar
}

main
