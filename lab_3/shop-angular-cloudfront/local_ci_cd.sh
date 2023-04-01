#!/usr/bin/env bash

distFolderName=./dist

archiveName=client-app.zip
archiveFilePath=$distFolderName/$archiveName
appFolderPath=$distFolderName/app

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

zip -r $archiveFilePath $appFolderPath

check_remote_dir_exists $CLIENT_REMOTE_DIR

echo "---> Building and transfering client files - START <---"
echo $CLIENT_HOST_DIR
scp -Cr $archiveFilePath VM:$CLIENT_REMOTE_DIR
ssh VM "sudo unzip -d $CLIENT_REMOTE_DIR $CLIENT_REMOTE_DIR/$archiveName"
echo "---> Building and transfering - COMPLETE <---"

