#!/bin/bash
# optional: update manual with current version #.  This is buried in scripts/setversion which also may touch buildversion (which we don't want)

#VER=$1
#if [ -z "$VER" ]; then echo "usage: $0 4.7.0.5-st" >&2; exit 1; fi

VER=$(cat buildversion)
echo "Building version $VER for release..."; sleep 1

#MAKE='make PLATFORM=macosx C_COMPILER=gcc-4.2'
MAKE='make PLATFORM=macosx C_COMPILER=clang'

#cd $src
#touch *.scm    # necessary?
rm -f libchicken-boot*.a &&          # Workaround for Makefile bug; clang will barf if ar is called on existing files
$MAKE spotless &&
$MAKE boot-chicken &&
#touch *.scm    # necessary?
$MAKE CHICKEN=./chicken-boot spotless &&
$MAKE CHICKEN=./chicken-boot &&
rm -f chicken-$VER.tar.gz &&
$MAKE CHICKEN=./chicken-boot dist &&
md5sum chicken-$VER.tar.gz > chicken-$VER.tar.gz.md5 &&
rm -rf chicken-$VER &&
tar zxf chicken-$VER.tar.gz &&
	(cd chicken-$VER &&
	$MAKE PREFIX=$PWD/inst &&         # Unfortunately `make check` requires chicken to be installed
	$MAKE PREFIX=$PWD/inst install &&
	$MAKE PREFIX=$PWD/inst check) &&
	rm -rf chicken-$VER &&
# can also make -f Makefile.macosx buildhead prior to this
echo "Copying tarball and md5 file to release location..." &&
scp "chicken-$VER.tar.gz" "chicken-$VER.tar.gz.md5" call-cc:/var/www/apache/code/stability/4.7.0/ &&
echo "Please update wiki.call-cc.org/stability" &&
exit 0


echo "*** release failed ***" >&2
exit 1
