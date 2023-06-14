#!/bin/bash
echo "OS: Linux"

AGENT_APP_DIR_NAME="ansysCSPAgent"

echo "================ 2023-05-29-ansysCSPAgentManagerService_setup_linux_key.sh - start ================"
# PSK_Key=$(sudo openssl rand -hex 16)
PSK_Key="${PSK_KEY_GENERATED_BY_BACKEND}" # This line will be replaced by backend
metaDir="${HOME}/etc/.${AGENT_APP_DIR_NAME}"
echo "metaDir:"
echo $metaDir
mkdir -p "${metaDir}"

json="{
    \"clientId\": "1",
    \"cloudProvider\": "AWS",
    \"region\": "eu-west-3",
    \"nodeType\": "t2.micro",
    \"createdAt\": "2023-02-16T11:22:35.040Z",
    \"psk_key\": \"${PSK_Key}\"
}"
echo "${json}" > "${metaDir}/original_metadata.json"
echo "================ 2023-05-29-ansysCSPAgentManagerService_setup_linux_key.sh - end ================"
