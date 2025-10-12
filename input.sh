#!/bin/bash

# Check sudo
if [[ ! -f "/usr/bin/sudo" ]]; then
  echo -e "[-] Sudo not installed !"
  echo -e "Log as root and install it !"
  exit 1
fi

# RED_HAT
if [[ -f "/usr/bin/dnf" || -f "/usr/bin/yum" ]]; then
  USER_DISTRO="RED_HAT"
fi
cat /etc/os-release | grep -i "redhat" >/dev/null
if [[ "$?" -eq 0 ]]; then
  echo -e "[+] RedHat like OS"
  USER_DISTRO="RED_HAT"
fi

# Debian
if [[ -f "/usr/bin/apt" ]]; then
  USER_DISTRO="DEBIAN"
fi
cat /etc/os-release | grep -i "debian" >/dev/null
if [[ "$?" -eq 0 ]]; then
  echo -e "[+] Debian like OS"
  USER_DISTRO="DEBIAN"
fi

# Arch
if [[ -f "/usr/bin/pacman" ]]; then
  USER_DISTRO="Arch"
fi
cat /etc/os-release | grep -i "arch" >/dev/null
if [[ "$?" -eq 0 ]]; then
  echo -e "[+] Arch like OS"
  USER_DISTRO="Arch"
fi

PACKAGES=("git curl zsh wget fzf")

case "$USER_DISTRO" in

DEBIAN)
  echo -e "[+] Check Packages ..."
  for package in ${PACKAGES[@]}; do
    apt show $package 2>/dev/null | grep -i "APT-Manual-Installed: yes" >/dev/null

    if [[ $? -eq "0" ]]; then
      echo -e "[+] $package installed"
    else
      echo -e "[-] $package not installed"
      echo -e "Install it ..."
      sudo apt-get install $package -y 2>/dev/null
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
      echo -e "[-] "$package" not installed\n Install it ..."
      sudo pacman -Syu $package

    fi
  done
  ;;
esac

# Change shell
echo -e "Changing default shell"
chsh -s /usr/bin/zsh

# Install OhMyZsh
cd ~
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh >install.sh && chmod +x install.sh
sh install.sh --unattended

# Install Plug-in
git clone https://github.com/zsh-users/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search

# Moove plug-in into zsh dir
mv zsh* ~/.oh-my-zsh/plugins
clear
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
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b'
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
      echo -e "[+] Theme added to ~/.zshrc"
      echo -e "[+] Theme located in : ~/.oh-my-zsh/themes/chibraax2.zsh-theme"
      break
    else
      echo -e "Bad choice"
      echo -e ""
      continue
    fi
  fi
done

exec zsh -l && source .zshrc
exit 0
