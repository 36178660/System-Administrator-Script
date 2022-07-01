#!/bin/bash

#Author:Roggers Ogao
#Description: The script will do basic troubleshooting of the netwok according to what the user chooses
#Created_At: 30/06/2022
#updated_At: 30/06/2022

## Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033\e[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White


echo "Choose one of the options below:"
printf "1) ${Purple}Ping${Color_Off}\n"
printf "2) ${Purple}Check Details About a Domain ${Color_Off}\n"
printf "3) ${Purple}Check Expiry Date ${Color_Off}\n"
printf "4) ${Purple}Netstat${Color_Off}\n"
printf "5) ${Purple}nmap${Color_Off}\n"
printf "6) ${Purple}Netcat${Color_Off}\n"
printf "7) ${Purple}UFW${Color_Off}\n"
printf "8) ${Purple}Iptables${Color_Off}\n"
printf "9) ${Purple}Postfix${Color_Off}\n"
printf "10) ${Purple}Mail relay logs${Color_Off}\n"
printf "11) ${Purple}Extend Disk(LVM)${Color_Off}\n"

read choice


case $choice in
1)
	clear
	echo -e "              ${BGreen}PING${Color_Off}            "
	echo ---------------------------------------------------------------------------------------
	echo
	printf "${Green}1) Ping${Color_Off}\n"
	printf "${Green}2) Ping Via IPv6 or IPv4 protocol${Color_Off}\n"
	printf "${Green}3) Ping Via a predifined interval time between packets (Default 1 second)${Color_Off}\n"
	printf "${Green}4) Flood a Network using ping${Color_Off}\n"
	printf "${Green}6) Back\n"
	read ping

	case $ping in
	1)
		clear
		echo what is the FQDN/IP?
		read ip
		ping -c5 $ip
		clear
		exec $0
	;;
	2)
		clear
		echo what is the FQDN/IP?
		read ip
		echo choose IPv6 or IPv4
		read ipversion
		ipversionlower="${ipversion^}"
		if [ $ipversionlower == "Ipv6" ]
		then 	
			ping -6 -c5 $ip
			clear
			exec $0
		elif [ $ipversionlower == "Ipv4" ]
		then
			ping -4 -c5 $ip
			clear
			exec $0
		else 
			echo "I didn't understand your querry"
		fi
	;;
	3)
		echo what is the FQDN/IP?
		read ip
		echo choose your preferred time interval in seconds eg.0.5
		read interval

		ping -i $interval $ip
		echo done!
		sleep 4
		clear
		exec $0
	;;
	4)
		echo -e "${BRed}Are you sure you want to flood a network using ping ${Color_Off}(y/n)"
		read answer
		if [ $answer == "y" ]
		then
			echo what is the FQDN/IP?
			read ip
			echo flooding the networking with packets...
			ping -f $ip
		elif [ $answer == "n" ]
		then
			echo goodbye?
			clear
			exec $0
		else 
			echo "I didn't understand what you were saying!"
			echo goodbye!
			exit 1
		fi
		
	;;
	6)
		echo goodbye!
		sleep1
		clear
		exec $0
	;;
	esac
		
