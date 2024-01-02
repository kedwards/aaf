#!/bin/bash

prefix="${1}"

if [ -z "${prefix}" ] ; then
	echo "Please provide a prefix"
	exit 1
fi

aws ssm delete-parameters --name $(aws ssm describe-parameters --query "Parameters[?contains(Name, '${prefix}')].Name" --output text)
