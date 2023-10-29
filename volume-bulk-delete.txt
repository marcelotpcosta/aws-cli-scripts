#!/bin/sh

arquivo="$1"
while IFS= read -r linha || [[ -n "$linha" ]]; do
  echo "Deleting volume: "$linha
  aws ec2 delete-volume --volume-id "$linha"
done < "$arquivo"