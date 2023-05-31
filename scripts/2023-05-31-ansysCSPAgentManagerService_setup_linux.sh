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

if [ ! -d "$OS_SERVICE_MANAGER_APP_DIR" ]; then
  mkdir -p "$OS_SERVICE_MANAGER_APP_DIR"
  echo "Folder created successfully."
else
  echo "Folder already exists."
fi

if [ ! -d "$AGENT_APP_DIR/src" ]; then
  mkdir -p "$AGENT_APP_DIR/src"
  echo "Folder created successfully."
else
  echo "Folder already exists."
fi

OS_SERVICE_MANAGER_APP_BINARY_URL="https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/linux/ansysCSPAgentManagerServiceApp"
OS_SERVICE_MANAGER_APP_INSTALL_SERVICE_URL="https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/linux/install_linux.sh"
OS_SERVICE_MANAGER_APP_UNINSTALL_SERVICE_URL="https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/linux/uninstall_linux.sh"
OS_SERVICE_MANAGER_APP_SERVICE_CONFIG_URL="https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/linux/AnsysCSPAgentManagerService.service"
AGENT_APP_BINARY_URL="https://ansys-gateway-development.s3.eu-west-3.amazonaws.com/linux/ansysCSPAgentApp"

curl -L "$OS_SERVICE_MANAGER_APP_BINARY_URL" -o "$OS_SERVICE_MANAGER_APP"
curl -L "$OS_SERVICE_MANAGER_APP_INSTALL_SERVICE_URL" -o "$OS_SERVICE_MANAGER_APP_DIR/install_linux.sh"
curl -L "$OS_SERVICE_MANAGER_APP_UNINSTALL_SERVICE_URL" -o "$OS_SERVICE_MANAGER_APP_DIR/uninstall_linux.sh"
curl -L "$OS_SERVICE_MANAGER_APP_SERVICE_CONFIG_URL" -o "$OS_SERVICE_MANAGER_APP_DIR/AnsysCSPAgentManagerService.service"
curl -L "$AGENT_APP_BINARY_URL" -o "$AGENT_APP"

# Add +x permission for two binary files
cd $OS_SERVICE_MANAGER_APP_DIR
sudo chmod +x ${OS_SERVICE_MANAGER_APP}
sudo chmod +x ${AGENT_APP}
sudo chmod +x "${OS_SERVICE_MANAGER_APP_DIR}/install_linux.sh"
sudo chmod +x "${OS_SERVICE_MANAGER_APP_DIR}/uninstall_linux.sh"

# Copy ansysCSPAgentApp to OS service manager app folder
sudo sudo cp ${AGENT_APP} ${OS_SERVICE_MANAGER_APP_DIR}

cd $OS_SERVICE_MANAGER_APP_DIR
sudo ./install_linux.sh


echo "=== 2023-05-29-ansysCSPAgentManagerService_setup_linux.sh - end ==="