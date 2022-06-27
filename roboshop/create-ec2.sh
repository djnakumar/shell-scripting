#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-Devops-Practice" | jq '.image[].imageid' | sed -e 's/"//g')

echo $AMI_ID