;;
2)
	clear
	echo -e "${Green}INFORMATION ABOUT YOUR SPECIFIED DOMAIN${Color_Off}"
	echo Please enter the name of your Domain:
	read domain
	echo "Please select what you want to find from the Domain $domain"
	echo -e "1)${BPurple} A record${Color_Off}"
	echo -e "2)${BPurple} MX record${Color_Off}"
	echo -e "3)${BPurple} ns servers${Color_Off}"
	echo -e "4)${BPurple} SOA${Color_Off}"
	echo -e "5)${BPurple} Dig using a specific port number${Color_Off}"
	echo -e "6)${BPurple} Find all DNS records Available in the domain $domain${Color_Off}"
	echo -e "7)${BPurple} Debug Mode for all DNS records${Color_Off}"

	read domainOption
	sleep 2 &
	PID=$!
	i=1
	sp="/-\|"
	echo -n ' '
	while [ -d /proc/$PID ]
	do
	printf "\b${sp:i++%${#sp}:1}"
	done
	case $domainOption in
	1)
			if [ -e /usr/bin/nslookup ]
			then
				nslookup -type=A $domain
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi


	;;
	2)
			if [ -e /usr/bin/nslookup ]
			then
				nslookup -type=mx $domain
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi


	;;
	3)
			if [ -e /usr/bin/nslookup ]
			then
				nslookup -type=ns $domain
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi


	;;
	4)
			if [ -e /usr/bin/nslookup ]
			then
				nslookup -type=soa $domain
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi


	;;
	5)
			if [ -e /usr/bin/nslookup ]
			then
				echo "Specify the port you want to use eg. 56"
				read portToBeUsed
				nslookup -port=$portToBeUsed $domain
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi


	;;
	6)
			if [ -e /usr/bin/nslookup ]
			then
				nslookup -type=any $domain
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi

	;;
	7)
			if [ -e /usr/bin/nslookup ]
			then
				nslookup -debug -type=any $domain
				sleep 2
				$?
			else
				echo "you don't have nslookup currently installed on your system"
				echo "${Green}Do you want to install it? Y/n${Color_Off}"
				read -s -n 1 key
				if [[ $key = 'y' ]];
				then
					sudo apt-get install dnsutils
				elif [[ $key = 'n' ]];
				then	
					exec $0
					clear
				elif [[ $key = "" ]];
				then
					sudo apt-get install dnsutils
				else
					echo "Don't understand you!!, Goodbye"
				fi
			fi


	;;
	esac
;;
3)
	clear
	printf "${BGreen}CHECKING THE EXPIRY OF A DOMAIN ${Color_Off}\n"
	echo -------------------------------------------------------------
	echo

	echo what is the name of the Domain?
	read expiryNameDomain
	if [ -e /usr/bin/whois ]
	then
		sleep 2 &
		PID=$!
		i=1
		sp="/-\|"
		echo -n ' '
		while [ -d /proc/$PID ]
		do
		printf "\b${sp:i++%${#sp}:1}"
		done			
		echo ----------REGISTRAR--------------------
		whois $expiryNameDomain
		print $registrar
		echo --------------------------------------
	else
		sleep 2 &
		PID=$!
		i=1
		sp="/-\|"
		echo -n ' '
		while [ -d /proc/$PID ]
		do
		printf "\b${sp:i++%${#sp}:1}"
		done			

		echo "${BGreen} Installing Whois ${Color_Off}"
		echo
		sudo apt-get install whois
		sleep 1
		echo ----------REGISTRAR--------------------
		whois $expiryNameDomain
		echo --------------------------------------	
	fi

;;


#postfix bash script to automate some of the boring stuff

