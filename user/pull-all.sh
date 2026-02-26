#!/bin/bash

PATHS=(
    "/shared/foxstone/ng-frontend"
    "/shared/foxstone/platform-api"
    "/shared/foxstone/legacy-api"
)

for path in "${PATHS[@]}"; do
    if [ -d "$path/.git" ]; then
        echo "Pulling $path..."
        git -C "$path" pull
    else
        echo "Skipping $path (not a git repository)"
    fi
done

echo "Done."
