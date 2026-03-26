#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo $0 <username>"
    exit 1
fi

USERNAME="$1"

if id "$USERNAME" &>/dev/null; then
    echo "Error: User '$USERNAME' already exists."
    exit 1
fi

useradd -m -s /bin/bash "$USERNAME"

if [ $? -eq 0 ]; then
    echo "User '$USERNAME' created successfully."
    echo "Set password for '$USERNAME':"
    passwd "$USERNAME"

    USER_HOME=$(eval echo "~$USERNAME")

    mkdir -p "$USER_HOME/.config"
    ln -s /home/foxstone/.config/opencode "$USER_HOME/.config/opencode"
    chown -h "$USERNAME:$USERNAME" "$USER_HOME/.config/opencode"
    chown "$USERNAME:$USERNAME" "$USER_HOME/.config"
    echo "Linked ~/.config/opencode for '$USERNAME'."

    mkdir -p "$USER_HOME/Projects"
    chown "$USERNAME:$USERNAME" "$USER_HOME/Projects"
    echo "Created ~/Projects folder for '$USERNAME'."

    mkdir -p "$USER_HOME/Projects/wtf"
    chown "$USERNAME:$USERNAME" "$USER_HOME/Projects/wtf"
    echo "Created ~/Projects/wtf folder for '$USERNAME'."

    mkdir -p "$USER_HOME/Projects/wtf/docs"
    chown "$USERNAME:$USERNAME" "$USER_HOME/Projects/wtf/docs"
    echo "Created ~/Projects/wtf/docs folder for '$USERNAME'."

    ln -s /shared/foxstone/ "$USER_HOME/Projects/wtf/foxstone"
    chown -h "$USERNAME:$USERNAME" "$USER_HOME/Projects/wtf/foxstone"
    echo "Linked /shared/foxstone for '$USERNAME'."

    echo "Installing nvm and Node.js for '$USERNAME'..."
    su - "$USERNAME" -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'
    su - "$USERNAME" -c 'source ~/.nvm/nvm.sh && nvm install 22.22.0'
    echo "Node.js setup complete for '$USERNAME'."

    echo "Installing openchamber for '$USERNAME'..."
    su - "$USERNAME" -c 'source ~/.nvm/nvm.sh && curl -fsSL https://raw.githubusercontent.com/btriapitsyn/openchamber/main/scripts/install.sh | bash'
    echo "openchamber setup complete for '$USERNAME'."
else
    echo "Error: Failed to create user '$USERNAME'."
    exit 1
fi
