#!/bin/bash
echo "OS: Linux"

echo "================ setup_linux_key.sh - start ================"
# PSK_Key=$(sudo openssl rand -hex 16)
PSK_Key="${PSK_KEY_GENERATED_BY_BACKEND}" # This line will be replaced by backend
metaDir="${HOME}/etc/.ansysCSPAgent"
echo "metaDir:"
echo $metaDir
mkdir -p "${metaDir}"

json="{
    \"PSK_Key\": \"${PSK_Key}\"
}"
echo "${json}" > "${metaDir}/original_metadata.json"
echo "================ setup_linux_key.sh - end ================"
