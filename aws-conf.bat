@ECHO off
ECHO [%date%, %time%] A configurar o AWS
aws configure set aws_access_key_id []
aws configure set aws_secret_access_key []]
ECHO [%date%, %time%] A definir a regiao predefinida
aws configure set default.region []
ECHO [%date%, %time%] A definir o formato
aws configure set  output json
ECHO Done!
pause