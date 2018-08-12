#!/bin/bash


##/ Check root /##

    if (( EUID != 0 ))
    then

  clear

echo "*************** [ERROR] ***************"
echo "*                                     *"
echo "*  You must run this script as root!  *"
echo "*                                     *"
echo "***************************************"
echo
echo
echo "======== [Press enter to exit] ========"

  read
  clear
  exit

    fi

##/ Warning /##

  clear

echo "******** [Android-tools v2.0] ********"
echo "*                                    *"
echo "*     Written by: Joshua Hoffman     *"
echo "*                                    *" 
echo "************* [WARNING] **************"
echo "*                                    *"
echo "*  This script can cause damage to   *"
echo "*    your android device. I'm not    *"
echo "*   responsible for any damages it   *"
echo "*  may cause.  Don't use if you are  *"
echo "*   unfamiliar with adb & fastboot   *"
echo "*             commands.              *"
echo "*                                    *"
echo "*  This script may void the devices  *"
echo "*             warranty.              *"
echo "*                                    *"
echo "******* [Use at your own risk] *******"
echo "*                                    *"
echo "*      Do you want to continue?      *"
echo "*                                    *"
echo "**************************************"
echo
echo
echo "=============== [y/n] ================"
echo

  read AGRE
  
    if [[ $AGRE == 'y' ]]
    then

  clear

##/ File setup /##
  
CDIR=$(pwd)
DATE=$(date +"%m-%d_%H-%M-%S")

LFIL="$CDIR/android-tools/logcat/logcat_$DATE.txt"
BFIL="$CDIR/android-tools/backup/"
SFIL="$CDIR/android-tools/su_zip/"

mkdir -p "$CDIR/android-tools/su_zip/"
mkdir -p "$CDIR/android-tools/logcat/"
mkdir -p "$CDIR/android-tools/backup/"

chown -hR "$SUDO_USER" "$CDIR/android-tools/"
    
##/ Signial trap /##

Signal_trap () {

  clear

echo "*************** [ERROR] ***************"
echo "*                                     *"
echo "*  Use option 0 in main menu to exit! *"
echo "*                                     *"
echo "***************************************"
echo
echo
echo "====== [Press enter to continue] ======"

}

  trap "Signal_trap" SIGINT
  
##/ Device status /##

device_status () {

ADBC=$(adb devices | sed -n '2p' | grep -c 'device')
FBTC=$(fastboot devices | grep -c 'fastboot')
RECC=$(adb devices | sed -n '2p' | grep -c 'recovery')

}

##/ Check adb status /##
  
adb_check () {

"device_status"

    if [ $ADBC = 1 ]
    then
    
echo "**** [SUCCESS] ****"
echo "*                 *"
echo "*  adb connected  *"
echo "*                 *"
echo "*******************"

  sleep 2

    elif [ $FBTC = 1 ]
    then
    
echo "****************************************"
echo "*                                      *"
echo "*  In fastboot mode, rebooting to adb  *"
echo "*                                      *"
echo "****************************************"

    fastboot reboot &> /dev/null

echo
echo "Waiting for device..."
      
    adb wait-for-device
  
  clear
      
echo "**** [SUCCESS] ****"
echo "*                 *"
echo "*  adb connected  *"
echo "*                 *"
echo "*******************"

  sleep 2

    elif [ $RECC = 1 ]
    then
    
echo "****************************************"
echo "*                                      *"
echo "*  In recovery mode, rebooting to adb  *"
echo "*                                      *"
echo "****************************************"

    adb reboot &> /dev/null
    
echo
echo "Waiting for device..."
      
    adb wait-for-device
  
  clear
      
echo "**** [SUCCESS] ****"
echo "*                 *"
echo "*  adb connected  *"
echo "*                 *"
echo "*******************"

  sleep 2

    elif [ $FBTC = 0 ] && [ $ADBC = 0 ] && [ $RECC = 0 ]
    then
    
echo "********* [ERROR] *********"
echo "*                         *"
echo "*  Cannot detect device!  *"
echo "*                         *"
echo "***************************"
echo
echo
echo "====== [Press enter] ======"

read
      
    fi
}

