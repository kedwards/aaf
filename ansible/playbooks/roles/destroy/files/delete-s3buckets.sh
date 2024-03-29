#!/usr/bin/bash

prefix=${1}

if [ -z "${prefix}" ]; then
	echo "Usage: ${0} <prefix>"
	exit 1
fi

for bucket in $(aws s3api list-buckets --query "Buckets[?starts_with(Name, '${prefix}')].Name" --output text) ; do
	isVersioned=$(aws s3api get-bucket-versioning --bucket $bucket --query "Status" --output text)
	# read -r key ver <<< $(aws s3api list-object-versions --bucket tetris-cf-aaf-wtf-us-west-2 --query "DeleteMarkers[*].[Key,VersionId]" --output text)
	# delete all delete markers
  if [[ "$isVersioned" == *"Enabled"* ]]; then
		aws s3api delete-objects \
			--bucket ${bucket} \
			--delete "$(aws s3api list-object-versions \
			--bucket ${bucket} \
			--output=json \
			--query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"

		# delete all versions
		aws s3api delete-objects \
		  --bucket ${bucket} \
			--delete "$(aws s3api list-object-versions \
			--bucket "${bucket}" \
			--output=json \
			--query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"
		aws s3api delete-bucket --bucket ${bucket}
	else
		aws s3 rm s3://mybucket --recursive
		aws s3 rb s3://${bucket}
	fi
done
