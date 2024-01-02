#!/usr/bin/env bash

set -e

for filename in cloudformation/*.*; do
    cfn-lint -t ${filename} -i W1020 W2030;
    aws cloudformation validate-template --template-body file://${filename};
done
