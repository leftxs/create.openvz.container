#!/bin/sh
# Description:  OpenVZ container creation script
# License:      GPL
# Version:      0.1
# Contributors: see docs/CONTRIBUTORS.txt
#=========================================

VZCTL="/usr/sbin/vzctl"
VZDIR="/vz"
VZLIST="/usr/sbin/vzlist"

error_exit() {
        echo "$1"
        exit 1
}

[ -x "$VZCTL" ]         || error_exit "Can't run $VZCTL"
[ -d "$VZDIR" ]         || error_exit "Directory $VZDIR does not exist"
[ -x "$VZLIST" ]        || error_exit "Can't run $VZLIST"

CURID=$(cd $VZDIR/private; ls -d * 2>/dev/null | grep -v 666 | sort -n | tail -1)
if [ -z "$CURID" ]; then
        NEWID="100"
else
        $VZLIST --all | grep -q "$CURID"        || error_exit "Directory $VZDIR/private/$CURID exists, but no container is configured for it"
        NEWID=$(($CURID + 1))                   || error_exit "Could not find next available ID"
fi

echo
echo "Available templates:"
ls $VZDIR/template/cache/ | sed "s/\.tar\.gz$//"

echo
read -p "Enter template name:    " VZTMPLT
[ -f "$VZDIR/template/cache/$VZTMPLT.tar.gz" ]  || error_exit "Template does not exist"
read -p "Enter hostname (fqdn):  " VZHOST
read -p "Enter IP address:       " VZIP
read -p "Ram: like 512M or 1G	 " VZRAM
read -p "Swap: like 1G or 2G	 " VZSWAP
read -p "Disk qouta: like 1G or 2G" DISKQOUTA
read -p "Disk boost: like 1G or 2G" DISKBOOST
read -p "Create container? [y/N] " CREATE

case "$CREATE" in
        y | yes | Y | YES | Yes )

                $VZCTL create "$NEWID" --ostemplate "$VZTMPLT" && \
                $VZCTL set "$NEWID" --ipadd "$VZIP" --save && \
                $VZCTL set "$NEWID" --hostname "$VZHOST" --save && \
                $VZCTL set "$NEWID" --nameserver 8.8.8.8 --save && \
                $VZCTL set "$NEWID" --ram "$VZRAM" --swap "$VZSWAP" --save && \
	        $VZCTL set "$NEWID" --diskspace "$DISKQOUTA":"$DISKBOOST" --save && \
                $VZCTL set "$NEWID" --onboot yes --save && \
                echo
                echo "Container $NEWID has been created. You can start it like this:"
                echo "vzctl start $NEWID"
                echo
                ;;

        * )
                echo "Not creating container $NEWID..."
                echo
                ;;
esac

