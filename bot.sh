#!/bin/bash
# Copyright (C) 2019-2020 Ayush Dubey <ayushdubey70@gmail.com>
# SPDX-License-Identifier: MIT License
# shellcheck disable=SC1090,SC1091,2153,2154,2155,2164
# SC1090:ShellCheck can't follow non-constant source. Use a directive to specify location.
# SC1091:Not following: (error message here)
# SC2153:Possible Misspelling: MYVARIABLE may not be assigned, but MY_VARIABLE is.
# SC2154:is referenced but not assigned.
# SC2155:Declare and assign separately to avoid masking return values
# SC2164:Use 'cd ... || exit' or 'cd ... || return' in case cd fails.

# Telegram
source ~/telegram-jenkins-bot/bot-config.conf

sendMessage() {
  MESSAGE=$1

  curl -s "https://api.telegram.org/bot${BOT_API_KEY}/sendmessage" --data "text=$MESSAGE&chat_id=$CHAT_ID" 1>/dev/null

  echo -e
}

# Cache
export CCACHE_EXEC="$(command -v ccache)"
export USE_CCACHE=1
export CCACHE_DIR=/home/$username/.cache
ccache -M 500G
export _JAVA_OPTIONS=-Xmx16g

# Switch to source directory
cd "$ROM_DIR"

# Clean
if [[ ${CLEAN} =~ ^(clean|deviceclean|installclean)$ ]]; then
  m "${CLEAN}"
else
  rm -rf "${OUT}"*
fi

# Date and time
export BUILDDATE=$(date +%Y%m%d)
export BUILDTIME=$(date +%H%M)

# Build Notification
sendMessage "Starting build for ${DEVICE}-${BUILDDATE}-${BUILDTIME} build, check progress here ${BUILD_URL}"

# Log for Build
sendMessage "Logging to file log ${BUILDDATE}-${BUILDTIME}.txt"
export LOGFILE=log-${BUILDDATE}-${BUILDTIME}.txt

# Repo sync
sendMessage "Starting repo sync. Executing command: repo sync -f --force-sync --no-tags --no-clone-bundle -c -j$(nproc)"
time repo sync --force-sync --no-tags --no-clone-bundle -c -j"$(nproc)"
sendMessage "Repo Sync Finished."

# Lunch
source build/envsetup.sh
sendMessage "Lunching ${DEVICE}-${BUILD_TYPE}
lunch ${ROM}\_${DEVICE}-${BUILD_TYPE}

# Aaaand... begin compilation!"
# Equivalent of "mka" command, modified to use 2 x (no. of cores) threads for compilation
if mka "${MAKE_TARGET}"; then
  sendMessage "${DEVICE} build is done, check ${BUILD_URL}) for details!"
  EXITCODE=$?
  if [ $EXITCODE -ne 0 ]; then
    sendMessage "Build failed! Check log file ${LOGFILE}"
    sendMessage "${LOGFILE}"
    exit 1
  fi
  sendMessage "Build finished successfully! for ${DEVICE}  Uploading Build"

  # Get the path of the output zip. Few ROMs generate an intermediate otapackage zip
  # along with the actual flashable zip, so in order to pick that one out, I'll be
  # using a simple logic. Most of the ROMs that generate the intermediate zip also
  # generate an md5sum of the actual flashable zip. I'll simply get the filename
  # of that md5sum and put .zip in front of it to get the actual zip's path! :)
  zipdir=$(get_build_var PRODUCT_OUT)
  zippath=$(find "$zipdir"/*2020*.zip | tail -n -1)

  #Upload to Gdrive or Transfer.sh
  if [ "$UPLOAD" = "rclone" ]; then
    sendMessage "Uploading ROM to Google Drive using gdrive CLI "
    rclone copy "$zippath" gdrive:"${UPLOAD_FOLDER}"
    FOLDER_LINK="$(rclone link grive:"$UPLOAD_FOLDER")"
    sendMessage "Build Uploaded Here $FOLDER_LINK"
  else
    sendMessage "Uploading ROM zip to transfer.sh"
    sendMessage "ROM zip uploaded succesfully to: $(curl -sT "$zippath" https://transfer.sh/"$(basename "$zippath")")"
  fi
  sendMessage "$MAKE_TARGET compiled succesfully in  $((SECONDS / 60)) minute and $((SECONDS % 60)) second, Good bye!"
fi

#Final
sendMessage "TEST PLEASE $USERNAME"
sendMessage "Developer $DEV_USERNAME"
sendMessage "Sending Build LOGFILE"
sendMessage "$LOGFILE"

exit;