##/ Check fastboot status /##

fastboot_check () {

"device_status"

    if [ $FBTC = 1 ]
    then
    
echo "******* [SUCCESS] *******"
echo "*                       *"
echo "*  fastboot connected.  *"
echo "*                       *"
echo "*************************"

  sleep 2
      
    elif [ $ADBC = 1 ]
    then
    
echo "****************************************"
echo "*                                      *"
echo "*  In adb mode, rebooting to fastboot  *"
echo "*                                      *"
echo "****************************************"

    adb reboot bootloader
      
echo
echo "Waiting for device..."

    fastboot wait-for-device &> /dev/null
      
  clear
      
echo "******* [SUCCESS] *******"
echo "*                       *"
echo "*  fastboot connected.  *"
echo "*                       *"
echo "*************************"

  sleep 2
  
    elif [ $RECC = 1 ]
    then
    
echo "****************************************"
echo "*                                      *"
echo "*  In recovery mode, rebooting to adb  *"
echo "*                                      *"
echo "****************************************"

    adb reboot bootloader &> /dev/null
    
echo
echo "Waiting for device..."
      
    fastboot wait-for-device
  
  clear
      
echo "******* [SUCCESS] *******"
echo "*                       *"
echo "*  fastboot connected.  *"
echo "*                       *"
echo "*************************"

  sleep 2

    elif [ $FBTC = 0 ] && [ $ADBC = 0 ] && [ $RECC = 0 ]
    then
    
echo "********* [ERROR] *********"
echo "*                         *"
echo "*  Cannot detect device!  *"
echo "*                         *"
echo "***************************"
echo
echo
echo "====== [Press enter] ======"

read
      
    fi
}

##/ Check recovery status /##

recovery_check () {

"device_status"

if [ $RECC = 1 ]
    then

echo "******* [SUCCESS] ******"
echo "*                      *"
echo "*  recovery connected  *"
echo "*                      *"
echo "************************"

  sleep 2

    elif [ $ADBC = 1 ]
    then

echo "******************************************"
echo "*                                        *"
echo "*  Not in recovery, booting to recovery  *"
echo "*                                        *"
echo "******************************************"

      adb reboot recovery &> /dev/null
      
echo
echo "Waiting for device..."

    until [ $RECC = 1 ]
    do

  sleep 1
  
"device_status"

    done

  clear

echo "******* [SUCCESS] ******"
echo "*                      *"
echo "*  recovery connected  *"
echo "*                      *"
echo "************************"

  sleep 2

    elif [ $FBTC = 1 ]
    then

echo "*********************************************"
echo "*                                           *"
echo "*  In fastboot mode, rebooting to recovery  *"
echo "*                                           *"
echo "*********************************************"

      fastboot reboot &> /dev/null
      
echo
echo "Waiting for device..."
      
    adb wait-for-device
    
echo
echo "adb connected, rebooting to recovery"
      
    adb reboot recovery
    
echo
echo "Waiting for device..."

        until [ $RECC = 1 ]
        do

      sleep 1
      
"device_status"

        done

  clear

echo "******* [SUCCESS] ******"
echo "*                      *"
echo "*  recovery connected  *"
echo "*                      *"
echo "************************"

  sleep 2

    elif [ $FBTC = 0 ] && [ $ADBC = 0 ] && [ $RECC = 0 ]
    then

echo "********* [ERROR] *********"
echo "*                         *"
echo "*  Cannot detect device!  *"
echo "*                         *"
echo "***************************"
echo
echo
echo "====== [Press enter] ======"

read

    fi
    
}

