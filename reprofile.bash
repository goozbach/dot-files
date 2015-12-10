# source user definitions, only show output if $PS1 set
# to add a new one, drop it in ${HOME}/.profile.d/
reprofile(){
  if [ -d ${HOME}/.profile.d/ ]; then
    # sourcing *.sh
    for i in $(echo ${HOME}/.profile.d/*.bash ${HOME}/.profile.d/*.sh | sort -n ); do
      if [ -r "$i" ]; then
        if [ "$PS1" ]; then
          source $i
        else
          source $i &>/dev/null
        fi
      fi
    done
  fi
}
reprofile

