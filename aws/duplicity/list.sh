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

DSTDIR=$1
if [ -z "$DSTDIR" ]; then
    echo "You must specify the destination directory"; exit 1
fi
DST="s3+http://$BUCKET/$DSTDIR"

OPT="--encrypt-key=$KEYPRINT list-current-files"

EXTRA=$2
if [ -n "$EXTRA" ]; then
    OPT="$OPT $EXTRA"
fi

duplicity $OPT $DST

# clear the sensitive data out of the environment
export PASSPHRASE=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

