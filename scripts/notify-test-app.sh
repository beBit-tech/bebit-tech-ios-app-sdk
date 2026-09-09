#!/usr/bin/env bash
# Run locally with an authenticated gh account; does not publish a release.
set -euo pipefail
version=${1:-}
if [ "$#" -ne 1 ] || [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$ ]]; then
  echo "Usage: bash scripts/notify-test-app.sh <version>" >&2
  exit 1
fi
gh auth status >/dev/null 2>&1 || { echo 'Run gh auth login first.' >&2; exit 1; }
# Wait for the exact tag and uploaded binary, not merely for release creation.
# Overrides allow a shorter wait when diagnosing/retrying publication.
attempts=${SDK_RELEASE_ATTEMPTS:-120}
interval=${SDK_RELEASE_INTERVAL_SECONDS:-10}
[[ "$attempts" =~ ^[1-9][0-9]*$ && "$interval" =~ ^[0-9]+$ ]] || {
  echo 'Invalid release wait settings.' >&2; exit 1;
}
for ((attempt=1; attempt<=attempts; attempt++)); do
  if ready=$(gh release view "$version" --repo beBit-tech/bebit-tech-ios-app-sdk \
      --json isDraft,assets \
      --jq '(.isDraft == false) and any(.assets[]; .name == "OmniSegmentKit.xcframework.zip" and .size > 0 and .state == "uploaded")') && [ "$ready" = true ]; then
    if gh workflow run app-update.yml --repo beBit-tech/test-ios-app --ref main -f "version=$version"; then
      echo "Test app update requested for $version. Check its workflow and PR:"
      echo 'https://github.com/beBit-tech/test-ios-app/actions/workflows/app-update.yml'
      exit 0
    fi
    echo "SDK is published, but notification failed. Retry: bash scripts/notify-test-app.sh $version" >&2
    exit 1
  fi
  if [ "$attempt" -lt "$attempts" ]; then sleep "$interval"; fi
done
echo "SDK $version has no ready release binary, or GitHub could not be reached. No update was requested." >&2
echo "Check the SDK release workflow; after publication retry: bash scripts/notify-test-app.sh $version" >&2
exit 1
