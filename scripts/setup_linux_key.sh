#!/bin/bash

echo "================ setup_linux_key.sh - start ================"
key=$(sudo openssl rand -hex 16)
key_dir="${HOME}/.HelloWorldGoAgent"
echo "key_dir:"
echo $key_dir
mkdir -p "${key_dir}"

json="{
    \"key\": \"${key}\"
}"
echo "${json}" > "${key_dir}/original_metadata.json"
echo "================ setup_linux_key.sh - end ================"


echo "================ send key to backend test - start ================"
curl -X POST -H "Content-Type: application/json" -d "{\"key\":\"${key}\"}" https://ee5c-2a01-cb08-ad0-f700-e00b-d224-dbfe-bb45.ngrok-free.app/node/api-docs/#/Agent/post_agent_receivePSKKey

echo "================ send key to backend test - end ================"