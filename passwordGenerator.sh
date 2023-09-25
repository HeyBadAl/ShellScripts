#!/bin/bash 

# password length  
printf "\n"
read -p "How many characters you wold like the password to have? " pass_length 
printf "\n"

for i in {1..10}; do (tr -cd '[:alnum:]' < /dev/urandom | fold -w${pass_length} | head -n 1); done 

# print the string 
# printf "$pas"
