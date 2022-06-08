#!/bin/bash

SIGN_DIR=$1
DEVELOPER_ID=$2
ENTITLEMENTS_FILE=$3

if [ -z "$SIGN_DIR" ]; then
    echo "error: missing directory argument"
    exit 1
elif [ -z "$DEVELOPER_ID" ]; then
    echo "error: missing developer id argument"
    exit 1
elif [ -z "$ENTITLEMENTS_FILE" ]; then
    echo "error: missing entitlements file argument"
    exit 1
fi

echo "======== INPUTS ========"
echo "Directory: $SIGN_DIR"
echo "Developer ID: $DEVELOPER_ID"
echo "Entitlements: $ENTITLEMENTS_FILE"
echo "======== END INPUTS ========"

sign() {
    FILE_TO_SIGN=$1
    echo "Signing $FILE_TO_SIGN"
    codesign -s "$DEVELOPER_ID" $FILE_TO_SIGN  --timestamp --force
}

find_files_to_sign() {
    DIRECTORY=$1
    echo "Entering directory $DIRECTORY"
    cd $DIRECTORY

    CONTENTS=$(ls)
    for ITEM in $CONTENTS
    do
        if [ -d "$ITEM" ];
        then
            recurse "$ITEM"
        else
            sign "$ITEM"
        fi
    done
    echo "Exiting $DIRECTORY"
    cd ..
}

find_files_to_sign "$SIGN_DIR"