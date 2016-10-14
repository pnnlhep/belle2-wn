#!/bin/bash -e

export REPO=belle.cern.ch

if [ "x$REPO" == "x" ];
then
        echo You must specify the repo with ENV REPO
        exit -1
fi

umount "/cvmfs/$REPO" || true

uid=$(getent passwd cvmfs | awk -F: '{print $3}')
gid=$(getent group cvmfs | awk -F: '{print $3}')

chown $uid.$gid /var/lib/cvmfs
chmod 770 /var/lib/cvmfs

mkdir -p /var/run/cvmfs
chown $uid.$gid /var/run/cvmfs

trap "umount /cvmfs/$REPO" TERM
/usr/bin/cvmfs2 -f -o rw,fsname=cvmfs2,allow_other,grab_mountpoint,uid=$uid,gid=$gid $REPO /cvmfs/$REPO
