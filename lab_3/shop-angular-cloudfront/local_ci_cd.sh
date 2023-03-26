#!/usr/bin/env bash

distFolderName=./dist

archiveFilePath=$distFolderName/client-app.zip
appFolderPath=$distFolderName/app

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
