#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_CONF="$SCRIPT_DIR/users.conf"

while IFS=':' read -r username port password; do
    username=$(echo "$username" | xargs)
    
    [[ -z "$username" ]] && continue
    
    node_path="/home/$username/.nvm/versions/node/v22.22.0/bin"
    
    echo "Stopping openchamber for $username..."
    sudo -u "$username" env PATH="$node_path:$PATH" "$node_path/openchamber" stop
done < "$USERS_CONF"

sudo pkill 'openchamber'
sudo pkill 'opencode'

ps aux | grep open
