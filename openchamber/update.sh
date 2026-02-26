#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_CONF="$SCRIPT_DIR/users.conf"

"$SCRIPT_DIR/stop.sh"

while IFS=':' read -r username port password; do
    username=$(echo "$username" | xargs)
    
    [[ -z "$username" ]] && continue
    
    node_path="/home/$username/.nvm/versions/node/v22.22.0/bin"
    
    echo "Updating openchamber for $username..."
    sudo -u "$username" env PATH="$node_path:$PATH" "$node_path/openchamber" update
done < "$USERS_CONF"

"$SCRIPT_DIR/start.sh"
