#!/bin/sh
#
# Installs the TLA+ convenience binaries. Requires that tla2tools.jar is
# downloaded already.
#
# Usage: sudo install.sh /usr/local
# or     sudo install.sh /usr
#

set -e

JAVA_HEAP="$1"
JAVA_STACK="$2"
PREFIX="$3"

if [ -z "$PREFIX" ]; then
	PREFIX=/usr/local
fi

# Try cleaning up dirty files from last run
rm -rf staging

# Stage the files in bin/*
mkdir -p staging
cp -r bin staging/bin

# Modify the staged files so they use the $PREFIX
#sed -i'' -e s_PREFIX_"$PREFIX"_ staging/bin/*
sed -i "s#PREFIX#${PREFIX}#g" staging/bin/*
sed -i "s#JAVA_OPT#${JAVA_HEAP}#g" staging/bin/*
sed -i "s#JAVA_OPT#${JAVA_STACK}#g" staging/bin/*

# Install everything
install -dv $PREFIX/lib
install -v tla2tools.jar $PREFIX/lib
install -v CommunityModules.jar $PREFIX/lib
install -v CommunityModules-master/lib/* $PREFIX/lib
install -v CommunityModules-master/modules/*.tla $PREFIX/lib

install -dv $PREFIX/bin
install -v staging/bin/* $PREFIX/bin

# Cleanup
rm -rf staging