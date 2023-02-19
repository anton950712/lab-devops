#!/usr/bin/env bash

fileName=users.db
fileBackupedName=$(date +%m-%d-%Y)-$fileName.backup
fileDir=../data
filePath=$fileDir/$fileName
isInverse="$2"

function validateLetters {
    if [[ $1 =~ ^[A-Za-z_]+$ ]]
    then
        echo 0
    else
        echo 1
    fi
}

function add() {
    read -p "What is the user name? " username

    if [[ $(validateLetters $username) == 1 ]]
    then
        echo "Name must have only latin letters. Try again"
        exit 1
    fi

    read -p "What is the user role? " role

    if [[ $(validateLetters $role) == 1 ]]
    then
        echo "Role must have only latin letters. Try again"
        exit 1
    fi

    echo $username, $role >> $filePath
    echo User added
}

function showUsers() {
    users=()
    index=0

    while read line; do
        users[$index]="$line"
        index=$(( $index + 1 ))
    done < $filePath

    for (( a=0; a < ${#users[*]}; a++ ))
    do
        echo "$a: ${users[$a]}"
    done
}

function showReversedUsers() {
    users=()
    index=0

    while read line; do
        users[$index]="$line"
        index=$(( $index + 1 ))
    done < $filePath

    for (( a=${#users[@]} - 1; a >= 0; a--))
    do
        echo "$a: ${users[$a]}"
    done
}

function list() {
    if [[ $isInverse == "--inverse" ]]
    then
        showReversedUsers
    else
        showUsers
    fi
}

function help() {
    echo "Manages users in db. It accepts a single parameter with a command name."
    echo
    echo "Syntax: db.sh [command]"
    echo
    echo "List of available commands:"
    echo
    echo "add       Adds a new line to the users.db. Script must prompt user to type a
                    username of new entity. After entering username, user must be prompted to
                    type a role."
    echo "backup    Creates a new file, named" $filePath".backup which is a copy of
                    current" $fileName
    echo "find      Prompts user to type a username, then prints username and role if such
                    exists in users.db. If there is no user with selected username, script must print:
                    “User not found”. If there is more than one user with such username, print all
                    found entries."
    echo "list      Prints contents of users.db in format: N. username, role
                    where N – a line number of an actual record
                    Accepts an additional optional parameter inverse which allows to get
                    result in an opposite order – from bottom to top"
}

function backup() {
    cp $filePath $fileDir/$fileBackupedName
        echo "Backup is created"
}

function restore() {
    latestBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)

    if [[ ! -f $latestBackupFile ]]
    then
        echo "No backup file found"
        exit 1
    else
        cp -f $latestBackupFile $filePath
        echo "Backup is restored"
    fi
}

function find() {
    users=()
    user=""
    index=0

    read -p "Enter username to search: " username

    while read line; do
        index=$(( $index + 1 ))

        if [[ "$line" == *"$username"* ]] && [[ $username ]]
        then
            user=$line
            echo User: $line
        fi
    done < $filePath

    if ! [[ $user ]]
    then
        echo The user does not exists
    fi
}

case $1 in
    add) add;;
    help) help;;
    list) list;;
    backup) backup;;
    restore) restore;;
    find) find;;
    *) help;;
esac
