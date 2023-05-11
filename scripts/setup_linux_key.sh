#!/bin/bash
echo "OS: Linux"

echo "================ setup_linux_key.sh - start ================"
# key=$(sudo openssl rand -hex 16)
key="${PSK_KEY_GENERATED_BY_BACKEND}" # This line will be replaced by backend
key_dir="${HOME}/.HelloWorldGoAgent"
echo "key_dir:"
echo $key_dir
mkdir -p "${key_dir}"

json="{
    \"key\": \"${key}\"
}"
echo "${json}" > "${key_dir}/original_metadata.json"
echo "================ setup_linux_key.sh - end ================"
