function _exists() {
	local bin=${1}
	local -r _not_found_pattern="not found$"
    # ZSH only
	# if [[ "$(which "${1}" 2> /dev/null)" =~ ${_not_found_pattern} ]]; then
    which "${1}" 2>&1 > /dev/null
	if [[ 0 != "$?" ]]; then
		echo "0"
	else
		echo "1"
	fi
}

# Helpful arm-ldd function
if [[ "1" == "$(which patchelf)" ]]; then
	function arm-ldd() { patchelf --print-needed $1 }
else
	function arm-ldd() { readelf -d $1 | grep "\(NEEDED\)" | sed -r "s/.*\[(.*)\]/\1/" }
fi
