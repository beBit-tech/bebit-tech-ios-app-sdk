# bebit-tech-ios-app-sdk
## Local release and test app update

Log in once with `gh auth login`. The account must be able to run workflows in both this repository and `beBit-tech/test-ios-app`.

From this repository's root, run:

```bash
bash scripts/trigger-release.sh <version> <checksum> <xcframework_url> [release_notes]
```

The local script starts the release workflow on `main`, waits up to 20 minutes for the exact version's published XCFramework asset, then runs the test app update workflow using your local GitHub CLI credentials. Keep the terminal and computer running until the notification is accepted. CocoaPods publication is separate; the test app uses SPM.

For an already-published release, a release made through GitHub's website, or an interrupted local session, run:

```bash
bash scripts/notify-test-app.sh 1.1.0-beta.1
```

This command only checks publication and requests the test app update; it does not republish the SDK. Repeated requests reuse the receiver's existing PR or do nothing if that version is already selected. A successful dispatch means the request was accepted; check the receiving workflow for PR creation and validation results.

The SDK repository no longer sends cross-repository notifications from Actions, so `WORKFLOW_TRIGGER_TOKEN` is unused. The test app still requires its existing `SDK_UPDATE_TOKEN` to create the branch/PR and start PR validation. Releases made outside this local script require the separate notification command above.

Validation: `python3 -m unittest discover -s scripts -p 'test_*.py'`.
