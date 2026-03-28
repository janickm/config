# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

if [ -f $HOME/.bashrc_private ] ; then
  # We seem to be at work
  . $HOME/.bashrc_private
fi

# Put your fun stuff here

# explicit bash completion
[[ -f /etc/profile.d/bash_completion.sh ]] && source /etc/profile.d/bash_completion.sh
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh
[[ -f /usr/share/bash-completion/completions/git ]] && source /usr/share/bash-completion/completions/git

# git prompt
if [ -f $HOME/.local/pkg/bash-git-prompt/gitprompt.sh ]; then
  # working with 48eff2e of https://github.com/magicmonty/bash-git-prompt.git
  export  __GIT_PROMPT_DIR=$HOME/.local/pkg/bash-git-prompt
  source $__GIT_PROMPT_DIR/gitprompt.sh

  White="\[\033[00m\]"
  BBlue="\[\033[01;34m\]"
  BWhite="\e[1;37m"
  BCyan='\e[1;36m'

  GIT_PROMPT_PREFIX="${BBlue}["
  GIT_PROMPT_SUFFIX="${BBlue}]"
  GIT_PROMPT_SEPARATOR="${BBlue}|"
  GIT_PROMPT_BRANCH="${Magenta}"
  GIT_PROMPT_STAGED="${Red}● "
  GIT_PROMPT_CONFLICTS="${Red}✖ "
  GIT_PROMPT_CHANGED="${Yellow}✚ "
  GIT_PROMPT_REMOTE="${BWhite} "
  GIT_PROMPT_UNTRACKED="${BCyan}…"
  GIT_PROMPT_CLEAN="${BGreen}✔"

  scm_svn() {
    local s
    s=$(svn info 2>/dev/null)
    if [ $? -eq 0 ]; then
      s=$(echo -n "${s}" | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )
      s=" ${BBlue}[${Magenta}svn:${s}${BBlue}]"
    else
      s=""
    fi
    echo -n "$s"
  }

  function eval_prompt() {
    export PROMPT_START="$BGreen\u@\h$BBlue \w$ResetColor$(scm_svn)"
    export PROMPT_END=" $BBlue\$ $White"
    setGitPrompt
  }

  PROMPT_COMMAND=eval_prompt
