#!/bin/bash

snapshot_id="snap-0588101e5553b6cac"

# Obtém informações sobre o snapshot
snapshot_info=$(aws ec2 describe-snapshots --snapshot-ids $snapshot_id)

# Extrai o ID do volume de origem do snapshot
volume_id=$(echo $snapshot_info | grep -oP '(?<="VolumeId": ")[^"]*')

# Obtém informações sobre o volume de origem
volume_info=$(aws ec2 describe-volumes --volume-ids $volume_id)

# Extrai o nome do volume de origem
volume_name=$(echo $volume_info | grep -oP '(?<="Name": ")[^"]*')

# Exibe as informações do volume de origem
echo "Volume de origem do snapshot $snapshot_id:"
echo "ID do volume: $volume_id"
echo "Nome do volume: $volume_name"
