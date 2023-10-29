#!/bin/sh

arquivo="$1"
while IFS= read -r linha || [[ -n "$linha" ]]; do
  echo "Deleting snapshot: "$linha
  aws ec2 delete-snapshot --snapshot-id "$linha"
done < "$arquivo"