#!/bin/bash

# Obter a lista de instâncias EC2
instances=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text)

# Verificar se há instâncias EC2
if [ -z "$instances" ]; then
  echo "Nenhuma instância EC2 encontrada"
  exit 1
fi

# Iterar sobre cada instância EC2
for instance_id in $instances; do
  # Obter os IDs dos volumes associados à instância EC2
  volume_ids=$(aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=$instance_id" --query 'Volumes[].VolumeId' --output text)

  # Verificar se há volumes associados à instância EC2
  if [ -z "$volume_ids" ]; then
    echo "Nenhum volume associado à instância EC2 ($instance_id)"
    continue
  fi

  # Obter as tags da instância EC2
  tags=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" --query 'Tags[].[Key,Value]' --output text)

  # Escrever as tags nos volumes associados à instância EC2
  while IFS=$'\t' read -r key value; do
    for volume_id in $volume_ids; do
      aws ec2 create-tags --resources "$volume_id" --tags "Key=$key,Value=$value"
    done
  done <<< "$tags"

  echo "Tags escritas nos volumes associados à instância EC2 ($instance_id)"
done
