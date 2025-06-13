#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# For debugging, you can uncomment the next line
# LOG_FILE=~/cubox_popclip.log
# exec &> >(tee -a "$LOG_FILE")
# set -x

# On script exit, remove temp file if it exists
cleanup() {
  [ -n "$RESPONSE_FILE" ] && rm -f "$RESPONSE_FILE"
}
trap cleanup EXIT

# Source config file from the extension bundle.
# The `dirname "$0"` trick ensures it finds config.sh relative to the script's location.
source "$(dirname "$0")/config.sh"

# Check if API_URL is configured
if [ -z "$API_URL" ] || [[ "$API_URL" == *"PASTE_YOUR_WEBHOOK_URL_HERE"* ]]; then
  # exit 99 is a special PopClip code to show the user the extension needs configuration.
  exit 99
fi

# PopClip provides the selected text in the POPCLIP_TEXT environment variable.
CONTENT="$POPCLIP_TEXT"

# If there is no content, there's nothing to do. Exit successfully.
if [ -z "$CONTENT" ]; then
    exit 0
fi

# The most robust way to create JSON in shell is to use a tool like 'jq'.
# If 'jq' is not available, we can fall back to a Python script.
if command -v jq &> /dev/null; then
    JSON_PAYLOAD=$(jq -n \
                  --arg content "$CONTENT" \
                  '{foo: "bar", content: $content}')
else
    # Fallback to Python if jq is not available. This is safer than shell string building.
    PY_SCRIPT="import json, sys; print(json.dumps({'foo': 'bar', 'content': sys.argv[1]}))"
    JSON_PAYLOAD=$(python3 -c "$PY_SCRIPT" "$CONTENT")
fi


# Now, let's make the API call and properly check the result.
# Create a temporary file to store the response body from Cubox.
RESPONSE_FILE=$(mktemp)
# Use curl's --write-out option to get the HTTP status code, separate from the body.
HTTP_STATUS=$(curl --silent --write-out "%{http_code}" --output "$RESPONSE_FILE" \
  -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

# Check if the HTTP status code is a success code (2xx).
# A 200 "OK" is the most common success code.
if [[ "$HTTP_STATUS" -lt 200 || "$HTTP_STATUS" -gt 299 ]]; then
  # The API call failed. Exit with a non-zero status code to let PopClip know.
  # PopClip will show a small 'x' icon.
  # For debugging, you could write the error to a log file.
  # echo "Cubox API Error: HTTP $HTTP_STATUS, Response: $(cat $RESPONSE_FILE)" >> ~/cubox_popclip_error.log
  exit 1
fi

# If we are here, the API call was successful.
# The script will exit with the status of the last command (which is 0 from the 'if' statement).
# PopClip will show a checkmark. 