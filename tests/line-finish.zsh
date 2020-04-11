#!/usr/bin/env zsh

fpath+=(${0:a:h:h}/functions)
autoload -Uz →plumber-line-finish split-shell-arguments
integer failed=0

add-zle-hook-widget(){ hook=$1 }

mktemp(){ echo :file: }

:test(){
	if [[ $1 != $2 ]]; then
		printf '%10s: %s\n' >&2 'Test failed' "$test" " Expected" "${(q+)1}" " Got" "${(q+)2}" 
		print
		((failed++))
	fi
}

run_test(){
	local $vars
	→plumber-accept-line
}

zle(){
	:test .accept-line $1
	:test $out $BUFFER
}

vars=(
	PLUMBER_LASTOUTPUT
)

relay='> >(→plumber-relay) &'

never_plumb=(
	'basic cmd'
	'basic | pipeline'
	'quoted \|'
)

always_plumb=(
	'ends with |'  "ends with $relay"
	'pipe|space| ' "pipe|space$relay"
	'escaped \\|'  "escaped \\$relay"
)

ic_plumb=(
	'ends | #foo' "ends $relay #foo"
	'a | # b |'   "a $relay # b |"
)
ic_noplumb=(
	'ends #foo |'
	'a | b # |'
)
noic_plumb=(
	'ends #foo |' "ends #foo $relay"
	'a | # b |'   "a | # b $relay"
)
noic_noplumb=(
	'ends | #foo'
)

setopt interactive_comments
for BUFFER ($never_plumb $ic_noplumb){
	test="(ic) ${(q+)BUFFER}"
	out=$BUFFER
	run_test
}
for BUFFER out ($always_plumb $ic_plumb){
	test="(ic) ${(q+)BUFFER}"
	run_test
}

setopt no_interactive_comments
for BUFFER ($never_plumb $noic_noplumb){
	test="(noic) ${(q+)BUFFER}"
	out=$BUFFER
	run_test
}
for BUFFER out ($always_plumb $noic_plumb){
	test="(noic) ${(q+)BUFFER}"
	run_test
}

return $failed
