#!/usr/bin/env bash

dataFolder=../data
filePath=$dataFolder/$1
newFilePath=$dataFolder/pipeline-$(date +%m-%d-%Y).json

branch="main"
owner="$USER"
poll=false
config=""

# If JQ is not installed

if ! command -v jq &> /dev/null
then
   echo "JQ could not be found"
   echo "How install it - https://stedolan.github.io/jq/download/"
   exit 1
fi

# Help block

if [[ $1 == "--help" ]]
then
   echo 'Command example: "./update-pipeline-definition.sh pipeline.json --configuration production --owner boale --branch feat/cicd-lab --poll-for-source-changes true"'
   exit
fi

# If file does not iexists

if test -f "$filePath"
then
   echo "Preparing the file ($newFilePath)"
else
   echo The file does not exists
   exit 1
fi

version=$(jq '.pipeline.version' $filePath)
newVersion=$(( $version + 1 ))

# Get options

while [ "$2" != "" ]; 
do
   case $1 in
      --owner)
         shift
         owner="$1"
         ;;
      --branch)
         shift
         branch="$1"
         ;;
      --poll-for-source-changes)
         shift
         poll="$1"
         ;;
      --configuration)
         shift
         config="$1"
         ;;
   esac
   shift
done

# Run formating

file=$(jq . $filePath)
file=$(echo "${file}" | jq 'del(.metadata)')

if [[ $(echo "${file}" | jq 'select(.pipeline.version)') ]]
then
   file=$(echo "${file}" | jq --argjson v $newVersion '.pipeline.version = $v')
else
   echo "No version in json"
   exit 1
fi

if [[ $(echo "${file}" | jq 'select(.pipeline.stages[0].actions[0].configuration.Branch)') ]]
then
   file=$(echo "${file}" | jq --arg b "$branch" '.pipeline.stages[0].actions[0].configuration.Branch = $b')
else
   echo "No Branch in json"
   exit 1
fi

if [[ $(echo "${file}" | jq 'select(.pipeline.stages[0].actions[0].configuration.PollForSourceChanges)') ]]
then
   file=$(echo "${file}" | jq --argjson p "$poll" '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $p')
else
   echo "No PollForSourceChanges in json"
   exit 1
fi

if [[ $(echo "${file}" | jq 'select(.pipeline.stages[0].actions[0].configuration.Owner)') ]]
then
   file=$(echo "${file}" | jq --arg o "$owner" '.pipeline.stages[0].actions[0].configuration.Owner = $o')
else
   echo "No Owner in json"
   exit 1
fi

if [[ $config ]]
then
   file=$(echo "${file//\{\{BUILD_CONFIGURATION value\}\}/$config}")
fi

# Get final result

echo $file | jq '.' > $newFilePath
echo Completed!
