# Use colors, but only if connected to a terminal, and that terminal
# supports them.
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
  
#!/bin/sudo bash

#image Generator for Berryboot

if [ "$EUID" -ne 0 ]
then 
    echo 1>&2 "Please run as root"
    exit 1
fi

#date
date=$(date +"%d-%b-%Y")
ImageDir="/usr/share/plymouth/themes/DemonWare"

sleep 1
clear
#Some artwork...
                                                     #"
echo ""
echo "#### INSTALLING DemonWARE Bootanimation ####"
echo ""

#OS Menu Selection
PS3='Please select your OS: '
options=("Skip" "Kali/Debian" "Ubuntu" "Fedora" "ArchLinux")
select opt in "${options[@]}"
do
    case $opt in
        "Skip")
            break
            ;;
        "Kali/Debian")

echo ""
echo "#### INSTALLING plymouth-themes ####"
echo ""		
#installing packages
sudo apt-get update && sudo apt-get install -y plymouth-themes
echo ""
sudo mkdir /usr/share/plymouth/themes/DemonWARE
echo "#### DONE! ####"
echo ""
			break
            ;;
        *) echo invalid option;;
    esac
done
sleep 1
clear

#     ___  ___   ___      _        _   _          
#    / _ \/ __| / __| ___| |___ __| |_(_)___ _ _  
#   | (_) \__ \ \__ \/ -_) / -_) _|  _| / _ \ ' \ 
#    \___/|___/ |___/\___|_\___\__|\__|_\___/_||_|
#                                                 

echo ""
echo "#### OPERATING SYSTEM SELECTION ####"
echo ""

#OS Menu Selection
PS3='Please select the OS: '
options=("Android" "Kali Linux" "Ubuntu eoan" "Debian (dosbian_v1.5)" "RetroPie Armbian" "LibreELEC (Kodi)" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "LibreELEC (Kodi)")
#Starting LibreELEC Script
sudo bash <(wget -qO- https://github.com/D3vD3m0n/Image-Generator-for-Berryboot/blob/master/os-selection/libreelec/libreelec_by_berryserver.sh)
		break
            ;;
        "Kali Linux")
sudo bash <(wget -qO- https://github.com/D3vD3m0n/Image-Generator-for-Berryboot/blob/master/os-selection/kali/Kali_2020_2a_berryboot.sh)
		break
            ;;
        "Android")
sudo bash <(wget -qO- https://github.com/D3vD3m0n/Image-Generator-for-Berryboot/blob/master/os-selection/android/android_by_berryserver.sh)
		break
            ;;
        "Ubuntu eoan")
sudo bash <(wget -qO- https://github.com/D3vD3m0n/Image-Generator-for-Berryboot/blob/master/os-selection/ubuntu/ubuntu_by_berryserver.sh)
		break
            ;;
        "Debian (dosbian_v1.5)")
sudo bash <(wget -qO- https://github.com/D3vD3m0n/Image-Generator-for-Berryboot/blob/master/os-selection/debian/debian_by_berryserver.sh)
		break
            ;;
        "RetroPie Armbian")
sudo bash <(wget -qO- https://github.com/D3vD3m0n/Image-Generator-for-Berryboot/blob/master/os-selection/retropie/retropie_by_berryserver.sh)
		break
            ;;
        "Exit")
            break
            ;;
        *) echo invalid option
        exit
        ;;
    esac    
done
exit
sudo mkdir ./{{ThemeNameHere}}
if [ ! -e /usr/share/plymouth/themes/DemonWARE/animated-boot.script ]; then
    sudo mkdir /usr/share/plymouth/themes/DemonWARE
    cd 
    return 1
  fi
