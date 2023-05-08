#!/bin/bash
echo "OS: Linux"

echo "=== HelloWorldGoOsService_setup_linux.sh - start ==="

# Update pacakges
sudo yum update -y

# Install git
sudo yum install git -y
git version

# Install go
sudo yum install golang -y
go version

# Set path 
echo $PATH
export GOPATH=/usr/local/go
export PATH=$PATH:$GOPATH/bin
echo $PATH

OS_SERVICE_MANAGER_APP_DIR="$GOPATH/agentOsService"
AGENT_APP_DIR="$OS_SERVICE_MANAGER_APP_DIR/helloWorldGoAgent"
echo $OS_SERVICE_MANAGER_APP_DIR
echo $AGENT_APP_DIR

# Pull github
if [ -d "$OS_SERVICE_MANAGER_APP_DIR" ]; then
  echo "Folder exists and pull from github in ${OS_SERVICE_MANAGER_APP_DIR}"
  cd $OS_SERVICE_MANAGER_APP_DIR
  git add .
  git reset --h HEAD
  git pull
else
  ###  Control will jump here if $OS_SERVICE_MANAGER_APP_DIR does NOT exists ###
  # echo "Error: ${OS_SERVICE_MANAGER_APP_DIR} not found. Can not continue."
  # exit 1
  echo "Clone github repository-start"
  sudo git clone --branch master https://github.com/JieanYang/HelloWorldGoOsService.git $OS_SERVICE_MANAGER_APP_DIR
  cd $OS_SERVICE_MANAGER_APP_DIR
  sudo git submodule update --init --recursive
  echo "Clone github repository-end"
fi

# Build OS service manager app
cd $OS_SERVICE_MANAGER_APP_DIR
echo "Build OS service manager app - HelloWorldGoOsService"
OS_SERVICE_MANAGER_APP="${OS_SERVICE_MANAGER_APP_DIR}/HelloWorldGoOsService"
if [ -f "$OS_SERVICE_MANAGER_APP" ]; then
    rm $OS_SERVICE_MANAGER_APP
fi
sudo go build -o ${OS_SERVICE_MANAGER_APP} "${OS_SERVICE_MANAGER_APP_DIR}/main.go"

# Build helloWorldGoAgent
echo "Build helloWorldGoAgent"
AGENT_APP="${AGENT_APP_DIR}/../helloWorldGoAgent"
if [ -f "$AGENT_APP" ]; then
    rm $AGENT_APP
fi
cd $AGENT_APP_DIR
sudo go build -o ${AGENT_APP} "${AGENT_APP_DIR}/src/main.go"

# Add +x permission for two binary files
cd $OS_SERVICE_MANAGER_APP_DIR
sudo chmod +x ${OS_SERVICE_MANAGER_APP}
sudo chmod +x ${AGENT_APP}

cd $OS_SERVICE_MANAGER_APP_DIR
./install_linux.sh