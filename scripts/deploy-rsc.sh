#!/usr/bin/env bash
#
# Create bundle, upload bundle to RSC, deploy the bundle

set -e
set -x

if [ -z "${CONNECT_SERVER}" ] ; then
  echo "The CONNECT_SERVER environment variable is not defined. It defines"
  echo "the base URL of your RStudio Connect instance."
  echo
  echo "    export CONNECT_SERVER='http://connect.company.com/'"
  exit 1
fi
if [ -z "${CONNECT_API_KEY}" ] ; then
  echo "The CONNECT_API_KEY environment variable is not defined. It must contain"
  echo "an API key owned by a 'publisher' account in your RStudio Connect instance."
  echo
  echo "    export CONNECT_API_KEY='jIsDWwtuWWsRAwu0XoYpbyok2rlXfRWa'"
  exit 1
fi

APP="$1" # This is the GUID
BUNDLE_PATH="./bundle.tar.gz"
CONTENT_DIRECTORY="$2"

echo "APP GUID: ${APP}"

# Remove any bundle from previous attempts
rm -f "${BUNDLE_PATH}"

 # Create an archive with all of our application source and data
echo "Creating bundle archive: ${BUNDLE_PATH}"
tar czf "${BUNDLE_PATH}" -C "${CONTENT_DIRECTORY}" .

# Upload the bundle
UPLOAD=$(curl --silent --show-error -k -L --max-redirs 0 --fail -X POST \
              -H "Authorization: Key ${CONNECT_API_KEY}" \
              --data-binary @"${BUNDLE_PATH}" \
              "${CONNECT_SERVER}/__api__/v1/experimental/content/${APP}/upload")
BUNDLE=$(echo ${UPLOAD} | jq -r .bundle_id)
echo "Created bundle: $BUNDLE"

# Deploy the bundle
DEPLOY=$(curl -c cookie-jar.txt --silent --show-error -k -L --max-redirs 0 --fail -X POST \
              -H "Authorization: Key ${CONNECT_API_KEY}" \
              --data '{"bundle":'"${BUNDLE}"'}' \
              "${CONNECT_SERVER}/__api__/v1/experimental/content/${APP}/deploy")

echo ${DEPLOY}
TASK=$(echo ${DEPLOY} | jq -r .task_id)

# Poll until task has completed
FINISHED=false
CODE=-1
START=0
echo "Deployment task: ${TASK}"
while [ "${FINISHED}" != "true" ] ; do
    DATA=$(curl -b cookie-jar.txt -c cookie-jar.txt --silent --show-error -k -L --max-redirs 0 --fail \
              -H "Authorization: Key ${CONNECT_API_KEY}" \
              "${CONNECT_SERVER}/__api__/v1/experimental/tasks/${TASK}?wait=1&first=${START}")
    # Extract parts of the task status
    FINISHED=$(echo "${DATA}" | jq .finished)
    CODE=$(echo "${DATA}" | jq .code)
    START=$(echo "${DATA}" | jq .last)
    # Present the latest status lines
    echo "${DATA}" | jq  -r '.output | .[]'
done
 if [ "${CODE}" -ne 0 ]; then
    ERROR=$(echo "${DATA}" | jq -r .error)
    echo "Task: ${TASK} ${ERROR}"
    exit 1
fi

# Remove side-effects
rm -f "${BUNDLE_PATH}"
rm -f cookie-jar.txt

echo "Task: ${TASK} Complete."
