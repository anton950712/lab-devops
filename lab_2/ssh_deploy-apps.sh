#!/bin/bash

SERVER_HOST_DIR=$(pwd)/nestjs-rest-api
CLIENT_HOST_DIR=$(pwd)/shop-react-redux-cloudfront

SERVER_REMOTE_DIR=/var/app
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

check_remote_dir_exists $SERVER_REMOTE_DIR
check_remote_dir_exists $CLIENT_REMOTE_DIR

echo "---> Building and copying server files - START <---"
echo $SERVER_HOST_DIR
cd $SERVER_HOST_DIR && npm run build
scp -Cr $SERVER_HOST_DIR/dist/* VM:$SERVER_REMOTE_DIR
echo "---> Building and transfering server - COMPLETE <---"

echo "---> Building and transfering client files - START <---"
echo $CLIENT_HOST_DIR
cd $CLIENT_HOST_DIR && npm run build
scp -Cr $CLIENT_HOST_DIR/dist/* VM:$CLIENT_REMOTE_DIR
echo "---> Building and transfering - COMPLETE <---"

echo "---> Restarting server - START <---"
ssh VM "sudo -S systemctl restart nginx"
echo "---> Restarting server - COMPLETE <---"
