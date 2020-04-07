#!/usr/bin/env zsh

fpath+=(${0:a:h:h}/functions)
autoload -Uz →plumber-accept-line split-shell-arguments
integer failed=0

add-zle-hook-widget(){ : }

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

never_plumb=(
	'basic cmd'
	'basic | pipeline'
	'quoted \|'
)

always_plumb=(
	'ends with |'  'ends with >| :file: &'
	'pipe|space| ' 'pipe|space>| :file: &'
	'escaped \\|'  'escaped \\>| :file: &'
)

ic_plumb=(
	'ends | #foo' 'ends >| :file: & #foo'
	'a | # b |'   'a >| :file: & # b |'
)
ic_noplumb=(
	'ends #foo |'
	'a | b # |'
)
noic_plumb=(
	'ends #foo |' 'ends #foo >| :file: &'
	'a | # b |'   'a | # b >| :file: &'
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
