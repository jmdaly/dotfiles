# https://superuser.com/a/586088/184123
function restricted-expand-or-complete() {

	# split into shell words also at "=", if IFS is unset use the default (blank, \t, \n, \0)
	local IFS="${IFS:- \n\t\0}="

	# this word is completed
	local complt

	# if the cursor is following a blank, you are completing in CWD
	# the condition would be much nicer, if it's based on IFS
	if [[ $LBUFFER[-1] = " " || $LBUFFER[-1] = "=" ]]; then
		complt="$PWD"
	else
		# otherwise take the last word of LBUFFER
		complt=${${=LBUFFER}[-1]}
	fi

	# determine the physical path, if $complt is not an option (i.e. beginning with "-")
	[[ $complt[1] = "-" ]] || complt=${complt:A}/

	# activate completion only if the file is on a local filesystem, otherwise produce a beep
	if [[ ! $complt = /shares/* ]]; then
		zle expand-or-complete
	else
		echo -en "\007"
	fi
}

# vim: sw=4 sts=0 ts=4 noet ffs=unix :
