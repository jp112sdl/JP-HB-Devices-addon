#!/bin/sh

case "$1" in
    ""|install)
    
     mkdir -p /www/config/easymodes/KEY/localization/de
     mkdir -p /www/config/easymodes/KEY/localization/en
     mkdir -p /www/config/easymodes/KEY/localization/tr
     
     if [ ! -e /www/config/easymodes/KEY/localization/de/GENERIC.txt ]; then
      cp /www/config/easymodes/BLIND/localization/de/GENERIC.txt /www/config/easymodes/KEY/localization/de/
     fi                                                                                                    
                                                                                                           
     if [ ! -e /www/config/easymodes/KEY/localization/de/KEY.txt ]; then                                   
      cp /www/config/easymodes/BLIND/localization/de/KEY.txt /www/config/easymodes/KEY/localization/de/    
     fi                                                                                                    
                                                                                                           
     if [ ! -e /www/config/easymodes/KEY/localization/en/GENERIC.txt ]; then                               
      cp /www/config/easymodes/BLIND/localization/en/GENERIC.txt /www/config/easymodes/KEY/localization/en/
     fi                                                                                                    
                                                                                                           
     if [ ! -e /www/config/easymodes/KEY/localization/en/KEY.txt ]; then                                   
      cp /www/config/easymodes/BLIND/localization/en/KEY.txt /www/config/easymodes/KEY/localization/en/    
     fi                                                                                                    
                                                                                                           
     #if [ ! -e /www/config/easymodes/KEY/localization/tr/GENERIC.txt ]; then                               
     # cp /www/config/easymodes/BLIND/localization/tr/GENERIC.txt /www/config/easymodes/KEY/localization/tr/
     #fi                                                                                                    
                                                                                                           
     #if [ ! -e /www/config/easymodes/KEY/localization/tr/KEY.txt ]; then                                   
     # cp /www/config/easymodes/BLIND/localization/tr/KEY.txt /www/config/easymodes/KEY/localization/tr/    
     #fi 
     
     chmod -R 755 /www/config/easymodes/KEY/localization/ 

     ### Edit channels.html ###
     channelsFile="/www/rega/esp/channels.htm"

     channelsInsert="\n<%  if (action == \"servoOldVal\")     { Call(\"channels.fn::servoOldVal()\"); } %>"
     if [ -z "`cat $channelsFile | grep \"servoOldVal"`" ]; then echo -e $channelsInsert >> $channelsFile; fi

     channelsInsert="\n<%  if (action == \"fanOldVal\")     { Call(\"channels.fn::fanOldVal()\"); } %>"
     if [ -z "`cat $channelsFile | grep \"fanOldVal"`" ]; then echo -e $channelsInsert >> $channelsFile; fi

     channelsInsert="\n<%  if (action == \"airflapOldVal\")     { Call(\"channels.fn::airflapOldVal()\"); } %>"
     if [ -z "`cat $channelsFile | grep \"airflapOldVal"`" ]; then echo -e $channelsInsert >> $channelsFile; fi

    ;;

    uninstall)

     channelsFile="/www/rega/esp/channels.htm"
     
     channelsSearch="servoOldVal"
     sed -i "/\(${channelsSearch}\)/d" $channelsFile
     channelsSearch="fanOldVal"
     sed -i "/\(${channelsSearch}\)/d" $channelsFile
     channelsSearch="airflapOldVal"
     sed -i "/\(${channelsSearch}\)/d" $channelsFile
     
    ;;     
esac
