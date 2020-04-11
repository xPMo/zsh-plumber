fpath+=("${0:h}/functions")
autoload -Uz →plumber-line-finish →plumber-accept →plumber-line-init →plumber-relay \
	add-zle-hook-widget split-shell-arguments
zmodload zsh/zselect

add-zle-hook-widget line-finish →plumber-line-finish
zle -N →plumber-accept

local m=
for m (-finish -test '')
	zle -N →plumber-line-init{$m,}

for m in viins vicmd visual emacs; do
	# ALT+ENTER
	bindkey -M $m '^[^M' →plumber-accept
	bindkey -M $m '^[^J' →plumber-accept
done
