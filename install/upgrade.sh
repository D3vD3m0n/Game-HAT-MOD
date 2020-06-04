# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if [ -t 1 ]; then
  RB_RED=$(printf '\033[38;5;196m')
  RB_ORANGE=$(printf '\033[38;5;202m')
  RB_YELLOW=$(printf '\033[38;5;226m')
  RB_GREEN=$(printf '\033[38;5;082m')
  RB_BLUE=$(printf '\033[38;5;021m')
  RB_INDIGO=$(printf '\033[38;5;093m')
  RB_VIOLET=$(printf '\033[38;5;163m')

  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
else
  RB_RED=""
  RB_ORANGE=""
  RB_YELLOW=""
  RB_GREEN=""
  RB_BLUE=""
  RB_INDIGO=""
  RB_VIOLET=""

  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  RESET=""
fi

cd "$PIEX"

# Set git-config values known to fix git errors
# Line endings (#4069)
git config core.eol lf
git config core.autocrlf false
# zeroPaddedFilemode fsck errors (#4963)
git config fsck.zeroPaddedFilemode ignore
git config fetch.fsck.zeroPaddedFilemode ignore
git config receive.fsck.zeroPaddedFilemode ignore
# autostash on rebase (#7172)
resetAutoStash=$(git config --bool rebase.autoStash 2>&1)
git config rebase.autoStash true

# Update upstream remote to ohmyzsh org
remote=$(git remote -v | awk '/https:\/\/github\.com\/D3vD3m0n\/kali-Pi-Extensions\.git/{ print $1; exit }')
if [ -n "$remote" ]; then
  git remote set-url "$remote" "https://github.com/D3vD3m0n/kali-Pi-Extensions.git"
fi

printf "${BLUE}%s${RESET}\n" "Updating kali-Pi-Extensions"
if git pull --rebase --stat origin master
then
  printf '_,_ _,_,  _    __, _    __,_  ,_____,_, _ _, _ _,_, _ _,%s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '|_//_\|   |    |_) |    |_ '\/  | |_ |\ |(_  |/ \|\ |(_ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '| \| || , |    |   |    |   /\  | |  | \|, ) |\ /| \|, )%s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf '~ ~~ ~~~~ ~    ~   ~    ~~~~  ~ ~ ~~~~  ~ ~  ~ ~ ~  ~ ~ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_BLUE $RB_INDIGO $RB_VIOLET $RB_RESET
  printf "${BLUE}%s\n" "Hooray! kali-Pi-Extensions has been updated and/or is at the current version."
else
  printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
fi

# Unset git-config values set just for the upgrade
case "$resetAutoStash" in
  "") git config --unset rebase.autoStash ;;
  *) git config rebase.autoStash "$resetAutoStash" ;;
esac
