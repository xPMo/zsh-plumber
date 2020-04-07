fpath+=("${0:h}/functions")
autoload -Uz →plumber-line-finish →plumber-accept →plumber-line-init add-zle-hook-widget


add-zle-hook-widget line-finish →plumber-line-finish
local w
for w in accept{-line,-and-hold,-and-infer-next-history,-line-and-down-history}; do
	zle -N $w →plumber-accept
done

local m
for m in viins vicmd emacs; do
	# ALT+ENTER
	bindkey '^[^M' →plumber-accept-line
	bindkey '^[^J' →plumber-accept-line
done
