#Everytime you execute a command, the command executed (along with some information about it) gets written to a file called .custom_history.txt. This is better than just using the history command since it saves more comprehensive information about the command, and the .custom_history command collects all of the commands whether or not you are on a regular login node or qrsh
HOSTNAME=$(hostname)
preexec () {
  #echo -n $PWD ' ' $HOSTNAME ' ' >> ~/.history_archive.txt
  #echo $* >> ~/.history_archive.txt
  NOW=`date  --rfc-3339=date`;
  YEAR=`date +%Y`;
  DAY=$DATENUM; #Datenume is environment variable that is set in .bashrc based on the file .date.txt
  echo -n  "$*" >> ~/.custom_history.txt
  echo -ne "\t" >> ~/.custom_history.txt
  echo -e $NOW"\t"$PWD"\t"$HOSTNAME"\t"$DAY >> ~/.custom_history.txt
}
preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`;
    #local this_command=`history 1`;
    preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG
