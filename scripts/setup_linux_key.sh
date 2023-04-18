#!/bin/bash

echo "================ setup_linux_key.sh - start ================"
key=$(sudo openssl rand -hex 16)
key_dir="${HOME}/.HelloWorldGoAgent"
mkdir -p "${key_dir}"
echo "${key}" > "${key_dir}/PSK_key.txt"
echo "================ setup_linux_key.sh - end ================"
