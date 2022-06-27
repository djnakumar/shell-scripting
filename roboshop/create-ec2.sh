#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=centos-7-Devops-practice" | jq '.imageid' | sed -e 's/"//g')

echo $AMI_ID
aws ec2 run-instance --image-id ${AMI_ID} --instance-type t2.micro
