#!/bin/bash

# Color variables
GREEN="\033[0;32m"
RED="\033[0;33m"
RESET="\033[0;0m"

# All themes
function prompt1() {
  cat <<EOF >>~/.oh-my-zsh/themes/chibraax.zsh-theme
# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}💀%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}⚡⚡%b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}⚡⚡%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
RPROMPT='[%*]'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
EOF
}

function prompt2() {
  cat <<EOF >>~/.oh-my-zsh/themes/chibraax2.zsh-theme
# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}🎃%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}🩸🩸%b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}🩸🩸%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
RPROMPT='[%*]'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
EOF
}

# Check sudo
test -f "/usr/bin/sudo" || eval " echo -e "[-] sudo not installed ! log as root and install it !" && exit 1"

# RED_HAT
test -f "/usr/bin/dnf" || test -f "/usr/bin/yum" && USER_DISTRO=RED_HAT
grep -iq "redhat" /etc/os-release && echo -e "["$GREEN"+"$RESET"] RedHat like OS\n"
USER_DISTRO="RED_HAT"

# Debian
test -f "/usr/bin/dnf" || test -f "/usr/bin/apt-get" && USER_DISTRO=DEBIAN
grep -iq "debian" /etc/os-release && echo -e "["$GREEN"+"$RESET"] Debian like OS\n" && USER_DISTRO="DEBIAN"

# Arch
test -f "/usr/bin/pacman" && USER_DISTRO=Arch
grep -iq "arch" /etc/os-release && echo -e "["$GREEN"+"$RESET"] Arch like OS\n" && USER_DISTRO="Arch"

PACKAGES=("git curl zsh wget fzf lsd bat")
case "$USER_DISTRO" in

DEBIAN)
  echo -e "["$GREEN"+"$RESET"] Check Packages ..."
  for package in ${PACKAGES[@]}; do
    apt show $package 2>/dev/null | grep -i "APT-Manual-Installed: yes" >/dev/null

    if [[ $? -eq "0" ]]; then
      echo -e "["$GREEN"+"$RESET"] $package installed\n"
    else
      echo -e "["$RED"-"$RESET"] $package not installed"
      echo -e "[*] Try to install $package"
      sudo apt-get -qq install $package -y 2>/dev/null && echo -e "["$GREEN"+"$RESET"] $package installed\n"
    fi
  done

  ;;
RED_HAT)
  echo -e "[$GREEN+$RESET] Check Packages ..."
  for package in ${PACKAGES[@]}; do
    rpm --query $package >/dev/null

    if [[ $? -eq "0" ]]; then
      echo -e "[$GREEN+$RESET] $package installed"
    else
      echo -e "[$RED-$RESET] "$package" not installed\n Install it ..."
      sudo dnf install "$package" -y
    fi
  done

  ;;
Arch)
  echo -e "["$GREEN"+"$RESET"] Check Packages ..."
  for package in ${PACKAGES[@]}; do
    pacman -Q $package >/dev/null

    if [[ $? -eq "0" ]]; then
      echo -e "["$GREEN"+"$RESET"] $package installed"
    else
      echo -e "[$RED-$RESET] "$package" not installed"
      echo -e "[$GREEN+$RESET] Try to install "$package""
      sudo pacman -Syu "$package"

    fi
  done
  ;;
esac

# Change shell
echo -e "["$GREEN"+"$RESET"] Make ZSH default shell"
chsh -s /usr/bin/zsh

# Install OhMyZsh
cd ~
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh >install.sh && chmod +x install.sh
sh install.sh --unattended >/dev/null

# Install Plugins
echo -e "["$GREEN"+"$RESET"] Install all oh-my-zsh plugins ..\n"
ALL_PLUGINS=(zsh-completions zsh-syntax-highlighting zsh-autosuggestions)
for plugin in ${ALL_PLUGINS[@]}; do
  if [[ ! -d "$HOME/.oh-my-zsh/plugins/$plugin" ]]; then
    echo -e "[$RED-$RESET]$plugin not installed, install it ..."
    mkdir $HOME/.oh-my-zsh/plugins/$plugin
    git clone --quiet https://github.com/zsh-users/$plugin $HOME/.oh-my-zsh/plugins/$plugin && echo -e "["$GREEN"+"$RESET"] $plugin installed\n"
  else
    echo -e "[$GREEN+$RESET]$plugin already installed.\n"
    continue
  fi
done

# Moove plug-in into zsh dir
echo -e "\n\n"
while true; do
  if [[ ! -z "$USER" && ! -z "$HOSTNAME" ]]; then
    echo -e "1: ┌─[$USER💀$HOSTNAME]⚡⚡[/some/random/path]⚡⚡[0000]
     └─[$]"
    echo -e "2: ┌─[$USER🎃$HOSTNAME]🩸🩸[/some/random/path]🩸🩸[0000]
     └─[$]"
  else
    echo -e "1: ┌─[user💀hostname]⚡⚡[/some/random/path]⚡⚡[0000]
   └─[$]"
    echo -e "2: ┌─[user🎃hostname]🩸🩸[/some/random/path]🩸🩸[0000]
   └─[$]"
  fi

  read -p "What prompt do you prefer 1 or 2 ? " choice
  echo -e "\n"
  if [[ $choice -eq "1" ]] || [[ $choice -eq "2" ]]; then
    if [[ $choice -eq "1" ]]; then
      sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="chibraax"/g' .zshrc
      prompt1
      echo -e "[$GREEN+$RESET] Theme added to ~/.zshrc"
      echo -e "[$GREEN+$RESET] Theme located in : ~/.oh-my-zsh/themes/chibraax.zsh-theme"
      break
    elif [[ "$choice" -eq "2" ]]; then
      sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="chibraax2"/g' .zshrc
      prompt2
      echo -e "["$GREEN"+"$RESET"] Theme added to ~/.zshrc"
      echo -e "["$GREEN"+"$RESET"] Theme located in : ~/.oh-my-zsh/themes/chibraax2.zsh-theme"
      break
    else
      echo -e "Bad choice"
      echo -e ""
      continue
    fi
  fi
done

# .zshrc for plugins
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf)/g" .zshrc

# Alias for LSD,BATCAT
echo -e "# Custom alias made by script" >>~/.zshrc
echo -e "alias ls=/usr/bin/lsd" >>~/.zshrc
echo -e "alias cat=/usr/bin/batcat" >>~/.zshrc

# Warn the user
echo -e "\n["$RED"*"$RESET"] NB: Now your 'ls' command will execute LSD, if you want change this uncomment the alias inside your .zshrc"
echo -e "["$RED"*"$RESET"] NB: Now your 'cat' command will execute BATCAT, if you want change this uncomment the alias inside your .zshrc\n"

# Execute the ZSH shell
rm ~/install.sh
exec zsh -l && source .zshrc
exit 0
