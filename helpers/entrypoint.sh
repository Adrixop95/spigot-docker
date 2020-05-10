#!/bin/bash

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            XMS)              XMS=${VALUE} ;;
            XMX)    XMX=${VALUE} ;;     
            *)   
    esac    


done

echo "=== Java parameters ==="
echo "-Xms = -Xms$XMS"
echo "-Xmx = -Xmx$XMX" 
echo "================="


java -Xms$XMS -Xmx$XMX -jar spigot.jar