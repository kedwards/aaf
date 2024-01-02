#!/usr/bin/env bash

set -e

opts=':eh'

script_name=${0##*/}
script_dir="$( cd "$( dirname "$0" )" && pwd )"
script_path=${script_dir}/${script_name}
script_date=$(date +%Y%m%d)

root_dir=${script_dir}/../
ansible_dir=${root_dir}/ansible
execute=false

usage() {
  echo "Install dependencies"
  echo ""
  echo "$1"
  echo "Usage: ./${script_name} -e"
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
	sudo apt install -y git golang-go python3 python3-pip python3-venv

  # if [ -d ~/.aaf ]; then
	# 	source ~/.aaf/bin/activate
	# else
	# 	python3 -m venv ~/.aaf && source ~/.aaf/bin/activate
	# fi


	if [ $(pyenv virutalenvs | grep aaf) ]; then
    pyenv activate aaf
  else
    pyenv virualenv aaf && pyenv activate aaf
  fi

  pip3 install -r ${root_dir}/requirements.txt
  go install github.com/aws-cloudformation/rain/cmd/rain@latest
  ansible-galaxy collection install --force -r ${ansible_dir}/requirements.yml
else
  usage
fi
