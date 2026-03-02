#!/usr/bin/env bash
set -euo pipefail

# Strava Activity Sync Script
# Fetches activities from Strava and updates daily goal trackers
#
# Required environment variables:
#   STRAVA_CLIENT_ID
#   STRAVA_CLIENT_SECRET
#   STRAVA_REFRESH_TOKEN
#
# Usage: ./scripts/sync-strava.sh [--since YYYY-MM-DD]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GOALS_DIR="$REPO_ROOT/goals"

# Default: fetch activities from Jan 1, 2026
SINCE_DATE="${1:-2026-01-01}"
SINCE_TIMESTAMP=$(date -j -f "%Y-%m-%d" "$SINCE_DATE" "+%s" 2>/dev/null || date -d "$SINCE_DATE" "+%s")

echo "🏃 Syncing Strava activities since $SINCE_DATE..."

# Check required environment variables
if [[ -z "${STRAVA_CLIENT_ID:-}" ]] || [[ -z "${STRAVA_CLIENT_SECRET:-}" ]] || [[ -z "${STRAVA_REFRESH_TOKEN:-}" ]]; then
    echo "❌ Error: Missing required environment variables"
    echo "Please set: STRAVA_CLIENT_ID, STRAVA_CLIENT_SECRET, STRAVA_REFRESH_TOKEN"
    echo ""
    echo "You can set them in a .env file or export them:"
    echo "  export STRAVA_CLIENT_ID='your_client_id'"
    echo "  export STRAVA_CLIENT_SECRET='your_client_secret'"
    echo "  export STRAVA_REFRESH_TOKEN='your_refresh_token'"
    exit 1
fi

# Step 1: Get fresh access token
echo "🔑 Refreshing access token..."
TOKEN_RESPONSE=$(curl -s -X POST https://www.strava.com/oauth/token \
    -d client_id="$STRAVA_CLIENT_ID" \
    -d client_secret="$STRAVA_CLIENT_SECRET" \
    -d refresh_token="$STRAVA_REFRESH_TOKEN" \
    -d grant_type=refresh_token)

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')

if [[ "$ACCESS_TOKEN" == "null" ]] || [[ -z "$ACCESS_TOKEN" ]]; then
    echo "❌ Error: Failed to get access token"
    echo "$TOKEN_RESPONSE" | jq .
    exit 1
fi

echo "✅ Access token obtained"

# Step 2: Fetch activities
echo "📊 Fetching activities..."
ACTIVITIES=$(curl -s "https://www.strava.com/api/v3/athlete/activities?after=$SINCE_TIMESTAMP&per_page=200" \
    -H "Authorization: Bearer $ACCESS_TOKEN")

ACTIVITY_COUNT=$(echo "$ACTIVITIES" | jq '. | length')
echo "✅ Found $ACTIVITY_COUNT activities"

if [[ "$ACTIVITY_COUNT" == "0" ]]; then
    echo "No activities to sync."
    exit 0
fi

# Step 3: Update daily trackers
echo "📝 Updating daily trackers..."

echo "$ACTIVITIES" | jq -c '.[]' | while read -r activity; do
    # Parse activity data
    activity_date=$(echo "$activity" | jq -r '.start_date_local' | cut -d'T' -f1)
    activity_type=$(echo "$activity" | jq -r '.type')
    distance_m=$(echo "$activity" | jq -r '.distance')
    distance_km=$(echo "scale=2; $distance_m / 1000" | bc)
    name=$(echo "$activity" | jq -r '.name')

    # Only process Run, Walk, or Hike activities
    if [[ ! "$activity_type" =~ ^(Run|Walk|Hike)$ ]]; then
        continue
    fi

    # Extract date components
    year=$(echo "$activity_date" | cut -d'-' -f1)
    month=$(echo "$activity_date" | cut -d'-' -f2)
    day=$(echo "$activity_date" | cut -d'-' -f3)

    daily_file="$GOALS_DIR/daily/$year/$month/$day.md"

    if [[ ! -f "$daily_file" ]]; then
        echo "⚠️  Skipping $activity_date - daily tracker not found"
        continue
    fi

    # Check if distance is already logged
    current_distance=$(grep "^\*\*Distance:\*\*" "$daily_file" | head -1 || echo "")

    if echo "$current_distance" | grep -q "[0-9]\+\.[0-9]\+ km"; then
        echo "ℹ️  $activity_date already has distance logged: $current_distance"
        # TODO: Could aggregate multiple activities per day
        continue
    fi

    # Update the distance field
    echo "✅ $activity_date: $distance_km km ($activity_type - $name)"

    # Determine activity type label
    type_label=$(echo "$activity_type" | tr '[:upper:]' '[:lower:]')

    # Update distance line
    sed -i.bak "s|^\*\*Distance:\*\* .*|\*\*Distance:\*\* $distance_km km ($type_label)|" "$daily_file"
    rm -f "$daily_file.bak"
done

echo ""
echo "🎉 Strava sync complete!"
echo ""
echo "Next steps:"
echo "1. Review the updated files in goals/daily/"
echo "2. Update running totals in goals/2026-GOALS.md"
echo "3. Commit the changes: git add goals/ && git commit -m 'chore: sync Strava activities'"
