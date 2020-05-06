#!/bin/sh
export BASEDIR=/ipns/opensuse.zq1.de
for ver in `cat /ipns/opensuse.zq1.de/history/list |grep 20200|tac` ; do
  ./indexhdrmd5fast2 /ipns/opensuse.zq1.de/history/$ver
done
