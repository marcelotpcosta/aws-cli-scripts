#!/bin/sh

# Author Marcelo Costa

arquivo="$1"
while IFS= read -r linha || [[ -n "$linha" ]]; do
  echo "Deregistering AMI: "$linha
  aws ec2 deregister-image --image-id "$linha"
done < "$arquivo"