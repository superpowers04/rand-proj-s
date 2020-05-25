#!/bin/bash
echo "We need you to run this as root for diagnostics, If you do not understand what this means then just enter your system password below, It will not show the password for security reasons"
sudo echo "Please give us the link below when it generates"
{	
	printf "\nUname:\n"
	uname -a
	
    printf "\nHost file\n"
    cat /etc/hosts
    if [[ -f "/private/etc/hosts" ]];then
	    printf "\nSecond host file\n"
	    cat /private/etc/hosts
	  fi
    printf "\nProcess List:\n"
    ps -ax
    if [[ -e /Applications ]];then
    	printf "\nInstalled applications (Darwin):\n"
    	cat /Applications
    else
    	printf "\nInstalled applications (/usr/local):\n"
    	ls -1 /usr/share/applications
    	printf "\nInstalled applications (pacman):\n"
    	pacman -u
    fi

} | curl -F 'sprunge=<-' http://sprunge.us/