elif [ -f /usr/share/bash-completion/completions/git-prompt ]; then
  source /usr/share/bash-completion/completions/git-prompt
  complete -o default -o nospace -F _git config

  ##SVN+GIT

  scm_ps1() {
    local s
    s=$(svn info 2>/dev/null)
    if [ $? -eq 0 ]; then
      s=svn:$(echo -n "${s}" | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )
      s="(${s}) "
    else
      s=$(__git_ps1 "(git:%s) ")
    fi
    echo -n "$s"
  }

  #export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]"
  # = martinez@phoenix ~/ProjVC/vclibs $

  #export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
  # = [martinez@phoenix vclibs (master=)]$

  #export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w $(__git_ps1 " (%s)")\$ \[\033[00m\]'
  # = martinez@phoenix ~/ProjVC/isomdef  (master=)$

  export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w $(scm_ps1)\$ \[\033[00m\]'
  # = ph03@janick ~/ProjVC/isomdef (git:master=) $

  #export PS1='\[\e[32;1m\](\[\e[01;32m\]\u@\h\[\e[32;1m\])-(\[\e[37;1m\]!\!\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[01;34m\]\w\[\e[32;1m\])\n\[\e[01;34m\]$(scm_ps1) \$ \[\e[0m\]'
  #export PS1="\n\[\e[32;1m\](\[\e[01;32m\]\u@\h\[\e[32;1m\])-(\[\e[37;1m\]!\!\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[32;1m\])\n(\[\e[01;34m\]\w\[\e[32;1m\])\[\e[01;34m\] \$(scm_ps1)\$ \[\e[0m\]"
  #export PS1="\n\[\e[32;1m\](\[\e[01;32m\]\u@\h\[\e[32;1m\])-(\[\e[37;1m\]!\!\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[32;1m\])\n\[\e[01;34m\]\w \$(scm_ps1)\$ \[\e[0m\]"
  # =
  # (ph03@janick)-(jobs:0)-(~/ProjVC/athene)
  # (! 553) (git:master=) $

  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="git verbose"

  export GIT_SSL_NO_VERIFY=1
  ##
else
  export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
fi

#export LC_TIME="de_DE.utf8"

#export CGAL_MAKEFILE="/usr/local/share/cgal/cgal.mk"

export PATH="$HOME/.local/bin:/usr/lib64/ccache/bin:/usr/lib/colorgcc/bin:$PATH"

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib64:/usr/local/lib:$HOME/.local/lib64:$HOME/.local/lib"

#export LIBXCB_ALLOW_SLOPPY_LOCK=1

export MAPLE="/opt/maple"

if [ -f /usr/libexec/mc/mc.sh ]; then
   . /usr/libexec/mc/mc.sh
fi

export PROJROOT="$HOME/ProjMPI"
export PROJVC="$HOME/ProjVC"

export RI="--format ansi --width 70"

#export PYTHONSTARTUP="$HOME/.pythonrc"
#export PYTHONPATH="/usr/local/lib64/python2.5/site-packages"

#MCGL
export PATH="$HOME/ProjMPI/MCGL/impexp:$PATH"
#export MATLABPATH="$HOME/ProjMPI/MCGL:$MATLABPATH"
#export MATLABPATH="$HOME/ProjMPI/Matlab/base"
#export MATLABPATH="$HOME/ProjMPI/SG08:$MATLABPATH"

#export MATLABPATH="$HOME/ProjVC/vc-mp09-public/matlab:$MATLABPATH"

#Matlab
export MATLABPATH="$HOME/.local/pkg/plot2svg:$MATLABPATH"
export MATLABPATH="$HOME/ProjVC/jmlibs/util/matlab:$MATLABPATH"
export MATLABPATH="$HOME/ProjVC/jmlibs/util/matlab/loadmesh:$MATLABPATH"
export MATLABPATH="$HOME/ProjVC/jmlibs/util/matlab/png2mesh:$MATLABPATH"
export MATLABPATH="$HOME/ProjVC/jmlibs/util/matlab/ui:$MATLABPATH"
export MATLABPATH="$HOME/ProjVC/jmlibs/util/matlab/export_fig:$MATLABPATH"

#Mosek
export MATLABPATH="$HOME/.local/pkg/mosek/7/toolbox/r2009b:$MATLABPATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/pkg/mosek/7/tools/platform/linux64x86/bin"
export MOSEKLM_LICENSE_FILE="$HOME/.local/pkg/mosek/7/license/mosek.lic"

#Jacket
#export MATLABPATH="$HOME/local/pkg/jacket/engine:$MATLABPATH"
#export LD_LIBRARY_PATH="$HOME/local/pkg/jacket/engine/lib64:$LD_LIBRARY_PATH"

#export VTK_DATA_ROOT="$HOME/local/pkg/VTKData"

#CULA
#export CULA_ROOT="$HOME/local/pkg/cula"
#export CULA_INC_PATH="$CULA_ROOT/include"
#export CULA_BIN_PATH_32="$CULA_ROOT/bin"
#export CULA_BIN_PATH_64="$CULA_ROOT/bin64"
#export CULA_LIB_PATH_32="$CULA_ROOT/lib"
#export CULA_LIB_PATH_64="$CULA_ROOT/lib64"
#export LD_LIBRARY_PATH="$CULA_LIB_PATH_64:$LD_LIBRARY_PATH"

#bashcomp
#source /etc/profile.d/bash-completion.sh

#NVSG
#export NVSGSDKHOME="/usr/local/nvsg-sdk"

#VTKLibs
export VTKLIBS="-L/usr/lib64 -lvtkCommon -lvtkDICOMParser -lvtkFiltering -lvtkGenericFiltering -lvtkGraphics -lvtkHybrid -lvtkIO -lvtkImaging -lvtkNetCDF -lvtkRendering -lvtkVolumeRendering -lvtkWidgets"
export VTKCFLAGS="-I/usr/include/vtk-5.4"

#Static CUDPPD
#export CUDPPDLIB="$HOME/workspace/cuda/cudpp/lib/libcudpp64.a"
#export CUDPPDLIBEMU="$HOME/workspace/cuda/cudpp/lib/libcudpp64_emu.a"

#meshlab
export PATH="$HOME/.local/pkg/meshlab_svn/meshlab/src/distrib:$PATH"

#VL
export VL_VERBOSITY_LEVEL="NORMAL"
export VL_ROOT="/opt/VL/VC"

#tetgen
export PATH="$HOME/local/pkg/tetgen1.4.3:$PATH"

#poclbm
export PATH="$HOME/local/pkg/poclbm:$PATH"

#if [[ -f "${HOME}/.gentoo/java-env-classpath" ]]; then
#  source ${HOME}/.gentoo/java-env-classpath
#fi

export MKL_THREADING_LAYER=GNU

#enable vi mode
#set -o vi

#gibo (github gitignore boilerplate)
export PATH="$HOME/.local/pkg/gitignore-boilerplates:$PATH"

if [ -f $HOME/.local/pkg/gitignore-boilerplates/gibo-completion.bash ]; then
  source $HOME/.local/pkg/gitignore-boilerplates/gibo-completion.bash
fi

alias config='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'

#status string for ninja build tool
export NINJA_STATUS="[%r/%u/%f/%t] "

#powerline-bash
export POWERLINE="$HOME/.local/pkg/powerline-bash/powerline-bash.py"
function _update_ps1()
{
  if [ $COLORTERM ]; then
    if [ -f ${POWERLINE} ]; then
      export PS1="$(${POWERLINE} $?)"
    fi
  fi
}

#export PROMPT_COMMAND="_update_ps1"
#export TERM="xterm-256color"

# syntax highlighting of less using dev-util/source-highlight
if [[ -f "/usr/bin/src-hilite-lesspipe.sh" ]]; then
  export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi
export LESS=' -R '

# maya home
export MAYA_APP_DIR="$HOME/.config/maya"

# gem path
if which ruby >/dev/null 2>&1 && which gem >/dev/null 2>&1; then
  export PATH="$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# bd https://github.com/vigneshwaranr/bd
if [[ -f "$HOME/.local/bin/bd" ]]; then
  alias bd=". bd -s"
fi

# go path
export GOPATH="$HOME/.local/go"
export PATH="$GOPATH/bin:$PATH"

# rust path
if [ -f $HOME/.cargo/env ] ; then
  . $HOME/.cargo/env
fi

# ocaml path
export PATH="$HOME/.opam/system/bin:$PATH"
export http_proxy=''
export https_proxy=''
export ftp_proxy=''
export socks_proxy=''
