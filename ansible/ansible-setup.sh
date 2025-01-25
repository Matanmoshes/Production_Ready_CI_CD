#!/bin/bash

sudo apt update

sudo apt install -y software-properties-common

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install -y ansible

ansible --version

sudo apt install git

git clone https://github.com/Matanmoshes/Production_Ready_CI_CD.git