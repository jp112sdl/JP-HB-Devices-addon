#!/bin/bash
set -e
set -o pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

DIR_PREFIX=${DIR_PREFIX:="${SCRIPT_DIR}/rm-snapshot-test"}
MOUNT_DIR=${DIR_PREFIX}/rm-image-mount
WWW_DIR=${DIR_PREFIX}/www
RM_NIGHTLY_DIR=${DIR_PREFIX}/rm-snapshot
RM_NIGHTLY_URL=$(curl -sSL -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/jens-maus/RaspberryMatic/releases/22744592/assets | jq -r '.[] | select(.name | endswith("ccu3.tgz")) | .browser_download_url')
IMAGEFILENAME=${DIR_PREFIX}/rm-snapshot/rootfs.ext4
PATCH_DIR=${SCRIPT_DIR}/src/addon/patch
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

hasCarriageReturn() {
  grep -q $'\r' $1
  return $?
}

removeCarriageReturn()
{
  FILE=`sed -n '2p' $1 | sed 's/+++ .\/patchsource//g' | awk {'print $1'}`
  if ! hasCarriageReturn ${DIR_PREFIX}${FILE} && hasCarriageReturn $1; then
    echo "dos2unix conversion needed for $1"
    sed -i 's/\r$//' $1
  elif hasCarriageReturn ${DIR_PREFIX}${FILE} && ! hasCarriageReturn $1; then
    echo "unix2dos conversion needed for $1"
    sed -i "s/\$/\r/" $1
  fi
}

#Ordner erstellen, RM herunterladen, entpacken
[[ -d ${RM_NIGHTLY_DIR} ]] && rm -rf ${RM_NIGHTLY_DIR}
mkdir -p ${RM_NIGHTLY_DIR}
cd ${RM_NIGHTLY_DIR}
echo "Downloading Nightly" ${RM_NIGHTLY_URL}
wget -q -O ./rm-nightly.tgz ${RM_NIGHTLY_URL}
echo "Unpacking .tgz"
tar -xf rm-nightly.tgz
echo "Decompressing .ext4 image"
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

#Patche anwenden

PATCH_ERROR=0

applyPatch() {
  removeCarriageReturn $1
  RES="$(patch --binary -p3 -i $1)"
  e=$?
  if [ $e -gt 0 ]; then
    PATCH_ERROR=$e
    echo -e "\033[31m""${RES}""\e[0m"
  else
    echo "$RES"
  fi
  echo
}

cd $WWW_DIR

set +e

echo
echo "######## APPLY COMMON PATCHES ########"
for patchfile in ${PATCH_DIR}/${PATCHSUBDIR_COMMON}/* ; do
  echo "### Applying ${PATCHSUBDIR_COMMON} patch file $(basename $patchfile)"
  applyPatch $patchfile
done

echo
echo

echo "######## APPLY VERSION DEPENDEND PATCHES ########"
for patchfile in ${PATCH_DIR}/${PATCHSUBDIR_VERSION}/* ; do
  echo "Applying ${PATCHSUBDIR_VERSION} patch file $(basename $patchfile)"
  applyPatch $patchfile
done

set -e


echo " "
echo "***********************************************"
echo " "

if [ $PATCH_ERROR -gt 0 ]; then
  echo -e "\033[31mERRORS occurred\e[0m"
  exit 1
else
  echo -e "\033[32mAll tests passed\e[0m"
fi
