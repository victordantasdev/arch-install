#!/bin/bash

# colors
red='\e[1;91m'
green='\e[1;92m'
reset='\e[0m'

helpFunction() {
  echo ""
  echo "Usage: $0 -u victor -i gnome"
  echo -e "\t-u set user name"
  echo -e "\t-b set the GUI to be installed [gnome, kde, xfce, i3wm]"
  exit 1 # Exit script after printing help
}

while getopts "u:i:" opt; do
  case "$opt" in
  u) username="$OPTARG" ;;
  i) gui="$OPTARG" ;;
  ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

install() {
  echo "Username: $username"
  echo "Interface: $gui"

  # install GUI
  if [ "$gui" == "gnome" ]; then
    echo -e "\n${green}installing gnome${reset}"
  elif [ "$gui" == "kde" ]; then
    echo -e "\n${green}installing kde${reset}"
  elif [ "$gui" == "xfce" ]; then
    echo -e "\n${green}installing xfce${reset}"
  elif [ "$gui" == "i3" ]; then
    echo -e "\n${green}installing i3${reset}"
  else
    echo -e "\n${red}gui not recognized!${reset}"
    helpFunction
    exit 1
  fi
}

# Print helpFunction in case parameters are empty
if [ -z "$username" ] || [ -z "$gui" ]; then
  echo "Some or all of the parameters are empty"
  helpFunction
else
  install
fi
