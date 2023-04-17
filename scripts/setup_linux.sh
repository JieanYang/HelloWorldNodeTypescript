#!/bin/bash

# echo "start"
# echo "hello yang"
# echo "end"
# echo "2022-12-30-third_script" >> "third_script_output.txt"

# Update pacakges
sudo yum update -y

# Install git
sudo yum install git -y
git version

# Install go
sudo yum install golang -y
go version

# Pull github
cd /
DIR_SUPERVISORD_RESEARCH=/supervisord-research
DIR_SUPERVISOID_RESEARCH_HELLOWORLD_GO_AGENT=/supervisord-research/helloWorldGoAgent

if [ -d "$DIR_SUPERVISORD_RESEARCH" ]; then
  ### Take action if $DIR_SUPERVISORD_RESEARCH exists ###
  # echo "Installing config files in ${DIR_SUPERVISORD_RESEARCH}..."
  cd $DIR_SUPERVISORD_RESEARCH
  git add .
  git reset --h HEAD
  git pull
else
  ###  Control will jump here if $DIR_SUPERVISORD_RESEARCH does NOT exists ###
  # echo "Error: ${DIR_SUPERVISORD_RESEARCH} not found. Can not continue."
  # exit 1
  echo "Clone github repository-start"
  sudo git clone --branch dev-helloWorldGoAgent https://github.com/JieanYang/supervisord-research.git $DIR_SUPERVISORD_RESEARCH
  cd $DIR_SUPERVISORD_RESEARCH
  sudo git submodule update --init --recursive
  echo "Clone github repository-end"
fi

# Build supervisord
FILE="${DIR_SUPERVISORD_RESEARCH}/supervisord"
if [ -f "$FILE" ]; then
    rm $FILE
fi
sudo go build

# Build helloWorldGoAgent
echo "Build helloWorldGoAgent"
FILE="${DIR_SUPERVISORD_RESEARCH}/helloWorldGoAgent/src/helloWorldGoAgent"
if [ -f "$FILE" ]; then
    rm $FILE
fi
cd $DIR_SUPERVISOID_RESEARCH_HELLOWORLD_GO_AGENT
sudo go build -o "${DIR_SUPERVISOID_RESEARCH_HELLOWORLD_GO_AGENT}/src/helloWorldGoAgent" "${DIR_SUPERVISOID_RESEARCH_HELLOWORLD_GO_AGENT}/src/main.go"
# cd $DIR_SUPERVISORD_RESEARCH
sudo chmod +x "${DIR_SUPERVISOID_RESEARCH_HELLOWORLD_GO_AGENT}/src/helloWorldGoAgent"

# Copy binary app
FILE=/usr/local/bin/helloWorldGoAgent
if [ -f "$FILE" ]; then
    sudo rm $FILE
fi
sudo cp "${DIR_SUPERVISOID_RESEARCH_HELLOWORLD_GO_AGENT}/src/helloWorldGoAgent" /usr/local/bin/helloWorldGoAgent

DIR_SUPERVISORD_LOG=/supervisord
sudo mkdir $DIR_SUPERVISORD_LOG

# Start service
# ./supervisord -c supervisord-linux.conf -d

# Register service as daemon
sudo "${DIR_SUPERVISORD_RESEARCH}/supervisord" service install -c "${DIR_SUPERVISORD_RESEARCH}/supervisord-linux.conf"
sudo "${DIR_SUPERVISORD_RESEARCH}/supervisord" service start