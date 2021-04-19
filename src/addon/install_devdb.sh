#!/bin/sh
DEVLISTFILE="/usr/local/addons/jp-hb-devices-addon/hb-devlist.csv"
DEVDBFILE="/www/config/devdescr/DEVDB.tcl"

while IFS=";" read -r DEVICE IMG; do
  if case $DEVICE in "HB-"*) true;; *) false;; esac; then
    DEVICE_IMG=${IMG}.png
    DEVICE_THUMB=${IMG}_thumb.png
    DEVDBINSERT="$DEVICE {{50 \/config\/img\/devices\/50\/$DEVICE_THUMB} {250 \/config\/img\/devices\/250\/$DEVICE_IMG}} "
  
    case "$1" in
        ""|install)
         echo "DEVDB.tcl install "$DEVICE
         if [ -z "`cat $DEVDBFILE | grep \"$DEVICE\"`" ]; then sed -i "s/\(array[[:space:]]*set[[:space:]]*DEV_PATHS[[:space:]]*{\)/\1$DEVDBINSERT/g" $DEVDBFILE; fi
        ;;
    
        uninstall)
         echo "DEVDB.tcl uninstall "$DEVICE
         sed -i "s/\($DEVDBINSERT\)//g" $DEVDBFILE
    
         rm -f /www/config/img/devices/250/$DEVICE_IMG
         rm -f /www/config/img/devices/50/$DEVICE_THUMB
        ;;
    esac
  fi

done < ${DEVLISTFILE}