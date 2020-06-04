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
  
do_boot_splash() {
  if [ ! -e /usr/share/plymouth/themes/pix/pix.script ]; then
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
    printf '_,_ _,_,  _    __, _    __,_  ,_____,_, _ _, _ _,_, _ _,%s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
    printf '|_//_\|   |    |_) |    |_ '\/  | |_ |\ |(_  |/ \|\ |(_ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
    printf '| \| || , |    |   |    |   /\  | |  | \|, ) |\ /| \|, )%s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
    printf '~ ~~ ~~~~ ~    ~   ~    ~~~~  ~ ~ ~~~~  ~ ~  ~ ~ ~  ~ ~ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
    printf "${BLUE}%s\n" "Hooray! kali-Pi-Extensions Splash has been updated and/or is at the current version."
  fi
}