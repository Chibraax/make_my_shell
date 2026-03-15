# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: https://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;31m%}%n%{\e[1;34m%}🎃%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%}🩸🩸%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%}🩸🩸%{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%{\e[0;33m%}%B$(git_prompt_info)%{\e[1;34m%}%B[%{\e[0;31m%}$%{\e[1;34m%}]%{\e[0m%}%b '
RPROMPT='[%*]'

PS2=$'%{\e[0;34m%}%B>%{\e[0m%}%b '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}] %{$fg[yellow]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}]"
