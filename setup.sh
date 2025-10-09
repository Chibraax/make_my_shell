#!/bin/bash

# Check OS

# Red HAT

if [[ -d "/etc/dnf" ]] && [[ -f "/usr/bin/dnf" ]]; then
        USER_DISTRO="RED_HAT"
fi

cat /etc/os-release | grep -i "redhat" > /dev/null;

if [[ "$?" -eq 0 ]];then
	USER_DISTRO="RED_HAT";
fi

# Debian

if [[ -d "/etc/apt" ]] && [[ -f "/usr/bin/apt" ]]; then
        USER_DISTRO="Debian"
fi

cat /etc/os-release | grep -i "debian" > /dev/null;

if [[ "$?" -eq 0 ]];then
	USER_DISTRO="Debian";
fi

# Arch

if [[ -f "/usr/bin/pacman" ]]; then
        USER_DISTRO="Arch"
fi

cat /etc/os-release | grep -i "arch" > /dev/null;

if [[ "$?" -eq 0 ]];then
        USER_DISTRO="Arch";
fi

case "$USER_DISTRO" in

RED_HAT)
	echo "Distro Based on RED_HAT";


        #Verif git
        rpm --query git > /dev/null;

        if [[ "$?" -eq 0 ]]
        then
                echo "Git installed"
        else
                echo "Git not installed"
                sudo dnf install git -y
        fi


        #Verif ZSH
        rpm --query zsh > /dev/null;

        if [[ "$?" -eq 0 ]]
        then
                echo "Zsh installed"
        else
                echo "Zsh not installed"
                sudo dnf install zsh -y
        fi

        #Verif Curl
        rpm --query curl > /dev/null ;

        if [[ "$?" -eq 0 ]]
        then
                echo "Curl installed"
        else
                echo "Curl not installed"
                sudo dnf install curl -y
        fi

;;
Debian)
	echo "Distro Based on Debian";
 
        #Verif git
        apt show git 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Git installed"
        else
                echo "Git not installed"
                sudo apt install git -y
        fi


        #Verif ZSH
        apt show zsh 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Zsh installed"
        else
                echo "Zsh not installed"
                sudo apt install zsh -y
        fi

        #Verif Curl
        apt show curl 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Curl installed"
        else
                echo "Curl not installed"
                sudo apt install curl -y
        fi

        #Verif wget
        apt show wget 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Wget installed"
        else
                echo "Wget not installed"
                sudo apt install wget -y
        fi


;;
Arch)
	echo "Distro Based on Arch";

        # Verif git
        pacman -Q git > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Git installed"
        else
                echo "Git not installed"
                sudo pacman -Syu git ;
        fi

        # Verif ZSH
        pacman -Q zsh > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Zsh installed"
        else
                echo "Zsh not installed"
                sudo pacman -Syu zsh;
        fi

        #Verif Curl
        pacman -Q curl > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Curl installed"
        else
                echo "Curl not installed"
                sudo pacman -Syu zsh;
        fi
	
esac


# Change shell
echo "Changing default shell"
chsh -s /usr/bin/zsh ;

# Install OhMyZsh
cd  ~;
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh && chmod +x install.sh
sh install.sh --unattended

# Install Plug-in
git clone https://github.com/zsh-users/zsh-syntax-highlighting ;
git clone https://github.com/zsh-users/zsh-completions ;
git clone https://github.com/zsh-users/zsh-autosuggestions ;
git clone https://github.com/zsh-users/zsh-history-substring-search

# Moove plug-in into zsh dir
mv zsh* ~/.oh-my-zsh/plugins;
# Second directory
cat <<EOF >> ~/.oh-my-zsh/themes/chibraax2.zsh-theme
# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}🎃​%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}🩸​🩸%b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}🩸​🩸%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
RPROMPT='[%*]'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
EOF


# Copy personnal theme into dir
cat <<EOF >> ~/.oh-my-zsh/themes/chibraax.zsh-theme
# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}💀%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}⚡⚡%b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}⚡⚡%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b '
RPROMPT='[%*]'
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
EOF


# Write plug-in into .zshrc and change theme
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf)/g" .zshrc ;
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="chibraax"/g' .zshrc ;

# Config .zshrc
rm install.sh

exec zsh -l && source .zshrc
exit 0;
