#!/usr/bin/env bash

# shows where an specific AWS SG is being used
# requires aws-cli and jq
# + lists network interfaces where this SG is attached to
# + lists other security groups referencing it in inbound rules
# usage: aws.sg my-security-group-name (NAME, not ID)

sg_name=$1
group_id=`aws ec2 describe-security-groups --filters "Name=group-name,Values=$sg_name" | \
            jq --raw-output '.SecurityGroups[0].GroupId'`

printf '* Network interfaces where this SG is attached to:\n'
aws ec2 describe-network-interfaces --filter "Name=group-name,Values=$sg_name" | \
    jq --raw-output '.NetworkInterfaces[] |
    [if .Attachment.InstanceId
    then .Attachment.InstanceId
    else .Attachment.InstanceOwnerId
    end,
    .PrivateIpAddress,
    .PrivateDnsName,
    .Description]
    | @tsv'

printf "\n"
printf "* SGs where this SG is referenced:\n"
aws ec2 describe-security-groups --filters Name=ip-permission.group-id,Values=$group_id | \
    jq --raw-output '.SecurityGroups[] | [.GroupId, .GroupName, .Description] | @tsv'
