#!/bin/bash

TEAMS_WEBHOOK_URL="https://foxstone.webhook.office.com/webhookb2/6b14cfed-0c10-4b70-af88-de2bf5eff68b@334a7381-3b25-421e-a19d-dc5550560e58/IncomingWebhook/f43da76e9f874772ae9d4ff79bb6008f/197bce44-a13e-4f8a-ba26-de5632bfcd28/V21tYt5TfeWB__Qd9kcLm5BqeDPFpgJJ7F-S2RikawiUE1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd /shared/foxstone/

REPORT=$(/home/foxstone/.nvm/versions/node/v22.22.0/bin/node "$SCRIPT_DIR/generate-artifacts-report.js")

echo 'Copied artifacts.'

if [ -n "$TEAMS_WEBHOOK_URL" ]; then
    PAYLOAD=$(jq -n \
        --arg report "$REPORT" \
        '{
            "@type": "MessageCard",
            "@context": "http://schema.org/extensions",
            "themeColor": "0076D7",
            "summary": "Artifacts Sync Complete",
            "sections": [{
                "activityTitle": "Artifacts Sync Complete",
                "activitySubtitle": "wtf-manager",
                "facts": [{
                    "name": "Status",
                    "value": "Success"
                }],
                "markdown": true
            }],
            "text": ("### Artifacts Report:\n```\n" + $report + "\n```")
        }')
    
    curl -s -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$TEAMS_WEBHOOK_URL" > /dev/null
fi

sleep 3

rsync -av artifacts-temp/ codebase-knowledge/

rm -rf artifacts-temp/legacy-api/*
rm -rf artifacts-temp/ng-frontend/*
rm -rf artifacts-temp/platform-api/*