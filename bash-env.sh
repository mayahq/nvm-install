#!/usr/bin/env bash
{
  nvm_profile_is_bash_or_zsh() {
  local TEST_PROFILE
  TEST_PROFILE="${1-}"
  case "${TEST_PROFILE-}" in
    *"/.bashrc" | *"/.bash_profile" | *"/.zshrc")
      return
    ;;
    *)
      return 1
    ;;
  esac
  }
  BASH_OR_ZSH=false
  for EACH_PROF in "${HOME}/.bash_profile"; do
    if [ -z "${EACH_PROF-}" ] ; then
      local TRIED_PROFILE
      if [ -n "${PROFILE}" ]; then
        TRIED_PROFILE="${EACH_PROF} (as defined in \$PROFILE), "
      fi
      echo "=> Profile not found. Tried ${TRIED_PROFILE-}~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
      echo "=> Create one of them and run this script again"
      echo "   OR"
      echo "=> Append the following lines to the correct file yourself:"
      command printf "${SOURCE_STR}"
      echo
    else
      if nvm_profile_is_bash_or_zsh "${EACH_PROF-}"; then
        BASH_OR_ZSH=true
      fi
      if ! command grep -qc '/nvm.sh' "$EACH_PROF"; then
        echo "=> Appending nvm source string to $EACH_PROF"
        command printf "${SOURCE_STR}" >> "$EACH_PROF"
      else
        echo "=> nvm source string already in ${EACH_PROF}"
      fi
      # shellcheck disable=SC2016
      if ${BASH_OR_ZSH} && ! command grep -qc '$NVM_DIR/bash_completion' "$EACH_PROF"; then
        echo "=> Appending bash_completion source string to $EACH_PROF"
        command printf "$COMPLETION_STR" >> "$EACH_PROF"
      else
        echo "=> bash_completion source string already in ${EACH_PROF}"
      fi
    fi
    if ${BASH_OR_ZSH} && [ -z "${EACH_PROF-}" ] ; then
      echo "=> Please also append the following lines to the if you are using bash/zsh shell:"
      command printf "${EACH_PROF}"
    fi
  done
}