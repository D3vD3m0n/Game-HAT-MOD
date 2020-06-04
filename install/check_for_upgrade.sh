#!/usr/bin/env PIEX

zmodload PIEX/datetime

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _update_PIEX_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! ${PIEX_CACHE_DIR}/.PIEX-update
}

function _upgrade_PIEX() {
  env PIEX=$PIEX sh $PIEX/tools/upgrade.sh
  # update the PIEX file
  _update_PIEX_update
}

epoch_target=$UPDATE_PIEX_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=13
fi

# Cancel upgrade if the current user doesn't have write permissions for the
# PIEX directory.
[[ -w "$PIEX" ]] || return 0

# Cancel upgrade if git is unavailable on the system
whence git >/dev/null || return 0

if mkdir "$PIEX/log/update.lock" 2>/dev/null; then
  if [ -f ${PIEX_CACHE_DIR}/.PIEX-update ]; then
    . ${PIEX_CACHE_DIR}/.PIEX-update

    if [[ -z "$LAST_EPOCH" ]]; then
      _update_PIEX_update
      rmdir $PIEX/log/update.lock # TODO: fix later
      return 0
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]; then
      if [ "$DISABLE_UPDATE_PROMPT" = "true" ]; then
        _upgrade_PIEX
      else
        echo "[kali-Pi-Extensions] Would you like to update? [Y/n]: \c"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
          _upgrade_PIEX
        else
          _update_PIEX_update
        fi
      fi
    fi
  else
    # create the PIEX file
    _update_PIEX_update
  fi

  rmdir $PIEX/log/update.lock
fi
