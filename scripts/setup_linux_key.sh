#!/bin/bash

echo "================ setup_linux_key.sh - start ================"
key=$(sudo openssl rand -hex 16)
key_dir="${HOME}/.HelloWorldGoAgent"
echo "key_dir:"
echo $key_dir
mkdir -p "${key_dir}"

json = "{
    \"key\": \"${key}\"
}"
echo "${json}" > "${key_dir}/origin_metadata.json"
echo "================ setup_linux_key.sh - end ================"
