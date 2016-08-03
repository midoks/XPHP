#! /bin/bash

set -euo pipefail

DOWNLOAD_URI=https://github.com/midoks/XPHP/archive/v0.6.tar.gz
PLUGINS_DIR="${HOME}/Library/Application Support/Alcatraz/Plug-ins"
XCODE_VERSION="$(xcrun xcodebuild -version | head -n1 | awk '{ print $2 }')"
PLIST_PLUGINS_KEY="DVTPlugInManagerNonApplePlugIns-Xcode-${XCODE_VERSION}"
BUNDLE_ID="com.midoks.XPHP"
TMP_FILE="$(mktemp -t ${BUNDLE_ID})"


echo "defaults read com.apple.dt.Xcode $PLIST_PLUGINS_KEY &> $TMP_FILE"

if defaults read com.apple.dt.Xcode "$PLIST_PLUGINS_KEY" &> "$TMP_FILE"; then

	/usr/libexec/PlistBuddy -c "delete skipped:$BUNDLE_ID" "$TMP_FILE" > /dev/null 2>&1 && {
        pgrep Xcode > /dev/null && {
            echo 'An instance of Xcode is currently running.' \
                 'Please close Xcode before installing Alcatraz.'
            exit 1
        }
        defaults write com.apple.dt.Xcode "$PLIST_PLUGINS_KEY" "$(cat "$TMP_FILE")"
        echo 'XPHP was removed from Xcode'\''s skipped plugins list.' \
             'Next time you start Xcode select "Load Bundle" when prompted.'
    }

else
	KNOWN_WARNING="The domain/default pair of \(.+, $PLIST_PLUGINS_KEY\) does not exist"

	tr -d '\n' < "$TMP_FILE" | egrep -v "$KNOWN_WARNING" && exit 1

fi

mkdir -p "${PLUGINS_DIR}"

curl -L $DOWNLOAD_URI | tar xvz -C "${PLUGINS_DIR}"

if [ $? -eq 0 ];then
	cd "${PLUGINS_DIR}" && mv "XPHP-0.6" "XPHP"

	cd "XPHP"

	xcodebuild -project XPHP.xcodeproj clean
	xcodebuild -project XPHP.xcodeproj build | tee xcodebuild.log

fi

beer='🍻'
omg_one_meme='!!!!'
echo "XPHP successfully installed$omg_one_meme$beer " \
     "Please restart your Xcode ($XCODE_VERSION)."