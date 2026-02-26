#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_CONF="$SCRIPT_DIR/users.conf"

while IFS=':' read -r username port password; do
    username=$(echo "$username" | xargs)
    port=$(echo "$port" | xargs)
    password=$(echo "$password" | xargs)
    
    [[ -z "$username" || -z "$port" ]] && continue
    
    node_path="/home/$username/.nvm/versions/node/v22.22.0/bin"
    cmd="sudo -u $username env PATH=\"$node_path:\$PATH\" $node_path/openchamber --daemon --port $port"
    
    if [[ -n "$password" ]]; then
        cmd="$cmd --ui-password $password"
    fi
    
    echo "Starting openchamber for $username on port $port..."
    eval "$cmd"
done < "$USERS_CONF"
