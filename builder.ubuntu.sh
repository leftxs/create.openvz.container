#!/bin/sh
# Description:  Build OpenVz Container
# License:      GPL
# Version:      0.1
# Contributors: see docs/CONTRIBUTORS.txt
#=========================================

VZCTL="/usr/sbin/vzctl"
VZDIR="/vz"
VZLIST="/usr/sbin/vzlist"
INSTALL_LOG="test.log"

error_exit() {
        echo "$1"
        exit 1
}

# We want logs
if [ -f "$INSTALL_LOG" ]; then
    rm -f "$INSTALL_LOG"
fi
touch "$INSTALL_LOG" 2> /dev/null
if [ $? -gt 0 ]; then
    echo "Unable to write to ${INSTALL_LOG}; detailed log will go to stdout."
    INSTALL_LOG="/dev/stdout"
else
    echo "Detailed installation log being written to $INSTALL_LOG"
    echo "Detailed installation log" > "$INSTALL_LOG"
    echo "Starting at `date`" >> "$INSTALL_LOG"
fi

seelog () {
    echo
    echo "Installation has failed."
    echo "See the detailed installation log at $INSTALL_LOG"
    echo "to determine the cause."
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


$VZCTL create "$NEWID" --ostemplate "ubuntu-12.04-x86_64" && \
$VZCTL set "$NEWID" --ipadd "10.1.1.169" --save && \
$VZCTL set "$NEWID" --hostname "ubuntu12-04-installer-test" --save && \
$VZCTL set "$NEWID" --nameserver 8.8.8.8 --save && \
$VZCTL set "$NEWID" --ram "1G" --swap "1G" --save && \
$VZCTL set "$NEWID" --diskspace "8G":"10G" --save && >> "$INSTALL_LOG" 2>&1
#$VZCTL set "$NEWID" --onboot yes --save && \

echo
echo "Container $NEWID has been created. You can start it like this:"
echo "vzctl start $NEWID"
echo
echo "Starting new Container"
vzctl start $NEWID >> "$INSTALL_LOG" 2>&1

# Todo: if script was runningthorugh without any error, upload logfile to
# buildmaster, if there were erros send mail and tell them to check errors
