eval `ssh-agent -s`

ssh-add ~/work/cred/marcelotpcosta
sleep 1

git add *
sleep 1

git commit -m "some bullshit"
sleep 1

git push
echo "done!"
