#!/usr/bin/env bash

# shows where an AWS security group is being used:
# * lists all network interfaces it is attached to it
# * lists all other security groups referencing it in inbound rules
# usage: aws.sg my-security-group-name
# requires aws-cli and jq.

group_name=$1
group_id=`aws ec2 describe-security-groups --filters "Name=group-name,Values=$group_name" | \
            jq --raw-output '.SecurityGroups[0].GroupId'`

printf '* Network interfaces using this group:\n'
aws ec2 describe-network-interfaces --filter "Name=group-name,Values=$group_name" | \
    jq --raw-output '.NetworkInterfaces[] | [if .Attachment.InstanceId
                                               then .Attachment.InstanceId
                                               else .Attachment.InstanceOwnerId
                                             end,
                                             .PrivateIpAddress,
                                             .PrivateDnsName,
                                             .Description]
                                          | @tsv'

printf "\n"
printf "* Other security groups referencing this group:\n"
aws ec2 describe-security-groups --filters Name=ip-permission.group-id,Values=$group_id | \
    jq --raw-output '.SecurityGroups[] | [.GroupId, .GroupName, .Description] | @tsv'
