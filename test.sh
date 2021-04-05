#!/bin/bash
DIR_PREFIX=/tmp
MOUNT_DIR=$DIR_PREFIX/ccu-fw-tmp
WORK_DIR=$DIR_PREFIX/www
IMG_SRC_PATH=~/Desktop/Homematic/Software/images
ADDON_FILE=~/Desktop/Homematic/jp-hb-devices-addon/jp-hb-devices-addon.tgz

ADDON_DIR=${DIR_PREFIX}/addon
PATCH_DIR=${ADDON_DIR}/addon/patch
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
 
 echo "Found firmware version $model.$version.$build - using patch subdirectory version ${PATCHSUBDIR_VERSION}" | tee -a $TMP_LOGFILE
}

convert_lf() 
{
  filename=`sed -n '2p' $1 | sed 's/+++ .\/patchsource//g' | awk {'print $1'}`
  dos2unix -q $DIR_PREFIX$filename 2>&1
  
  cmpresult=`unix2dos < $DIR_PREFIX$filename | cmp - $DIR_PREFIX$filename`
  if [ "$cmpresult" ]; then
    cmpresult=`dos2unix -q < $1 | cmp - $1`
    if [ "$cmpresult" ]; then
      echo "dos2unix conversion needed for $1" >> $TMP_LOGFILE
      dos2unix -q $1 >> $TMP_LOGFILE
    fi
  fi
}

for filename in ${IMG_SRC_PATH}/[R,c]*.*
do 
  
  echo "Mounting $(basename $filename)"
  #[[ -d $MOUNT_DIR ]] && rm -rf $MOUNT_DIR
  
  [[ -d $WORK_DIR ]]  && rm -rf $WORK_DIR
  if [ ${filename: -5} == ".ext4" ]; then 
    ext4fuse ${filename} ${MOUNT_DIR}; 
    echo "Serving /www for $(basename $filename)"
    mkdir $WORK_DIR
    rsync -a --links --exclude=".*" ${MOUNT_DIR}/www/ $WORK_DIR/ 
    check_ccu_fw_version
    umount ${MOUNT_DIR}
  fi
  
  if [ ${filename: -4} == ".ubi" ]; then
    [[ -d $MOUNT_DIR ]] && rm -rf $MOUNT_DIR
    ubireader_extract_files ${filename} -o ${MOUNT_DIR}
    echo "Serving /www for $(basename $filename)"
    cd ${MOUNT_DIR}
    find . -depth 2 -type d -name root -print0 | xargs -0 -I {} mv {}/www ../
    find . -depth 2 -type d -name root -print0 | xargs -0 -I {} mv {}/boot ./
    check_ccu_fw_version
    [[ -d $MOUNT_DIR ]] && rm -rf $MOUNT_DIR
  fi

  chmod -R +w $WORK_DIR

  TMP_LOGFILE=${DIR_PREFIX}/patch-$(basename $filename).log
  
  [[ -f ${TMP_LOGFILE} ]] && rm ${TMP_LOGFILE}
  
  [[ ! -d ${ADDON_DIR} ]] && mkdir ${ADDON_DIR}
  cp ${ADDON_FILE} ${ADDON_DIR}/
  cd ${ADDON_DIR}/
  tar xzf ./$(basename $ADDON_FILE)

  cd $WORK_DIR

  echo "######## APPLY COMMON PATCHES ########" >> $TMP_LOGFILE
  for patchfile in ${PATCH_DIR}/${PATCHSUBDIR_COMMON}/* ; do
    echo "### Applying ${PATCHSUBDIR_COMMON} patch file $(basename $patchfile)"  >> $TMP_LOGFILE
    convert_lf $patchfile
    patch -p3 -i $patchfile >> $TMP_LOGFILE 2>>$TMP_LOGFILE
    echo "- done" >> $TMP_LOGFILE
  done
  
  echo "######## APPLY VERSION DEPENDEND PATCHES ########" >> $TMP_LOGFILE
  for patchfile in ${PATCH_DIR}/${PATCHSUBDIR_VERSION}/* ; do
    echo "Applying ${PATCHSUBDIR_VERSION} patch file $(basename $patchfile)" >> $TMP_LOGFILE
    convert_lf $patchfile
    patch -p3 -i $patchfile >> $TMP_LOGFILE 2>>$TMP_LOGFILE
    echo "- done" >> $TMP_LOGFILE
  done
  
  cd ${DIR_PREFIX}
  [[ -d $WORK_DIR ]]  && rm -rf $WORK_DIR
done

echo " "
echo "***********************************************"
echo " "

for filename in ${IMG_SRC_PATH}/[R,c]*.*
do
  echo "Checking Logs for Errors in $(basename $filename):"
  
  TMP_LOGFILE=${DIR_PREFIX}/patch-$(basename $filename).log
  
  grep -i -E 'fail|err|fuzz' ${TMP_LOGFILE}
  
  echo "----"
done