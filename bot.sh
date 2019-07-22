#!/bin/bash

# Copyright (C) 2019 Ayush Dubey <ayushdubey70@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only


# Telegram
source ~/telegram-jenkins-bot/bot-config.conf

sendMessage() {
MESSAGE=$1

curl -s "https://api.telegram.org/bot${BOT_API_KEY}/sendmessage" --data "text=$MESSAGE&chat_id=$CHAT_ID" 1> /dev/null

echo -e;
}

# Set defaults
MAKE_TARGET="bacon"
CCACHE_DIR="$HOME/.ccache"
OUT_DIR="out"

# ccache
export USE_CCACHE=1
ccache -M 100G

# Switch to source directory
cd $ROM_DIR

# Date and time
export BUILDDATE=$(date +%Y%m%d)
export BUILDTIME=$(date +%H%M)

# Build Notification
sendMessage "Starting build (for-$DEVICE-$BUILDDATE)"

# Log for Build
sendMessage "Logging to file log-$BUILDDATE-$BUILDTIME.txt"
export LOGFILE=log-$BUILDDATE-$BUILDTIME.txt

# Repo sync
sendMessage "Starting repo sync. Executing command: repo sync -f --force-sync --no-tags --no-clone-bundle -c"
repo sync -f --force-sync --no-tags --no-clone-bundle -c -$CPU_INFO
sendMessage "repo sync finished."

# Lunch
source build/envsetup.sh
sendMessage "Starting lunch... Lunching $DEVICE"
lunch $ROM_$DEVICE-$BUILD_TYPE

# Aaaand... begin compilation!"
# Equivalent of "mka" command, modified to use 2 x (no. of cores) threads for compilation
sendMessage "Starting build... Building target $DEVICE"
if schedtool -B -n 1 -e ionice -n 1 make -j$(($(nproc --all) * 2)) "$MAKE_TARGET"; then
# LAUNCH PROGRESS OBSERVER
sleep 60
while test ! -z "$(pidof soong_ui)"; do
        sleep 300
        # Get latest percentage
        PERCENTAGE=$(cat $LOGFILE | tail -n 1 | awk '{ print $2 }')
        # REPORT PerCentage to the Group
        sendMessage "Current percentage: $PERCENTAGE"
      done
EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then sendMessage "Build failed! Check log file $LOGFILE"; sendMessage $LOGFILE; exit 1; fi
sendMessage "Build finished successfully! Uploading new build..."

        # Get the path of the output zip. Few ROMs generate an intermediate otapackage zip
    		# along with the actual flashable zip, so in order to pick that one out, I'll be
    		# using a simple logic. Most of the ROMs that generate the intermediate zip also
    		# generate an md5sum of the actual flashable zip. I'll simply get the filename
    		# of that md5sum and put .zip in front of it to get the actual zip's path! :)
    		if [ "$(ls "$OUT_DIR/target/product/$DEVICE/*.zip" | wc -l)" -gt 1 ]; then
    			zippath=$(sed "s/\.md5sum//" <<< "$(ls "$OUT_DIR"/target/product/"$DEVICE"/*.md5sum)")
    		else
    			zippath=$(ls "$OUT_DIR/target/product/$DEVICE/*.zip")
    		fi
# Upload the ROM to google drive if it's available, else upload to transfer.sh
if [ -x "$(command -v gdrive)" ]; then
sendMessage "Uploading ROM to Google Drive using gdrive CLI ..."
# In some cases when the gdrive CLI is not set up properly, upload fails.
# In that case upload it to transfer.sh itself
	if ! gdrive upload --share "$zippath"; then
      sendMessage "An error occured while uploading to Google Drive."
      sendMessage "Uploading ROM zip to transfer.sh..."
      sendMessage "ROM zip uploaded succesfully to $(curl -sT "$zippath" https://transfer.sh/"$(basename "$zippath")")"
          fi
        		else
        			sendMessage "Uploading ROM zip to transfer.sh..."
        			sendMessage "ROM zip uploaded succesfully to $(curl -sT "$zippath" https://transfer.sh/"$(basename "$zippath")")"
            fi

# Move the zip to the root of the source to prevent conflicts in future builds
cp "$zippath" .
rm -rf "$OUT_DIR"/target/product/"$DEVICE"/*.zip*
sendMessage "ROM zip copied to source directory; deleted from outdir. Good bye!"
		exit 0
	sendMessage "$MAKE_TARGET compiled succesfully :-) Good bye!"; fi
fi

#Final
sendMessage "TEST PLEASE. $USERNAME"
sendMessage "Developer $DEV_USERNAME"
sendMessage "Sending Build LOGFILE"
sendMessage "$LOGFILE"

exit;
