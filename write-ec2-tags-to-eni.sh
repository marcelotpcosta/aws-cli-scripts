#!/bin/bash

# ID da instância EC2
instance_id="i-cba48546"

# Obter o ID da interface de rede associada à instância EC2
network_interface_id=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[0].Instances[0].NetworkInterfaces[0].NetworkInterfaceId" --output text)

# Verificar se a interface de rede foi encontrada
if [ -z "$network_interface_id" ]; then
  echo "Nenhuma interface de rede encontrada para a instância EC2"
  exit 1
fi

# Obter as tags da instância EC2
tags=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" --query 'Tags[].[Key,Value]' --output text)

# Escrever as tags na interface de rede
while IFS=$'\t' read -r key value; do
  aws ec2 create-tags --resources "$network_interface_id" --tags "Key=$key,Value=$value"
done <<< "$tags"

echo "Tags escritas na interface de rede associada à instância EC2"
