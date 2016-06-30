#!/bin/bash
FOLDER="/etc/factorio"
NEW_SERVER="factorio.tar.gz"
CURRENT_SERVER="factoio.tar.gz.last"

echo "Downloading new server version..."
/usr/bin/wget -q https://www.factorio.com/get-download/0.12.35/headless/linux64 --no-check-certificate -O $FOLDER/$NEW_SERVER

if [ ! -f "$NEW_SERVER" ]
then
    echo "New server was not downloaded! Check internet connection!"
    exit 1
else
    echo "Downloaded!"
fi

hash_new=`/usr/bin/md5sum $FOLDER/$NEW_SERVER | /usr/bin/awk '{print $1}'`
hash_old=`/usr/bin/md5sum $FOLDER/$CURRENT_SERVER | /usr/bin/awk '{print $1}'`

echo "Prepare to compare hashes..."
echo "New hash: $hash_new"
echo "Old hash: $hash_old"

if [ "$hash_new" = "$hash_old" ]
then
    echo "Identical, nothing to upgrade!";
else
    /usr/sbin/service factorio stop
    echo "Upgrading...";
    /bin/mv $FOLDER/$NEW_SERVER $FOLDER/$CURRENT_SERVER;
    /bin/tar -zxf $FOLDER/$CURRENT_SERVER --overwrite -C $FOLDER;
    echo "Done!";
    echo "Please start Factorio server with SAVENAME as you need!"
fi
