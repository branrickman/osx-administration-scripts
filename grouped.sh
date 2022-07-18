#!/bin/bash

# note: this method of getting the script's path is probably flawed in ways I do not anticipate. It's only used to list function signatures in the gedhelp() function though, so not a dealbreaker.
script_path=$(dirname "$0")/grouped.sh

# Print usage for each available function
# usage: gedhelp
# NOTE: apparently referencing the location of a script is complex: https://stackoverflow.com/questions/6659689/referring-to-a-file-relative-to-executing-script
gedhelp() {
grep "# usage*" $script_path
}

# list all groups
# usage: listgroups (no args)
listgroups() {
dscl . list /Groups PrimaryGroupID | tr -s ' ' | sort -n -t ' ' -k2,2
}

#list users
# usage: listusers (no args)
listusers() {
dscl . -list /Users UniqueID | sort -n -k 2
}

# read user info
# usage: readuser <user>
readuser () {
dscl . read /Users/$1
}

# read all user info
# usage: readallusers (no args)
#TODO: remove all JPEGPhoto records so this is not swamped with JPEG data
readallusers () {
dscl . readall /Users
}

# add user to group
# usage: togroup <username> <groupname>
togroup() {
sudo dseditgroup -o edit -a $1 -t user $2
}

# remove user from group
# usage: fromgroup <user> <group>
fromgroup() {
sudo dseditgroup -o edit -r $1 -t user $2
}

# create a new group
# usage: mkgroup <groupname> <groupid>
#TODO Add a check to prevent overwriting git, add functionality to automatically assign the smallest available gid above the 1000 range
mkgroup() {
sudo dscl . create /Groups/$1
sudo dscl . create /Groups/$1 gid $2
echo "Creating group $1 with gid $2"
}

# destroy an existing group
# usage: killgroup <groupname>
killgroup() {
echo "Are you sure you want to destroy group $1? Regardless, interactivity isn't implemented yet, so defaulting to YES."
sudo dscl . -delete /Groups/$1
}

# add a user to an ACL
# usage: toacl <username> <filename>
toacl() {
chmod -R +a "user:$1 allow list,search" $2
}

# remove a user from an ACL
# usage: TODO fromacl <user> <group>
fromacl() {
echo "Not implemented"
}

# create a new user
# usage: mkuser <username> <RealName> <UniqueID> <PrimaryGroupID> <password>
# note: managing the password in this way is insecure (bash history), but makes automated creation of many accounts much easier.
mkuser() {
	sudo dscl . -create /Users/$1
	sudo dscl . -create /Users/$1 RealName $2
	sudo dscl . -create /Users/$1 UniqueID $3
	sudo dscl . -create /Users/$1 PrimaryGroupID 20
	sudo dscl . -passwd /Users/$1 $5
	sudo dscl . -create /Users/$1 NFSHomeDirectory /Users/$1
	sudo mkdir /Users/$1
}

# remove a user
# usage: killuser <username>
killuser() {
sudo dscl . -delete /Users/$1
echo "TODO cleanup after deleting user"
}

# unhide a user
# usage: unhide <username>
unhideuser() {
sudo dscl . create /Users/$1 IsHidden 0
}

# hide a user
# usage: hideuser <username>
hideuser() {
sudo dscl . create /Users/$1 IsHidden 1
}
