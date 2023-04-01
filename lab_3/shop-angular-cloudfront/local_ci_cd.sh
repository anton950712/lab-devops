#!/usr/bin/env bash

DIST_FOLDER_NAME=./dist

ARCHIVE_NAME=client-app.zip
ARCHIVE_FILE_PATH=$DIST_FOLDER_NAME/$ARCHIVE_NAME
APP_FOLDER_PATH=$DIST_FOLDER_NAME/app

CLIENT_HOST_DIR=$(pwd)/shop-react-redux-cloudfront
CLIENT_REMOTE_DIR=/var/www

check_remote_dir_exists() {
  echo "Check if remote directories exist"

  if ssh VM "[ ! -d $1 ]"; then
    echo "Creating: $1"
    ssh VM "sudo -S mkdir -p $1 && sudo -S chown -R sshuser: $1"
  else
    echo "Clearing: $1"
    ssh VM "sudo -S rm $1/*"
  fi
}

if ! test -f "package.json"
then
  echo The package.json does not exists
  exit 1
fi

# Run build

npm i
npm run prepare
npm run lint
npm run test
npm run build

zip -r $ARCHIVE_FILE_PATH $APP_FOLDER_PATH

check_remote_dir_exists $CLIENT_REMOTE_DIR

# Send build

echo "---> Building and transfering client files - START <---"
echo $CLIENT_HOST_DIR
scp -Cr $ARCHIVE_FILE_PATH VM:$CLIENT_REMOTE_DIR
ssh VM "sudo unzip -d $CLIENT_REMOTE_DIR $CLIENT_REMOTE_DIR/$ARCHIVE_NAME"
echo "---> Building and transfering - COMPLETE <---"