##/ Start script /##

	    while true
	    do

	  clear

	echo "*************** [Main menu] **************"
	echo "*                                        *"
	echo "*  1) Install/update adb drivers.        *"
	echo "*  2) Install/update fastboot drivers.   *"
	echo "*  3) List adb commands.                 *"
	echo "*  4) List fastboot commands.            *"
	echo "*  5) List TWRP adb commands.            *"
	echo "*                                        *"
	echo "*  0) Exit.                              *"
	echo "*                                        *"
	echo "******************************************"
	echo

	  read a
	  
	    case $a in

	1)

	  clear

	      apt-get install android-tools-adb

	echo      
	echo "***********************************"
	echo "*                                 *"
	echo "*  Installation/update complete.  *"
	echo "*                                 *"
	echo "***********************************"
	echo
	echo
	echo "=====[Press enter to continue]=====" 
	
	  read;;

	2)

	  clear

	      apt-get install android-tools-fastboot

	echo      
	echo "***********************************"
	echo "*                                 *"
	echo "*  Installation/update complete.  *"
	echo "*                                 *"
	echo "***********************************"
	echo
	echo
	echo "=====[Press enter to continue]=====" 
	
	  read;;

		3)
		
		  clear
		  
		  "adb_check"
  
		    while true
		    do

		  clear

		echo "***************** [ADB] ******************"
		echo "*                                        *"
		echo "*  1) adb devices                        *"
		echo "*  2) adb reboot                         *"
		echo "*  3) adb reboot recovery                *"
		echo "*  4) adb reboot bootloader              *"
		echo "*  5) adb push file                      *"
		echo "*  6) adb pull file                      *"
		echo "*  7) adb install apk                    *"
		echo "*  8) adb uninstall apk                  *"
		echo "*  9) adb shell                          *"
		echo "*  10) adb logcat                        *"
		echo "*  11) adb logcat > file                 *" 
		echo "*                                        *"
		echo "*  0) Return to main menu                *"
		echo "*                                        *"
		echo "******************************************"
		echo

		  read b
		  
		    case $b in

		1)

		  clear

		      xterm -hold -e "adb devices" & ;;

		2)

		  clear
		  stty intr ^-

		      adb reboot

		  stty intr '' ;;

		3)

		  clear  
		  stty intr ^-

		      adb reboot recovery

		  stty intr '' ;;

		4)

		  clear
		  stty intr ^-

		      adb reboot bootloader

		  stty intr '' ;;

		5)

		  clear

		echo "*************************************"
		echo "*                                   *"
		echo "*  Enter full path to file source:  *"
		echo "*                                   *"
		echo "*************************************"
		echo 
  
		  read SORC
		  
		    [[ $SORC == '' ]]

		  clear

		echo "******************************************"
		echo "*                                        *"
		echo "*  Enter full path to file destination:  *"
		echo "*                                        *"
		echo "******************************************"
		echo 

		  read DEST
		  
		    [[ $DEST == '' ]]

		  clear

		echo "[Moveving]- $SORC -[to]- $DEST"
		echo 

		  sleep 2  
		  clear
		  stty intr ^-

		      adb push "$SORC" "$DEST" 

		  stty intr ''

		echo
		echo "****************************"
		echo "*                          *"
		echo "*  Press enter to return.  *"
		echo "*                          *"
		echo "****************************" 
		
		  read ;;
		      
		6)

		  clear

		echo "*************************************"
		echo "*                                   *"
		echo "*  Enter full path to file source:  *"
		echo "*                                   *"
		echo "*************************************"
		echo 

		  read SORC1
  
		    [[ $SORC1 == '' ]]

		  clear

		echo "******************************************"
		echo "*                                        *"
		echo "*  Enter full path to file destination:  *"
		echo "*                                        *"
		echo "******************************************"
		echo 

		  read DEST1
  
		    [[ $DEST1 == '' ]]

		  clear

		echo "[Moveing]- $SORC1 -[To]- $DEST1"
		echo 

		  sleep 2
		  stty intr ^-

		      adb pull "$SORC1" "$DEST1" 

		  stty intr ''

		echo
		echo "****************************"
		echo "*                          *"
		echo "*  Press enter to return.  *"
		echo "*                          *"
		echo "****************************" 
		
		  read ;;

		7)

		  clear
  
		echo "****************************************************"
		echo "*                                                  *"
		echo "*  Enter the path to the apk you want to install:  *"
		echo "*                                                  *"
		echo "****************************************************"
		echo

		  read INST
  
		    [[ $INST == '' ]]

		  clear

		echo "Installing $INST"
		echo

		  sleep 2
		  stty intr ^-

		      adb install "$INST"

		  stty intr ''
		  
		echo
		echo "****************************"
		echo "*                          *"
		echo "*  Press enter to return.  *"
		echo "*                          *"
		echo "****************************"
		
		  read;;

		8)

		  clear

		echo "******************************************************"
		echo "*                                                    *"
		echo "*  Enter the name to the apk you want to uninstall:  *"
		echo "*                                                    *"
		echo "******************************************************"
		echo

		  read UNST
  
		    [[ $UNST == '' ]]

		  clear

		echo "Uninstalling $UNST"
		echo

		  sleep 2
		  stty intr ^-

		      adb uninstall "$UNST"

		  stty intr '' 

		echo
		echo "****************************"
		echo "*                          *"
		echo "*  Press enter to return.  *"
		echo "*                          *"
		echo "****************************"

		  read ;;

		9)

		  clear

		      xterm -hold -e "adb shell" & ;;

		10)

		  clear

		      xterm -hold -e "adb logcat" & ;;

		11)

		  clear

		      xterm -hold -e "adb logcat > $LFIL" & ;;

		0)

		  clear
		  break ;;

		*)

		  clear 

		echo "****** [ERROR] ******"
		echo "*                   *"
		echo "*  Invalid option!  *"
		echo "*                   *"
		echo "*********************"
		echo
		echo
		echo "=== [Press enter] ==="

		  read ;;

		    esac
		    done ;;

			4)
			
			  clear
			  
			  "fastboot_check"
			  
			    while true
			    do

			  clear

			echo "************** [FASTBOOT] ****************"
			echo "*                                        *"
			echo "*  1) fastboot devices.                  *"
			echo "*  2) fastboot reboot.                   *"
			echo "*  3) fastboot reboot bootloader.        *"
			echo "*  4) fastboot oem unlock.               *"
			echo "*  5) fastboot oem lock.                 *"
			echo "*  6) fastboot boot recovery.            *"
			echo "*  7) fastboot flash recovery.           *"
			echo "*  8) fastboot erase userdata.          *"
			echo "*                                        *"
			echo "*  0) Return to main menu                *"
			echo "*                                        *"
			echo "******************************************"
			echo

			  read c

			    case $c in
    
			1) 

			  clear

			      xterm -hold -e "fastboot devices" &  ;;
    
			2)

			  clear
			  stty intr ^-
  
			      fastboot reboot 
      
			  stty intr '' ;;

			3)

			  clear
			  stty intr ^-
  
			      fastboot reboot bootloader

			  stty intr '' ;;
  
			4)

			  clear
			  stty intr ^-
  
			      fastboot oem unlock
    
			  stty intr '' ;;
      
			5)

			  clear
			  stty intr ^-
  
			      fastboot oem lock
      
			  stty intr '' ;;
      
			6)

			  clear
  
			echo "**************************************"
			echo "*                                    *"
			echo "*  Enter full path to recovery.img:  *"
			echo "*                                    *"
			echo "**************************************"
			echo

			  read BREC

			    [[ $BREC == '' ]]
    
			  clear

			echo "************************ [BOOT] ************************"
			echo 
			echo "$BREC "
			echo 
			echo "***************** [As your recovery?!] *****************"
			echo
			echo "======================== [y/n] ========================="

			  read CONF
			  
			    if [[ $CONF == 'y' ]]
			    then
  
			echo "Booting $BREC"
			echo

			  sleep 2
			  stty intr ^-
      
			      fastboot boot recovery "$BREC"
      
			  stty intr ''
      
			    else

			echo
			echo "******************************"
			echo "*                            *"
			echo "*  Cancelled recovery boot.  *"
			echo "*                            *"
			echo "******************************"
			echo
			echo "======== [Press enter] ======="

			  read
  
			    fi ;;
      
			7)

			  clear
  
			echo "**************************************"
			echo "*                                    *"
			echo "*  Enter full path to recovery.img:  *"
			echo "*                                    *"
			echo "**************************************"
			echo

			  read FREC

			    [[ $FREC == '' ]]
    
			  clear
  
			echo "*********************** [FLASH] ************************"
			echo 
			echo "$FREC "
			echo 
			echo "***************** [As your recovery?!] *****************"
			echo
			echo "======================== [y/n] ========================="

			  read CONF1
			  
			    if [[ $CONF1 == 'y' ]]
			    then
  
			echo "Flashing $FREC"

			  sleep 2
			  stty intr ^-
  
			      fastboot flash recovery "$FREC"
      
			  stty intr ''
      
			    else

			echo
			echo "******************************"
			echo "*                            *"
			echo "*  Cancelled recovery flash. *"
			echo "*                            *"
			echo "******************************"
			echo
			echo "======== [Press enter] ======="

			  read 
 
			    fi ;;
    
			8)

			  clear

			echo "************************ [WARNING] *************************"
			echo "*                                                          *"
			echo "*  Will delete all personal data. Do you wish to proceed?  *"
			echo "*                                                          *"
			echo "************************************************************"
			echo
			echo "========================== [y/n] ==========================="
  
			  read CONF2
  
			    if [[ $CONF2 == 'y' ]]
			    then
    
			echo "Deleting all user data"
			echo

			  sleep 2  
			  stty intr ^-
      
			      fastboot erase userdata
      
			  stty intr ''
      
			    else

			echo
			echo "******************************"
			echo "*                            *"
			echo "*  Cancelled factory reset.  *"
			echo "*                            *"
			echo "******************************"
			echo
			echo "======== [Press enter] ======="

			  read 
 
			    fi ;;

			0)

			  clear
			  break ;;
  
			*) 

			  clear 

			echo "****** [ERROR] ******"
			echo "*                   *"
			echo "*  Invalid option!  *"
			echo "*                   *"
			echo "*********************"
			echo
			echo
			echo "=== [Press enter] ==="

			  read ;;
  
			    esac
			    done ;;

				5)
				
				  clear
				
				"recovery_check"

				    while true
				    do
    
				  clear
 
				echo "**************** [TWRP] ******************"
				echo "*                                        *"
				echo "*  1) Root.                              *"
				echo "*  2) Take backup & put on PC.           *"
				echo "*  3) Take backup & keep on device.      *"
				echo "*  4) Restore backup.                    *"
				echo "*  5) Flash .zip.                        *"
				echo "*                                        *"
				echo "*  0) Return to main menu                *"
				echo "*                                        *"
				echo "******************************************"
				echo

				  read d 

				    case $d in
    
				1)

				  clear
				  cd $SFIL
  
				echo
				echo "************************"
				echo "*                      *"
				echo "*  Downloading su.zip  *"
				echo "*                      *"
				echo "************************"
				echo

				  wget http://download.chainfire.eu/396/SuperSU/UPDATE-SuperSU-v1.94.zip?retrieve_file=1

				echo
				echo "******************************"
				echo "*                            *"
				echo "*  Pushing su.zip to device  *"
				echo "*                            *"
				echo "******************************"
				echo
  
				  stty intr ^-
  
				      adb push "$SFIL/UPDATE-SuperSU-v1.94.zip?retrieve_file=1" "/data/local/"
      
				  stty intr ''

				echo
				echo "*********************"
				echo "*                   *"
				echo "*  Flashing su.zip  *"
				echo "*                   *"
				echo "*********************"
				echo

				  stty intr ^-
    
				      adb shell twrp install "/data/local/UPDATE-SuperSU-v1.94.zip?retrieve_file=1"
	
				  stty intr ''
				  
				echo
				echo "***********************"
				echo "*                     *"
				echo "*  Done. Press enter  *"
				echo "*                     *"
				echo "***********************"
				echo

				  read
				  cd $CDIR ;;
    
				2)

				  clear
				  
				echo "***********************"
				echo "*                     *"
				echo "*  Backing up device  *"
				echo "*                     *"
				echo "***********************"
				echo
				  
				  stty intr ^-
  
				      adb shell twrp backup SDBOM backup_$DATE
      
				  stty intr ''
				  
				echo "********************************"
				echo "*                              *"
				echo "*  Pulling backup from device  *"
				echo "*                              *"
				echo "********************************"
				echo
				
				  stty intr ^-
  
				      adb pull "/data/media/0/TWRP/BACKUPS/*/backup_*" "$BFIL"
      
				  stty intr '' ;;
  
				3)

				  clear
				  stty intr ^-
  
				      adb shell twrp -O backup SDBOM

				  stty intr '' ;;
  
				4)

				  clear ;;
  
				5)

				  clear ;;

				0)

				  clear
				  break ;;
  
				*) 

				  clear 

				echo "****** [ERROR] ******"
				echo "*                   *"
				echo "*  Invalid option!  *"
				echo "*                   *"
				echo "*********************"
				echo
				echo
				echo "=== [Press enter] ==="

				  read ;;
  
				    esac
				    done ;;
    
					0)  
    
					  clear
  
					    while true
					    do
    
					  clear

					echo "************ [EXIT] ************"
					echo "*                              *"
					echo "*  1) Delete all files.        *"
					echo "*  2) Delete logcats.          *"
					echo "*  3) Delete backups.          *"
					echo "*  4) Delete su.zip.           *"
					echo "*  5) Delete su.zip & logcats  *"
					echo "*  6) Delete su.zip & backups  *"
					echo "*                              *"
					echo "*  0) Save all files.          *"
					echo "*                              *"
					echo "********************************"
					echo

					  read e
					  
					    case $e in
    
					1)

					  clear
					  rm -rf "$CDIR/android-tools"
  
					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;
  
					2)

					  clear
					  rm -rf "$CDIR/android-tools/logcat"
  
					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;
  
					3)

					  clear
					  rm -rf "$CDIR/android-tools/backup" 
  
					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;
  
					4)

					  clear
					  rm -rf "$CDIR/android-tools/su_zip"
  
					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;
  
					5)

					  clear
					  rm -rf "$CDIR/android-tools/su_zip"
					  rm -rf "$CDIR/android-tools/logcat"
  
					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;
  
					6)

					  clear
					  rm -rf "$CDIR/android-tools/su_zip"
					  rm -rf "$CDIR/android-tools/backup"
  
					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;
  
					0)

					  clear

					echo "*** [EXIT] ***"
					echo "*            *"
					echo "*  Goodbye!  *"
					echo "*            *"
					echo "**************"
					echo

					  sleep 2
					  clear
					  exit ;;

					    esac
					    done ;;
  
	*) 

	  clear 

	echo "****** [ERROR] ******"
	echo "*                   *"
	echo "*  Invalid option!  *"
	echo "*                   *"
	echo "*********************"
	echo
	echo
	echo "=== [Press enter] ==="

	  read
	  clear ;;
  
	    esac
	    done

    else
    
  clear
  
echo "*** [EXIT] ***"
echo "*            *"
echo "*  Goodbye!  *"
echo "*            *"
echo "**************"
echo

  sleep 2
  clear
  exit
  
    fi
