fpath+=("${0:h}/functions")
autoload -Uz →plumber-accept-line →plumber-line-init add-zle-hook-widget


zle -N →plumber-accept-line
add-zle-hook-widget line-finish →plumber-accept-line

local m
for m in viins vicmd emacs; do
	# ALT+ENTER
	bindkey '^[^M' →plumber-accept-line
	bindkey '^[^J' →plumber-accept-line
done
