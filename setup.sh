#!/bin/bash

# Color variables

GREEN="\033[0;32m"
RED="\033[0;33m"
RESET="\033[0;0m"

# Check sudo
if [[ ! -f "/usr/bin/sudo" ]]; then
  echo -e "["$RED"-"$RESET"] Sudo not installed !"
  echo -e "Log as root and install it !"
  exit 1
fi

# RED_HAT
if [[ -f "/usr/bin/dnf" || -f "/usr/bin/yum" ]]; then
  USER_DISTRO="RED_HAT"
fi
cat /etc/os-release | grep -i "redhat" >/dev/null
if [[ "$?" -eq 0 ]]; then
  echo -e "["$GREEN"+"$RESET"] RedHat like OS\n"
  USER_DISTRO="RED_HAT"
fi

# Debian
if [[ -f "/usr/bin/apt" ]]; then
  USER_DISTRO="DEBIAN"
fi
cat /etc/os-release | grep -i "debian" >/dev/null
if [[ "$?" -eq 0 ]]; then
  echo -e "["$GREEN"+"$RESET"] Debian like OS\n"
  USER_DISTRO="DEBIAN"
fi

# Arch
if [[ -f "/usr/bin/pacman" ]]; then
  USER_DISTRO="Arch"
fi
cat /etc/os-release | grep -i "arch" >/dev/null
if [[ "$?" -eq 0 ]]; then
  echo -e "["$GREEN"+"$RESET"] Arch like OS\n"
  USER_DISTRO="Arch"
fi

PACKAGES=("git curl zsh wget fzf lsd")

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
  echo -e "[+] Check Packages ..."
  for package in ${PACKAGES[@]}; do
    rpm --query $package >/dev/null

    if [[ $? -eq "0" ]]; then
      echo -e "[+] $package installed"
    else
      echo -e "[-] "$package" not installed\n Install it ..."
      sudo dnf install "$package" -y
    fi
  done

  ;;
Arch)
  echo -e "[+] Check Packages ..."
  for package in ${PACKAGES[@]}; do
    pacman -Q $package >/dev/null

    if [[ $? -eq "0" ]]; then
      echo -e "[+] $package installed"
    else
      echo -e "[-] "$package" not installed"
      echo -e "[+] Try to install "$package""
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

# Install Plug-in
echo -e "["$GREEN"+"$RESET"] Install all oh-my-zsh plugins .."
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting && echo -e "["$GREEN"+"$RESET"] zsh-syntax-highlighting installed"
git clone --quiet https://github.com/zsh-users/zsh-completions && echo -e "["$GREEN"+"$RESET"] zsh-completions installed"
git clone --quiet https://github.com/zsh-users/zsh-autosuggestions && echo -e "["$GREEN"+"$RESET"] zsh-autosuggestions installed"
git clone --quiet https://github.com/zsh-users/zsh-history-substring-search && echo -e "["$GREEN"+"$RESET"] zsh-history-substring-search installed"

# Moove plug-in into zsh dir
mv zsh* ~/.oh-my-zsh/plugins
echo -e "\n"
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
  if [[ $choice -eq "1" ]] || [[ $choice -eq "2" ]]; then
    if [[ $choice -eq "1" ]]; then
      sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="chibraax"/g' .zshrc
      # Copy personnal theme into dir
      cat <<EOF >>~/.oh-my-zsh/themes/chibraax.zsh-theme
# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}💀%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}⚡⚡%b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}⚡⚡%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
RPROMPT='[%*]'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
EOF
      echo -e "[+] Theme added to ~/.zshrc"
      echo -e "[+] Theme located in : ~/.oh-my-zsh/themes/chibraax.zsh-theme"
      break
    elif [[ "$choice" -eq "2" ]]; then
      sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="chibraax2"/g' .zshrc
      cat <<EOF >>~/.oh-my-zsh/themes/chibraax2.zsh-theme
# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}🎃%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}🩸🩸%b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}🩸🩸%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
RPROMPT='[%*]'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
EOF
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

# Alias for LSD
echo -e "# Custom alias made by script" >>~/.zshrc
echo -e "alias ls=/usr/bin/lsd" >>~/.zshrc
echo -e "\n["$RED"*"$RESET"] NB: Now your 'ls' command will execute LSD, if you want change this uncomment the alias inside your .zshrc"
exec zsh -l && source .zshrc
exit 0
