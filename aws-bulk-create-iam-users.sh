#!/bin/bash

# Author: Marcelo Costa

# Replace 'Admins' with the actual group name in IAM
GROUP_NAME="Admins"

# Read the usernames from usernames.txt and create IAM users
while IFS= read -r username
do
    # Create the IAM user
    aws iam create-user --user-name "$username"

    # Generate IAM access key and secret key for the user and save it to a file
    aws iam create-access-key --user-name "$username" > "$username"_credentials.json

    # Add the user to the 'Admins' group
    aws iam add-user-to-group --group-name "$GROUP_NAME" --user-name "$username"

    # (Optional) If you want to generate a password for each user, uncomment the following line
    # aws iam create-login-profile --user-name "$username" --password "$RANDOM_PASSWORD" --password-reset-required

    echo "Created user: $username and added to $GROUP_NAME group"
done < usernames.txt
