#!/bin/bash

# Title: LBRY Claim Script
# Author: Gardiner Bryant
# Copyright (c) 2020 Gardiner Bryant
# License: GNU Public License v2.0

function ProgressBar {
	# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
	# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

	# 1.2 Build progressbar strings and print the ProgressBar line
	# 1.2.1 Output example:                           
	# 1.2.1.1 Progress : [########################################] 100%
	printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

JSON_PP_AVAILABLE=`command -v jq`
LBRYNET_AVAILABLE=`command -v lbrynet`
TOKEN_EXTRACT_REGEX="s/: \"([\w]*)\"/\1/"
MIN_TOKEN_LENGTH=20

# Check if we have the dependencies
if [ "$LBRYNET_AVAILABLE" == "" ]; then
	# Gracefully exit if `lbrynet` doesn't exist
	echo "FATAL ERROR: It appears lbrynet doesn't exist on this system."
	exit 1
fi

# ==== VERSION CHECKING ====
# # Check if we have the dependencies
# if [ "$JSON_PP_AVAILABLE" == "" ]; then
# 	# Gracefully exit if `jq` doesn't exist
# 	echo "ERROR: It appears the JSON parsing command jq doesn't exist on this system."
# 	exit 1
# fi

# # Do some version checking:
# TESTED_VERSION="0.79.1"
# VERSION_NUMBER=`lbrynet version | jq ".version"`

# # Compare version strings:
# if [ "$(printf '%s\n' "$TESTED_VERSION" "$VERSION_NUMBER" | sort -V | head -n1)" != "$TESTED_VERSION" ]; then
# 	echo "Warning: this script was tested to work with $TESTED_VERSION. Your version is $VERSION_NUMBER. Do you wish to continue with an UNTESTED version? (y/N)"
# 	read UNTESTED_VERSION
# 	case "$UNTESTED_VERSION" in "" | "N" | "n" | "no" | "No" | "NO") UNTESTED_VERSION="N";;
# 	esac;

# 	if [ $UNTESTED_VERSION == "N" ]; then
# 		exit 0
# 	fi
# fi
# ==== END VERSION CHECKING ====

# Let's start this process
echo "Welcome to the LBC Credit Export Script."
echo "Created by Gardiner Bryant (@TheLinuxGamer)"

# Abandonding the claim means the claim on your content is sent to your LBRY wallet
echo "Do you want to move your LBC claims to your wallet? (Y/n)"
read ABANDON_CLAIMS

# Check if the user wants to abandon their claim
case "$ABANDON_CLAIMS" in "" | "Y" | "y" | "yes" | "Yes" | "YES") ABANDON_CLAIMS="Y"
	echo "Your claims will be moved to your wallet";;
*)
	# Otherwise we should exit
	echo "Bye!"
	exit 0;;
esac;

# Tell the user this might take a minute...
echo " -> Hang tight while we get your claims. This may take a few minutes..."

# Get a list of all supports associated with the current wallet and store it as RAW_CLAIMS_ARRAY
RAW_CLAIMS_ARRAY=`lbrynet support list --page_size=99999 | grep claim_id | uniq -c | sort -nr`

# Let's clean up the list:
UNIQUE_CLAIMS_ARRAY=($(echo "${RAW_CLAIMS_ARRAY[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Tell the user how many claims were found
echo " -> Found ${#UNIQUE_CLAIMS_ARRAY[@]} unique claims"

# Now let's start our loop:
echo " -> Processing claims..."
COUNT=0
for LINE in "${UNIQUE_CLAIMS_ARRAY[@]}";do
	# Extract the claim_id
	EXTRACTED_KEY=`echo ${LINE} | perl -pe "${TOKEN_EXTRACT_REGEX}"`
	
	# Maintain an iteration count
	COUNT=$((COUNT + 1))
	
	# Check if the extracted key meets the minimum allowed value
	if [ `expr length $EXTRACTED_KEY` -lt $MIN_TOKEN_LENGTH ]; then
		continue
	fi
	
	# Substring to remove the "XXX", quotes and trailing comma
	EXTRACTED_KEY=${EXTRACTED_KEY:1:40}

	# Check if the user wants to move their claims to their wallet
	if [ "${ABANDON_CLAIMS}" == "Y" ]; then
		# Move the user's claims to their wallet
		RESULT=`lbrynet support abandon --claim_id="$EXTRACTED_KEY"`
	fi
	
	# Maintain a nice progress bar
	ProgressBar ${COUNT} ${#UNIQUE_CLAIMS_ARRAY[@]}
done

echo " -> Finished!"
echo "Your LBC claims should now be in your wallet."

exit 0