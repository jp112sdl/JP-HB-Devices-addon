#!/bin/sh
ADDON_NAME=jp-hb-devices
rm ${ADDON_NAME}-addon.tgz
cd src
chmod +x update_script
chmod +x addon/install_*
chmod +x addon/uninstall_*
chmod +x addon/update-check.cgi
chmod +x rc.d/*
find . -name ".DS_Store" -exec rm -rf {} \;
find . -name "._*" -exec rm -rf {} \;
dot_clean .
tar -zcvf ../${ADDON_NAME}-addon.tgz *
cd ..
