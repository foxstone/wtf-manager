#!/bin/bash

 cd /shared/
opencode run "/generate-legacy-api-artifacts" &
opencode run "/generate-ng-frontend-artifacts" &
opencode run "/generate-platform-api-artifacts" &

echo "Done."