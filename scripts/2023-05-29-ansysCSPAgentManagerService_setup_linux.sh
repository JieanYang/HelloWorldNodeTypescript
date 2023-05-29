#!/bin/bash
echo "OS: Linux"

echo "=== 2023-05-29-ansysCSPAgentManagerService_setup_linux.sh - start ==="

# === Amazon Linux - start ===
echo "=== Amazon Linux - start ==="
# Update pacakges
sudo yum update -y

# Install git
sudo yum install git -y
git --version

# Install go
sudo yum install golang -y
go version
echo "=== Amazon Linux - end ==="
# === Amazon Linux - end ===

# === Ubuntu 20.04 LST - start ===
echo "=== Ubuntu 20.04 LST - start ==="
sudo apt update

sudo apt install git -y
git --version


sudo apt remove golang* -y
sudo wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz

/usr/local/go/bin/go version
echo "=== Ubuntu 20.04 LST - end ==="
# === Ubuntu 20.04 LST - start ===

# === Set path - start ===
echo "=== Set path - start ==="
echo $PATH
export GOPATH=/usr/local/go
export PATH=$PATH:$GOPATH/bin
echo $PATH
go version
echo "=== Set path - end ==="
# === Set path - end ===

# === App path - start ===
OS_SERVICE_MANAGER_APP_DIR_NAME="ansysCSPAgentManagerService"
AGENT_APP_DIR_NAME="ansysCSPAgent"

OS_SERVICE_MANAGER_APP_DIR="$GOPATH/$OS_SERVICE_MANAGER_APP_DIR_NAME"
AGENT_APP_DIR="$OS_SERVICE_MANAGER_APP_DIR/$AGENT_APP_DIR_NAME"
echo $OS_SERVICE_MANAGER_APP_DIR
echo $AGENT_APP_DIR

OS_SERVICE_MANAGER_APP_NAME="ansysCSPAgentManagerServiceApp"
AGENT_APP_NAME="ansysCSPAgentApp"

OS_SERVICE_MANAGER_APP="${OS_SERVICE_MANAGER_APP_DIR}/$OS_SERVICE_MANAGER_APP_NAME"
AGENT_APP="${AGENT_APP_DIR}/src/$AGENT_APP_NAME"
echo $ $OS_SERVICE_MANAGER_APP
echo $ $AGENT_APP
# === App path - end ===

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
  sudo git clone --branch dev-ansys https://github.com/JieanYang/HelloWorldGoOsService.git $OS_SERVICE_MANAGER_APP_DIR
  cd $OS_SERVICE_MANAGER_APP_DIR
  sudo git submodule update --init --recursive
  echo "Clone github repository-end"
fi

# Build OS service manager app
cd $OS_SERVICE_MANAGER_APP_DIR
echo "Build OS service manager app"
if [ -f "$OS_SERVICE_MANAGER_APP" ]; then
    rm $OS_SERVICE_MANAGER_APP
fi
sudo /usr/local/go/bin/go build -o ${OS_SERVICE_MANAGER_APP} "${OS_SERVICE_MANAGER_APP_DIR}/main.go"

# Build ansysCSPAgentApp
echo "Build ansysCSPAgentApp"
if [ -f "$AGENT_APP" ]; then
    rm $AGENT_APP
fi
cd $AGENT_APP_DIR
sudo /usr/local/go/bin/go build -o ${AGENT_APP} "${AGENT_APP_DIR}/src/main.go"

# Add +x permission for two binary files
cd $OS_SERVICE_MANAGER_APP_DIR
sudo chmod +x ${OS_SERVICE_MANAGER_APP}
sudo chmod +x ${AGENT_APP}

# Copy ansysCSPAgentApp to OS service manager app folder
sudo sudo cp ${AGENT_APP} ${OS_SERVICE_MANAGER_APP_DIR}

cd $OS_SERVICE_MANAGER_APP_DIR
./install_linux.sh


echo "=== 2023-05-29-ansysCSPAgentManagerService_setup_linux.sh - end ==="