function do_boot_splash() {
  if [ ! -e /usr/share/plymouth/themes/DemonWARE/animated-boot.script ]; then
    if [ "$INTERACTIVE" = True ]; then
      whiptail --msgbox "The splash screen is not installed so cannot be activated" 20 60 2
    fi
    return 1
  fi
  DEFAULT=--defaultno
  if [ $(get_boot_splash) -eq 0 ]; then
    DEFAULT=
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --yesno "Would you like to show the splash screen at boot?" $DEFAULT 20 60 2
    RET=$?
  else
    RET=$1
  fi
  if [ $RET -eq 0 ]; then
    if is_pi ; then
      if ! grep -q "splash" $CMDLINE ; then
        sed -i $CMDLINE -e "s/$/ quiet splash plymouth.ignore-serial-consoles/"
      fi
    else
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 quiet splash plymouth.ignore-serial-consoles\"/"
      sed -i /etc/default/grub -e "s/  \+/ /g"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\" /GRUB_CMDLINE_LINUX_DEFAULT=\"/"
      update-grub
    fi
    STATUS=enabled
  elif [ $RET -eq 1 ]; then
    if is_pi ; then
      if grep -q "splash" $CMDLINE ; then
        sed -i $CMDLINE -e "s/ quiet//"
        sed -i $CMDLINE -e "s/ splash//"
        sed -i $CMDLINE -e "s/ plymouth.ignore-serial-consoles//"
      fi
    else
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)quiet\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1\2\"/"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)splash\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1\2\"/"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)plymouth.ignore-serial-consoles\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1\2\"/"
      sed -i /etc/default/grub -e "s/  \+/ /g"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\" /GRUB_CMDLINE_LINUX_DEFAULT=\"/"
      update-grub
    fi
    STATUS=disabled
  else
    return $RET
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "Splash screen at boot is $STATUS" 20 60 1
    banner
    printf "${BLUE}%s\n" "Hooray! kali-Pi-Extensions Splash has been updated and/or is at the current version."
  fi
  else
  fi
}

function usage() {
    echo "Usage: $0 [options] [theme]"
    echo
    echo "Options"
    echo "  -l   List available themes"
    echo "  -s   Show all themes"
    echo "  -h   Get this help message"
    exit 1
}

function banner() {
echo "#   (                                         (         #"
echo "#   )\ )                      (  (      (     )\ )      #"
echo "#  (()/(    (    )            )\))(   ' )\   (()/((     #"
echo "#   /(_))  ))\  (     (   (  ((_)()\ |(((_)(  /(_))\    #"
echo "#  (_))_  /((_) )\  ' )\  )\ )(())\_)()\ _ )\(_))((_)   #"
echo "#   |   \(_)) _((_)) ((_)_(_/( \((_)/ (_)_\(_) _ \ __|  #"
echo "#   | |) / -_) '  \() _ \ ' \)) \/\/ / / _ \ |   / _|   #"
echo "#   |___/\___|_|_|_|\___/_||_| \_/\_/ /_/ \_\|_|_\___|  #"
echo "#                                                       #"
}

function theme_preview() {
    THEME=$1
    THEME_NAME=`echo $THEME | sed s/\.zsh-theme$//`
    print "$fg[blue]${(l.((${COLUMNS}-${#THEME_NAME}-5))..─.)}$reset_color $THEME_NAME $fg[blue]───$reset_color"
    source "$THEMES_DIR/$THEME"
    cols=$(tput cols)
    print -P "$PROMPT                                                                                      $RPROMPT"
}

function noyes() {
    read "a?$1 [y/N] "
    if [[ $a == "N" || $a == "n" || $a = "" ]]; then
        return 0
    fi
    return 1
}

function insert_favlist() {
    if grep -q "$THEME_NAME" $FAVLIST 2> /dev/null ; then
        echo "Already in favlist"
    else
        echo $THEME_NAME >> $FAVLIST
        echo "Saved to favlist"
    fi

}

function splash_installer() {
    for THEME in $(ls $THEMES_DIR); do
        echo
        theme_preview $THEME
        echo
        if [[ -z $1 ]]; then
            noyes "Do you want to add it to your favourite list ($FAVLIST)?" || \
                  insert_favlist $THEME_NAME
            echo
        fi
    done
}

while getopts ":lhs" Option
do
  case $Option in
    l ) list_themes ;;
    s ) theme_chooser 0 ;;
    h ) usage ;;
    * ) usage ;; # Default.
  esac
done

if [[ -z $Option ]]; then
    if [[ -z $1 ]]; then
        banner
        echo
        theme_chooser
    else
        theme_preview $1".zsh-theme"
    fi
fi
