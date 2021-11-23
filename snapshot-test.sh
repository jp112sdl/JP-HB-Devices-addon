#!/bin/bash
set -eo pipefail
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

DIR_PREFIX=${DIR_PREFIX:="${SCRIPT_DIR}/rm-snapshot-test"}
MOUNT_DIR=${DIR_PREFIX}/rm-image-mount
WWW_DIR=${DIR_PREFIX}/www
RM_NIGHTLY_DIR=${DIR_PREFIX}/rm-snapshot
RM_NIGHTLY_URL=$(curl -sSL -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/jens-maus/RaspberryMatic/releases/22744592/assets | jq -r '.[] | select(.name | endswith("ccu3.tgz")) | .browser_download_url')
IMAGEFILENAME=${DIR_PREFIX}/rm-snapshot/rootfs.ext4
ADDON_DIR=${DIR_PREFIX}/addon
PATCH_DIR=${DIR_PREFIX}/addon/JP-HB-Devices-addon/src/addon/patch
PATCHSUBDIR_VERSION=le_343
PATCHSUBDIR_COMMON=common

check_ccu_fw_version()
{
 model=`grep VERSION ${MOUNT_DIR}/boot/VERSION   | awk -F'[=.]' {'print $2'}`
 version=`grep VERSION ${MOUNT_DIR}/boot/VERSION | awk -F'[=.]' {'print $3'}`
 build=`grep VERSION ${MOUNT_DIR}/boot/VERSION   | awk -F'[=.]' {'print $4'}`

 if [ $model -ge 2 ] && [ $version -ge 45 ]; then
  PATCHSUBDIR_VERSION=ge_345
 fi

 echo "Found firmware version $model.$version.$build - using patch subdirectory version ${PATCHSUBDIR_VERSION}"
}

convert_lf()
{
  FILE=`sed -n '2p' $1 | sed 's/+++ .\/patchsource//g' | awk {'print $1'}`
  if ! unix2dos < ${DIR_PREFIX}${FILE} | tail -n +1 | cmp -s - ${DIR_PREFIX}${FILE} ; then
    if ! dos2unix -q < $1 | cmp -s - $1; then
      echo "dos2unix conversion needed for $1"
      dos2unix -q $1
    fi
  fi
}

#Ordner erstellen, RM herunterladen, entpacken
[[ -d ${RM_NIGHTLY_DIR} ]] && rm -rf ${RM_NIGHTLY_DIR}
mkdir -p ${RM_NIGHTLY_DIR}
cd ${RM_NIGHTLY_DIR}
echo "Downloading Nightly"
wget -q -O ./rm-nightly.tgz ${RM_NIGHTLY_URL}
echo "Untar"
tar -xf rm-nightly.tgz
echo "gzip -d"
gzip -d rootfs.ext4.gz

#Mount
echo "Mounting $(basename $IMAGEFILENAME)"

[[ -d $WWW_DIR ]]  && rm -rf $WWW_DIR
mkdir -p ${MOUNT_DIR}
sudo mount ${IMAGEFILENAME} ${MOUNT_DIR};
echo "Serving /www for $(basename $IMAGEFILENAME)"
mkdir -p $WWW_DIR
rsync -a --links --exclude=".*" ${MOUNT_DIR}/www/ $WWW_DIR/
check_ccu_fw_version
sudo umount ${MOUNT_DIR}

chmod -R +w $WWW_DIR

#Addon klonen
[[ -d ${ADDON_DIR} ]] && rm -rf ${ADDON_DIR}
mkdir -p ${ADDON_DIR}
cd ${ADDON_DIR}
git clone https://github.com/jp112sdl/JP-HB-Devices-addon.git

#Patche anwenden

ERROR_LOGFILE=${DIR_PREFIX}/patch-$(basename $IMAGEFILENAME).log
[[ -f ${ERROR_LOGFILE} ]] && rm ${ERROR_LOGFILE}

cd $WWW_DIR

set +e

echo "######## APPLY COMMON PATCHES ########"
for patchfile in ${PATCH_DIR}/${PATCHSUBDIR_COMMON}/* ; do
  echo "### Applying ${PATCHSUBDIR_COMMON} patch file $(basename $patchfile)"
  convert_lf $patchfile
  patch -p3 -i $patchfile 2>>$ERROR_LOGFILE
  echo "- done"
done

echo "######## APPLY VERSION DEPENDEND PATCHES ########"
for patchfile in ${PATCH_DIR}/${PATCHSUBDIR_VERSION}/* ; do
  echo "Applying ${PATCHSUBDIR_VERSION} patch file $(basename $patchfile)"
  convert_lf $patchfile
  patch -p3 -i $patchfile 2>>$ERROR_LOGFILE
  echo "- done"
done

set -e

cd ${DIR_PREFIX}
[[ -d $WWW_DIR ]]  && rm -rf $WWW_DIR

echo " "
echo "***********************************************"
echo " "

if [ -s "$ERROR_LOGFILE" ]; then
  echo '### ERRORS:'
  cat $ERROR_LOGFILE
  exit 1
else
  echo 'All tests pass'
fi
