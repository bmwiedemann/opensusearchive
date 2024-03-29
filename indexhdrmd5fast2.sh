#!/bin/sh
ipns=`ipfs resolve /ipns/opensuse.zq1.de`
export BASEDIR=$ipns
ipfs cat --progress=false $ipns/history/list > .ipfs.progress
vers=$(diff .ipfs.done .ipfs.progress |perl -ne 'if(m/^> (.*)/){print "$1\n"}'|tac)
[ -n "$vers" ] || exit 0
for ver in $vers ; do
  ./indexhdrmd5fast2 $ipns/history/$ver
done
cp -af .ipfs.progress .ipfs.done
#echo TODO rsync -aPzv hdrmd5cid.db{,.txt} hotel.zq1.de.:~/code/cvs/opensusearchive/
#echo press enter
#read
#rsync -aPzv hdrmd5cid.db{,.txt} hotel.zq1.de.:~/code/cvs/opensusearchive/
