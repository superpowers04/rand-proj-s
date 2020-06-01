#!/bin/bash
clear
function javanotinstalled {
	clear
	echo "Java not found, Would you like me to install it for you? (y|n)"
	read answer
	answer="${answer,,}"
	if [[ "$answer" == "n" || "$answer" == "no" ]]; then
		echo "Checking what package manager's you have installed"
		installmessage="Installing Java using"
		if [[ -f "/usr/bin/apt" ]]; then
			echo "$installmessage apt"
			sudo apt-get install openjdk-8-jre
		elif [[ -f "/usr/bin/pacman" ]]; then
			echo "$installmessage pacman"
			sudo pacman -Syu jre8-openjdk
		elif [[ -f "/usr/bin/yay" ]]; then
			echo "$installmessage yay"
			sudo yay jre8-openjdk
		else
			echo "Could not detect what package manager you are using, You will have to install it yourself"
			read
			exit
		fi
	elif [[ "$answer" == "n" || "$answer" == "no" ]]; then
		echo "Java is required to run Minecraft servers, Exiting!"
		read
		exit
	else
		echo "invalid answer"
		javanotinstalled
	fi
	echo "Done!"
}

function eulaview {
	echo "By using this server software, you are agreeing"
	echo "to Mojang's End User License agreement at:"
	echo "https://account.mojang.com/documents/minecraft_eula"
	echo "View the End User License Agreement? (y/n)"
	read answer
	answer="${answer,,}"
	echo $answer
	if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
		clear
		echo "Opening the Eula in your browser"
		xdg-open "https://account.mojang.com/documents/minecraft_eula"
		eulaaccept
	elif [[ "$answer" == "n" || "$answer" == "no" ]]; then
		clear
		eulaaccept
	else
		echo "invalid answer"
		eulaview
	fi
}

function eulaaccept {
	echo "Do you agree to the EULA? (y/n) "
	read answer
	answer="${answer,,}"
	if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
		echo "Bringing you to install page"
	elif [[ "$answer" == "n" || "$answer" == "no" ]]; then
	    echo "You must agree to the End User License Agreement to continue."
	    echo "Installer will exit."
	    read
	    exit
	else
		echo "invalid answer"
		eulaview
	fi
}

function locationset {
	echo "Where would you like to install the server"
	echo "By default it will be installed at '/home/${USER}/minecraft-server/'"
	echo "Press enter to use default"
	read installpath
	if [[ -e "$installpath" ]]; then
		echo "install path valid"
	elif [[ "$installpath" == "" ]];then
		echo "installing to default location"
		if [[ -e "$installpath" ]]; then
			echo "install path exists already, adding '-1' to the end"
			installpath="/home/${USER}/minecraft-server-1/"
		else 
			installpath="/home/${USER}/minecraft-server/"
		fi
		if [[ "${installpath:$((${#installpath}-1)):1}" != "/" ]]; then
			installpath="${installpath}/"
		fi
		mkdir "$installpath"
	else
		echo "Invalid install path"
		locationset
	fi 
}

function selectservertype {
	echo "Please choose the server software you would like."
	echo " 1. Paper"
	echo " 2. Cuberite"
	read answer 
	servertype="${answer,,}"
	if [[ "$servertype" == "paper" || "$servertype" == "1" ]]; then
		eulaview
		clear
		locationset
		paperinstall
	elif [[ "$servertype" == "cubrite" || "$servertype" == "2" ]]; then
		
		
		clear
		locationset
		cuberiteinstall
	else
		echo "Invalid option"
		selectservertype
	fi

}


function paperinstall {
	clear
	cd "$installpath"
	echo "$(basename "$0") will now download the"
	echo "latest version of the Paper server software on your device."
	echo "Press any key to continue, Otherwise please close this window"
	read
	curl -o "./paper.jar" https://papermc.io/ci/job/Paper-1.15/lastSuccessfulBuild/artifact/paperclip.jar
	executable="paper.jar"
	echo "Installed to ${installpath}, Press enter to continue"
	read
	finished
}

function cuberiteinstall {
	clear
	cd "$installpath"
	echo "$(basename "$0") will now download the"
	echo "latest version of the Cuberite server software on your device."
	echo "Press any key to continue, Otherwise please close this window"
	read
	curl -sSfL https://download.cuberite.org | sh
	clear
	#executable="paper.jar"
	echo "Installed to ${installpath}, Press enter to continue"
	read
	cuberiteman
}

function cuberiteman {
	clear
	echo "Would you like to view the Cuberite manual? (y/n/enter) "
	read answer
	answer="${answer,,}"
	if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
		echo "Bringing you to manual page"
		xdg-open "https://book.cuberite.org/"
	else
		echo "Skipping manual"
		finishedcuberite
	fi
}



function usualinstall {
	echo "eula=true" > ./eula.txt
	echo "How much RAM (in megabytes) would you like to"
	echo "allocate to the server?"
	read ramallocationmb
	case $ramallocationmb in
	    ''|*[!0-9]*) ramallocationmb= "-Xmx${ramallocationmb}m" ;;
	    *) ramallocationmb= "-Xmx1024m";;
	esac
	echo "Specify any additional JVM arguments you would like to add.\nPress enter to skip this step."
	read additionaljavaargs
	printf "cd \"$installpath\"\njava -jar $ramallocationmb $additionaljavaargs $executable" > ./start.sh
	chmod +x ./start.sh
	finished
}
function finished {
	echo "All finished, Run the start.sh file located in $installpath to start your server,(From terminal just run 'cd \"${installpath}\"; ./server.sh')"
	read
	exit
}
function finishedcuberite {
	clear
	echo "All finished, To start your server,Open terminal and run 'cd \"${installpath}\"; ./Cuberite'"
	read
	exit
}





printf "Checking for java"
java -version

#strings
#desktopfile="[Desktop Entry]\nName=Minecraft server\nComment=Opens your minecraft server\nExec=\nIcon=minecraft\nTerminal=false\nType=Application\nCategories=Game;" - Unset until it can be determined what terminals the person has





if [[ "$?" == "127" ]]; then
	javanotinstalled
fi
clear
echo "Java detected"
UNAME=`uname`
ARCH=`uname -m`
selectservertype







