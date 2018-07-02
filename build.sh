#!/bin/sh
ADDON_NAME=jp-hb-devices
rm ${ADDON_NAME}-addon.tgz
cd src
chmod +x update_script
chmod +x addon/install
chmod +x addon/uninstall
chmod +x addon/update-check.cgi
chmod +x rc.d/*
find . -name ".DS_Store" -exec rm -rf {} \;
find . -name "._*" -exec rm -rf {} \;
tar -zcvf ../${ADDON_NAME}-addon.tgz *
cd ..
