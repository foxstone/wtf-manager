#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo $0 <username>"
    exit 1
fi

USERNAME="$1"

if ! id "$USERNAME" &>/dev/null; then
    echo "Error: User '$USERNAME' does not exist."
    exit 1
fi

userdel -r "$USERNAME"

if [ $? -eq 0 ]; then
    echo "User '$USERNAME' deleted successfully."
else
    echo "Error: Failed to delete user '$USERNAME'."
    exit 1
fi