9)
	clear
	printf "${BGreen}WELCOME V TO THIS SIMPLE SCRIPT TO AUTOMATE POSTFIX STUFF${Color_Off}\n"
	echo "---------------------------------------------------------------"
	printf "${BGreen}POSTFIX MAIL QUEUE MANAGEMENT SYSTEM${Color_Off}"
	echo
	printf "1) View all: Queued, Deferred and Pending mails\n"
	printf "2) Check total number of mails in the queue \n"
	printf "3) Delete all mails in the Queue \n"
	printf "4) Reattempt to deliver all mails in the queue \n"
	printf "5) Delete all mails in the deferred Queue \n"
	printf "6) Delete all mails in teh corrupt Queue \n"
	echo
	echo -e "------------${BGreen}COOL STUFF TO DO WITH SINGLE ID${Color_Off}-------------------"
	printf "7) Delete a particular mail in the Queue by its ID\n"
	printf "8) Delete all mails from a particular mail \n"
	printf "9) View mail header and contents from a particular ID\n"
	printf "10) Reattempt to send one particular mail \n"
	printf "11) Delete infected mails by user or pattern \n"


	printf "What option do you select?:"	
	read postfixOptionSelect
	sleep 2 &
	PID=$!
	i=1
	sp="/-\|"
	echo -n ' '
	while [ -d /proc/$PID ]
	do
	printf "\b${sp:i++%${#sp}:1}"
	done			
	

	case $postfixOptionSelect in 
	1)
		clear
		printf "${BGreen}VIEW ALL: QUEUED, DEFERRED AND PENDING
		MAILS${Color_Off}\n"
		echo -------------------------------------------------------
		sleep 2
		echo loading ...
		sleep 1
		if [ -e /usr/sbin/postqueue ]
		then
			postqueue -p
			echo
			echo
			echo ------------------------------------
			echo Enter Queue ID to display the mail Header and contents
			read queueID
			sleep 2 &
			PID=$!
			i=1
			sp="/-\|"
			echo -n ' '
			while [ -d /proc/$PID ]
			do
			printf "\b${sp:i++%${#sp}:1}"
			done			
			postcat -q $queueID
	

		else
			echo Postfix is not installed on this machine!!
			sleep 1
			echo goodbye!!
			exec 0
		fi
	;;
	2) 
		clear
		echo
		echo Checking the total number of mails in the Queue...
		if [ -e /usr/sbin/postqueue ]
		then
			total=postqueue -p | grep -c "^[A-Z0-9]"
			sleep 2 &
			PID=$!
			i=1
			sp="/-\|"
			echo -n ' '
			while [ -d /proc/$PID ]
			do
			printf "\b${sp:i++%${#sp}:1}"
			done			
			printf "The total number of mails in the queue is:
			${BRed}$total${Color_Off} \n"
		else
			echo Postfix is not installed on this machine!!
			sleep 1
			echo Goodbye!!
			exec 0
		fi
	;;
	3)
		clear
		echo

		if [ -e /usr/sbin/postqueue ]
		then
			echo "Are you sure you want to ${BRed}delete${Color_Off} all mails in the Queue?
			y/n$"
			read answer
			if [ $answer == "y" ]
			then
				echo running command postsuper -d ALL ...
				sleep 2 &
				PID=$!
				i=1
				sp="/-\|"
				echo -n ' '
				while [ -d /proc/$PID ]
				do
				printf "\b${sp:i++%${#sp}:1}"
				done			
				postsuper -d ALL
			else
				echo Goodbye!!
				clear
				exec 0
			fi
		else
			echo "Postfix is not installed on this machine!!"
			sleep 1
			echo Goodbye!!
		fi
	;;
	4)
		clear
		if [ -e /usr/sbin/postqueue ]
		then
			echo
			echo "Are you sure you want to ${BRed}reattmpt delivery of${Color_Off} all mails in the Queue?
			y/n$"
			read answer
			if [ $answer == "y" ]
			then
				echo running command postsuper -f...
				sleep 2 &
				PID=$!
				i=1
				sp="/-\|"
				echo -n ' '
				while [ -d /proc/$PID ]
				do
				printf "\b${sp:i++%${#sp}:1}"
				done				
				postsuper -f
			else
				echo Goodbye!!
				clear
				exec 0
			fi
		else
			echo "Postfix in not installed on this machine!!"
			sleep 1
			echo "Goodbye"
			exec 0
		fi
	;;

	5)
		if [ -e /usr/sbin/postqueue ]
		then

			clear
			echo
			echo "Are you sure you want to ${BRed}remove${Color_Off} all mails in
			the ${BYellow}Deferred${Color_Off} Queue?
			y/n$"
			read answer
			if [ $answer == "y" ]
			then
				echo running command postsuper -d ALL deferred
				sleep 2 &
				PID=$!
				i=1
				sp="/-\|"
				echo -n ' '
				while [ -d /proc/$PID ]
				do
				printf "\b${sp:i++%${#sp}:1}"
				done		
				postsuper -d ALL deferred
			else
				echo Goodbye!!
				clear
				exec 0
			fi
		else 
			echo "Postfix is not installed on this machine"
			sleep 1
			echo "Goodbye"
			exec 0
		fi
	;;	
			
	6)
		if [ -e /usr/sbin/postqueue ]
		then
			clear
			echo
			echo "Are you sure you want to ${BRed}remove${Color_Off} all mails in
			the ${BYellow}Corrupt${Color_Off} Queue?
			y/n"
			read answer
			if [ $answer == "y" ]
			then
				echo running command postsuper -d ALL corrupt
				sleep 2 &
				PID=$!
				i=1
				sp="/-\|"
				echo -n ' '
				while [ -d /proc/$PID ]
				do
				printf "\b${sp:i++%${#sp}:1}"
				done		
				postsuper -d ALL corrupt
			else
				echo Goodbye!!
				clear
				exec 0
			fi
		else
			echo "Postfix is not installed on this machine!!"
			sleep 1
			echo "Goodbye!!"
			exec 0
		fi
	;;
	7)
		if [ -e /usr/sbin/postqueue ]
		then
			clear

			echo -e "${BGreen}REMOVING MAILS BY ID${Color_Off}"
			echo

			echo
			echo
			echo "What is the mail ID eg: D89D45J56D"
			read id
			echo "Are you sure you want to ${BRed}remove${Color_Off} 
			${BYellow}$id${Color_Off} from the Queue?
			y/n"
			read answer
			if [ $answer == "y" ]
			then
				echo "running command postsuper -d $id"
				sleep 2 &
				PID=$!
				i=1
				sp="/-\|"
				echo -n ' '
				while [ -d /proc/$PID ]
				do
				printf "\b${sp:i++%${#sp}:1}"
				done		
				postsuper -d $id
			else
				echo Goodbye!!
				clear
				exec 0
			fi
		else
			echo "Postfix is not installed on this machine"
			sleep 1
			echo "Goodbye!!"
			exec 0
		fi
	;;	

