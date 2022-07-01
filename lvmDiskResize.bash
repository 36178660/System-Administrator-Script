#!/bin/bash

#Author:Roggers Ogao
#Description: The Script will extend ubuntu, debian and centos disk via LVM Automatically
#Created_At: 27/06/2022
#Updated_At: 27/06/2022

echo 
echo
echo WELCOME TO THIS SIMPLE SCRIPT TO EXTEND YOUR VM USING LVM
echo ---------------------------------------------------------
echo Here we need to specify th disk device being extend eg: /dev/sdb or /dev/xvdb 
echo "(hint) the disk you have just attached run lsblk and mark the disk"
echo ---------------------------------------------------------
echo
echo Type here the name of the disk eg. /dev/sdb
read disk
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



