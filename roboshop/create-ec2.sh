#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=centos-7-Devops-practice" | jq '.image[].imageid' | sed -e 's/"//g')

echo $AMI_ID