esac
;;
	

#extending Disks using lvm for distros Ubuntu, Debian based and Centos

11)

echo 
clear
echo
printf "${BGreen}WELCOME TO THIS SIMPLE SCRIPT TO EXTEND YOUR VM USING LVM${Color_Off}\n"
echo ---------------------------------------------------------
printf  "Here we need to specify th disk device being extended eg: ${Red}/dev/sdb${Color_Off}
or ${Red}/dev/xvdb${Color_Off}\n" 
echo "(hint) the disk you have just attached run lsblk and mark the disk"
echo ---------------------------------------------------------
echo
echo -e "Type here the name of the disk eg.${Red} $/dev/xvdb${Color_Off}"
read disk



#introduction of and where i ask for the disk name that has been recently added 
#that you wish to extend

echo The partion disk mentioned below is $disk
echo "Are you sure the disk $disk is the right one or do you want to change it? (y/n)"
read sure
echo "Thank for your feedback let us complete the process for you"
sleep 2
echo "starting fdisk utility..."
sleep 3
echo "Starting fdisk utility ... Done!"

if [ $sure == "y" ]
then
	(echo n # add a new partition 
	echo p #make the partion primary
	echo  #default number
	echo  #default size
	echo #default
	echo t # make the partion of a specific file system
	echo 8e # type of the partion to be LVM (8e by default)
	echo w # write the changes and exit
	
	) | fdisk $disk

	echo "please wait while we complete the disk setup for you!!"
	echo --------------------------------------------------------
	echo
	echo
	if [ $? -eq 0 ]
	then
		echo Please wait ...
		sleep 4
		echo creating a new partition... 100%
		sleep 3
		echo making the partition primary... Done
		sleep 2
		echo making the partition type LVM ... Done
		sleep 1
		echo finished writing changes to the disk ... 100%
		sleep 1
	else
		exit 1
	fi
