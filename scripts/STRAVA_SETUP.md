# Strava Sync Setup Guide

This guide helps you set up the Strava API integration to automatically sync your running/walking activities to your daily goal trackers.

## Prerequisites

Install required tools (if not already installed):

```bash
brew install jq  # JSON parsing
```

## Step 1: Get Strava API Credentials

You already have these from your `gilacost/gilacost` repo! You need:

1. **STRAVA_CLIENT_ID** - Your Strava API application client ID
2. **STRAVA_CLIENT_SECRET** - Your Strava API application secret
3. **STRAVA_REFRESH_TOKEN** - OAuth refresh token for your account

### Where to find them:

- Client ID & Secret: https://www.strava.com/settings/api
- Refresh token: Check your GitHub secrets in the gilacost/gilacost repository

## Step 2: Set Environment Variables

Create a `.env` file in the repo root (it's already gitignored):

```bash
# /Users/pepo/Repos/dot-files/.env
export STRAVA_CLIENT_ID="your_client_id_here"
export STRAVA_CLIENT_SECRET="your_client_secret_here"
export STRAVA_REFRESH_TOKEN="your_refresh_token_here"
```

Then source it:

```bash
source .env
```

## Step 3: Run the Sync Script

Sync all activities since Jan 1, 2026:

```bash
./scripts/sync-strava.sh
```

Or specify a custom start date:

```bash
./scripts/sync-strava.sh 2026-01-15
```

## What It Does

1. Gets a fresh access token using your refresh token
2. Fetches all Run/Walk/Hike activities from Strava since the specified date
3. Updates your daily tracker files in `goals/daily/YYYY/MM/DD.md`
4. Only updates days that don't already have distance logged
5. Shows you what was updated

## After Running

1. Review the updated files: `git diff goals/`
2. Manually update the running totals in `goals/2026-GOALS.md`
3. Commit the changes

## Troubleshooting

**"Missing required environment variables"**
- Make sure you've set all three variables and sourced the .env file

**"Failed to get access token"**
- Check that your refresh token is still valid
- You may need to re-authorize the Strava app

**"Daily tracker not found"**
- The script only updates existing daily tracker files
- Create missing days first using `./goals/new-day`

## Next Steps

Once you're happy with local testing, we can set this up to run automatically in GitHub Actions.
