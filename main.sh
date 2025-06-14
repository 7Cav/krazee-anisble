#!/usr/bin/env bash

# Check if inventory is specified in arguments
has_inventory=false
for arg in "$@"; do
    if [[ "$arg" == "-i" || "$arg" == "--inventory" ]]; then
        has_inventory=true
    fi
done

args=("main.yml" "--vault-password-file" "vault-password.txt")
if ! $has_inventory; then
    args+=("--inventory" "inventory.yml")
fi
for arg in "$@"; do
    args+=("$arg")
done

ansible-playbook "${args[@]}"
