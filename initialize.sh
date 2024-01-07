#!/usr/bin/env bash

set -e

opts=':eh'

script_name=${0##*/}
script_dir="$( cd "$( dirname "$0" )" && pwd )"
script_path=${script_dir}/${script_name}
script_date=$(date +%Y%m%d)
ansible_dir=${script_dir}/ansible
execute=false

usage() {
	echo "AAF intitializer"
	echo ""
	echo "$1"
	echo "Usage: ${script_name} -e"
	echo "options:"
	echo "  -e | execute script"
	echo "  -h | print this help menu"
	exit 1
}

while getopts ${opts} opt
do
	case "$opt" in
		e)  execute=true
			;;
		h)  usage
			;;
		\?)
			usage "Error: invalid parameter ${OPTARG}"
			;;
	esac
done
shift $(($OPTIND - 1))

if [ ${execute} = "true" ] ; then
	sudo apt install -y git python3 python3-pip python3-venv
	pip3 install -r ${script_dir}/requirements.txt
	go install github.com/aws-cloudformation/rain/cmd/rain@latest
	ansible-galaxy collection install --force -r ${ansible_dir}/requirements.yml
else
	usage
fi
