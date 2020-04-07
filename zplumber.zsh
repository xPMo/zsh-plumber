fpath+=("${0:h}/functions")
autoload -Uz →plumber-accept-line →plumber-line-init add-zle-hook-widget

zle -N accept-line →plumber-accept-line
zle -N →plumber-line-init
