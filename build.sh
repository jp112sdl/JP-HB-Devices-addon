#!/bin/sh
COPYFILE_DISABLE=1; export COPYFILE_DISABLE
ADDON_NAME=jp-hb-devices

file=./patchsource/www/rega/esp/functions.fn
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/rega/esp/controls/rhs.fn
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/pda/eq3/controls/rhs.tcl
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/webui/webui.js
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/config/ic_common.tcl
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/rega/esp/datapointconfigurator.fn
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/rega/esp/channels.fn
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/webui/js/extern/sliderControl.js
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/ise/htm/header.htm
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/api/methods.conf
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/config/stringtable_de.txt
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/webui/js/lang/en/translate.lang.stringtable.js
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/webui/js/lang/de/translate.lang.js
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/webui/js/lang/de/translate.lang.extension.js
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch
file=./patchsource/www/webui/js/lang/de/translate.lang.stringtable.js
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/common/`basename ${file}`.patch

file=./patchsource/www/rega/pages/tabs/admin/views/programs.htm
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/le_343/`basename ${file}`.patch 
diff -u --label=${file}.orig --label=${file} ${file}.orig-3.45 ${file}-3.45 > ./src/addon/patch/ge_345/`basename ${file}`.patch
file=./patchsource/www/rega/esp/side.inc
diff -u --label=${file}.orig --label=${file} ${file}.orig ${file} > ./src/addon/patch/le_343/`basename ${file}`.patch 
diff -u --label=${file}.orig --label=${file} ${file}.orig-3.45 ${file}-3.45 > ./src/addon/patch/ge_345/`basename ${file}`.patch

echo "Patch created."

rm ${ADDON_NAME}-addon.tgz
cd src
chmod +x update_script
chmod +x addon/inst_*
chmod +x addon/update-check.cgi
chmod +x rc.d/*
find . -name ".DS_Store" -exec rm -rf {} \;
find . -name "._*" -exec rm -rf {} \;
dot_clean .
tar --exclude='untitled.txt' -zcf ../${ADDON_NAME}-addon.tgz * 
echo "tar created."
cd ..
