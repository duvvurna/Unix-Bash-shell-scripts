#!/bin/bash
####################################################################################################################
#This script removes ssh/sftp keys from ~/.ssh/known_hosts file.
#Script developed by NATARAJ SARMA DUVVURiiI
#
#
#
####################################################################################################################

NAME=$1 #to undestand who is deleted
Comment=$2 # purpose of deletion
d=`date '+%Y/%m/%d_%H:%M:%S'`
err_index=false


echo " " > $1.log
echo "*********************$0*******************" >> $1.log

####################################################################################################################
#Validating user inputs
#####################################################################################################################

## chceck the number of parameters provided.

if [[ "$#" -eq 1 ]] && [[ "$1" = "-help" ]]; then 

	echo " "
	echo "usage : you need to give two arguments while using scirpt"
	echo "A sample has been provided as below"
	echo "removesshkeys.sh NAtaraj "just a test" "

elif [[ "$#" -eq 0 ]]; then
	echo "please try removesshkeys.sh -help for how to use the script"
fi

if [[  "$#" -ne 2  ]]; then
	echo "Number of Parameters provided are incorrect"
        err_index=true
fi

if [[  "$err_index" = true  ]];then
	exit 0
fi

####################################################################################################################
#Start: Processing
#####################################################################################################################
# check if sshkeys contains any special charecters


escsshreferences = $( echo "sshkeyrefernce" | sed "s/\-/\\\-/g" | sed "s/\[/\\\[/g" | sed "s/\]/\\\]/g" )


# getting the count of special charecters

sshkeycount = `grep $escsshreferences ~./ssh/known_hosts | wc -l`

echo " "

if [[  "$sshkeycount" -ne 0 ]]; then 
	echo "$sshkeycount matching keys found" >> $1.log
else
	echo "No Matching keys found.Script will exit now"
	exit 
fi

#If matching keys are found choice of yes or no will given before the deletion.

grep $sshkeycount ~/.ssh/known_hosts

echo " "

echo "Do you want to delete keys?"

while true
do 
	prompt='press Y to delete or N to Exit:'
	echo -n "$prompt"
	read -n1 char

	case "$char" in 
		[Nn])
			echo "" >> $1.log
			exit
			break
			;;
		[Yy])
			# Continue.
			break
			;;
		*)
			echo "invalid character '$char' entered. Please try again"
			continue

	esac

done

echo " "

echo "Backing up the ~/.ssh/known_hosts fie:"  >> $1.log

cp -f ~/.ssh/known_hosts ~/.ssh/known_hosts_$1

####################################################################################################################
#Start Removing the keys
#####################################################################################################################

ssh-keygen -R "$NAME" >> $1.log

diff ~/.ssh/known_hosts ~/.ssh/known_hosts_$1 









