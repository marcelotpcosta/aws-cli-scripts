List where an AWS security group is being used
# usage: aws-sg.sh security-group-name (NAME, not ID)
# shows where an specific AWS Security Group is being used
# requires aws-cli and jq
# + lists network interfaces where provided Security Group is attached to
# + lists other security groups where Security Group is referenced
