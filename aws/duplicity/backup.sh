#!/bin/sh
# Set pass phrase for GnuPG key that you created earlier.
export PASSPHRASE=""
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# Make sure duplicity is not already running and if so exit.
if [ `ps aux | grep -v "grep" | grep --count "duplicity"` -gt 0 ]; then
    echo "duplicity is already running!"
    exit 1
fi

BUCKET=perseids_data_backups # Put your bucket name here
KEYPRINT= # Put your gpg key here

SRC=$1
if [ -z "$SRC" ]; then
    echo "You must specify the source directory"; exit 1
fi
DSTDIR=$2
if [ -z "$DSTDIR" ]; then
    echo "You must specify the destination directory"; exit 1
fi
DST="s3+http://$BUCKET/$DSTDIR"

OPT="--encrypt-key=$KEYPRINT --full-if-older-than  1W --s3-use-new-style  --log-file=/var/log/duplicity"

EXTRA=$3
if [ -n "$EXTRA" ]; then
    OPT="$OPT $EXTRA"
fi

duplicity $OPT $SRC $DST

# clear the sensitive data out of the environment
export PASSPHRASE=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

