#!/usr/bin/env bash

#	flac2mp3.sh
#	Author: William Woodruff
#	------------------------
#	Converts flac files into mp3s in bulk.
#	Requires ffmpeg or avconv and GNU bash 4.0.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: $(basename ${0}) [-sdvh] [directory]\n"
	printf "\t-s - convert files sequentially instead of spawning processes\n"
	printf "\t-d - delete flac files after conversion\n"
	printf "\t-v - be verbose\n"
	printf "\t-h - print this usage information\n"
	exit 1
}

function verbose() {
	if [[ "${verbose}" ]]; then
		printf "${@}\n"
	fi
}

function error() {
	>&2 printf "Fatal: ${@}. Exiting.\n"
	exit 2
}

function flac2mp3() {
	local flac_file="${1}"
	local mp3_file="${flac_file%.flac}.mp3"

	local flac_base=$(basename "${flac_file}")
	local mp3_base=$(basename "${mp3_file}")

	verbose "Beginning '${flac_base}' -> '${mp3_base}'."
	"${conv}" -y -i "${flac_file}" -b:a 320k "${mp3_file}" &> /dev/null 
	verbose "Completed '${mp3_base}'."
}

[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && error "GNU bash 4.0 or later is required"

shopt -s nullglob
shopt -s globstar

if which ffmpeg > /dev/null; then
	conv=ffmpeg
elif which avconv > /dev/null; then
	conv=avconv
else
	error "Could not find either ffmpeg or avconv to convert with"
fi

while getopts ":sdv" opt; do
	case "${opt}" in
		s ) sequential=1 ;;
		d ) delete=1 ;;
		v ) verbose=1 ;;
		* )	usage ;;
	esac
done

shift $((OPTIND - 1))

if [[ -n "${1}" ]]; then
	dir="${1}"
	[[ ! -d "${dir}" ]] && error "Not a directory: '${dir}'"
else
	dir="."
fi

flacs=("${dir}"/**/*.flac)

if [[ "${sequential}" ]]; then
	verbose "Converting sequentially."

	for file in "${flacs[@]}"; do
		flac2mp3 "${file}"
	done
else
	verbose "Converting in parallel."

	for file in "${flacs[@]}"; do
		flac2mp3 "${file}" &
	done

	wait
fi

if [[ "${delete}" ]]; then
	verbose "Deleting old FLACs..."
	rm -rf "${flacs[@]}"
	verbose "done."
fi

verbose "All done. ${#flacs[@]} files converted."
