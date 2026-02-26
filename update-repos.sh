#!/bin/bash
 
PATHS=(
    "/shared/foxstone/ng-frontend"
    "/shared/foxstone/platform-api"
    "/shared/foxstone/legacy-api"
    "/shared/what-the-fox"
)
 
for path in "${PATHS[@]}"; do
    if [ -d "$path/.git" ]; then
        echo "Pulling $path..."
        git -C "$path" pull
    else
        echo "Skipping $path (not a git repository)"
    fi
done
 
echo "Copying skills, agents, commands, AGENTS.md..."
cp -r /shared/what-the-fox/.claude/skills/* /home/foxstone/.config/opencode/skills/
rsync -r --delete /shared/what-the-fox/.claude/agents/ /home/foxstone/.config/opencode/agents/
rsync -r --delete /shared/what-the-fox/.claude/commands/ /home/foxstone/.config/opencode/commands/
cp /shared/what-the-fox/CLAUDE.md /home/foxstone/.config/opencode/AGENTS.md

echo "Done."