else
	echo Type here the right name of the disk?
	read disk
	(echo n # add a new partition
        echo p #make the partion primary
        echo  #default number
        echo #default size
		echo
        echo t # make the partion of a specific file system
        echo 8e # type of the partion to be LVM (8e by default)
        echo w # write the changes and exit

        ) | fdisk $disk

	if [ $? -eq 0 ]
	then
		echo Please wait ...
		sleep 2
		echo creating new partition... Done
		sleep 2
		echo making the partition primary... Done
		sleep 2
		echo making the partition type LVM ... Done
		sleep 1
		echo finished writing changes to the disk ... 100%
		sleep 1
	else
		exit 1
	fi

fi

echo " Done partioning the disk!!"
echo ------------------------------------------------------------
echo "Continuing to the next process!!"
echo


# Getting the disk that we have just made it to an LVM partition
volumeDisk=`fdisk -l | grep $disk | tail -n+2 | awk {'print $1'}`
echo - The disk created as listed in fdisk -l is $volumeDisk
echo
echo - creating a physical volume ...
sleep 1
echo
echo "-----------------------------------------------------------"
pvcreate $volumeDisk
if [ $? -eq 0 ]
then
	echo
	echo "Done creating the physical volume!!"
	echo
	echo
	echo        *** listing the volume group available ***
	echo 
	sleep 1
	echo
	vgs
	sleep 2
	echo
	volumeGroup=`vgs | tail -n+2 | awk {'print $1'}`
	echo "***** finding the name of the volume group ****"
	echo
	echo found the name of the volume group to be $volumeGroup
	sleep 2
	echo Extending the volume Group ...
	sleep 2
	vgextend $volumeGroup $volumeDisk

	if [ $? -eq 0 ]
	then
	        sleep 2
			echo "Exteding the volume group ... Done"
			echo
			echo "Finalizing ..."
			echo
			echo "--------------------------------------------------------------"
	  		echo           displaying the logical volume in the system:
			echo "--------------------------------------------------------------"
		        logicalVolume=`lvs | tail -n+2 | awk 'NR==1{print $1}'`
		        volumeGroup=`lvs | tail -n+2 | awk 'NR==1{print $2}'`
			echo
			echo
	        echo "From the command (lvs) you find that the logical volume is $logicalVolume and .."
	        echo "the volumeGroup is $volumeGroup"
	        sleep 1
			echo
	        echo "The command (lvdisplay (ubuntu)) displays this information as follows"
	  		echo
	        lvString=/dev/$volumeGroup/$logicalVolume
			echo
			echo "----------------------------------------------------------------------"	
	        echo "combining strings from database ..."
			echo "Done!"
			echo "Displaying the string"
	        echo $lvString
			echo 
			echo "Determining the Operating system currently running"
	        if [ $? -eq 0 ]
	        then
	                osTypeUbuntuDebian=`cat /etc/os-release | egrep ^ID= | awk {'print $1'} | cut -d= -f2`
	                osTypeCentOs=`cat /etc/os-release | egrep ^ID= | awk {'print $1'} | cut -d= -f2 | tr -d \"`
	                if [ $osTypeUbuntuDebian == "ubuntu" ]  || [ $osTypeUbuntuDebian == "debian" ]
	                then 
							echo "Done"
							echo "----------------------------------------------------"
							echo "Debian Based System (ubuntu | Debian) Detected!!"
							echo "----------------------------------------------------"
							echo
							echo
							echo "extending the root volume ...."
	                        lvextend -l +100%FREE $lvString
	                        if [ $? -eq 0 ]
	                        then 
									echo
									sleep 2
									echo
	                                resize2fs $lvString

									echo "extending ... 100%"


	                        else
	                                exit 1
	                        fi
	                elif [ $osTypeCentOs == "centos" ]
	                then
	                        echo "=========================================================="
							echo "          Centos Operating System Detected           "
							echo "=========================================================="
							echo
							echo
							echo "extending the root volume ..."
							lvextend -l +100%FREE $lvString
							if [ $? -eq 0 ]
							then
								echo
								sleep 2
								xfs_growfs $lvString
								echo extending disk ... 100%
							else
								exit 1
							fi
	                else
	                        echo nothing
	                fi
	        else
	                exit 1
        	fi
	else
	    exit 1
	fi

else
	exit 1
fi


;;



esac
