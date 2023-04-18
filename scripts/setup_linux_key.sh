#!/bin/bash

key=$(openssl rand -hex 16)
key_dir="${HOME}/.HelloWorldGoAgent"
mkdir -p "${key_dir}"
echo "${key}" > "${key_dir}/key.txt"
