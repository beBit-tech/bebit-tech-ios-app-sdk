"""Exercise the local shell entrypoint without publishing or contacting GitHub."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).with_name('notify-test-app.sh')
FAKE_GH = '''#!/usr/bin/env python3
import json, os, pathlib, sys
args = sys.argv[1:]
p = pathlib.Path(os.environ['CALLS'])
with p.open('a') as f: f.write(json.dumps(args) + '\\n')
mode = os.environ['MODE']
if args[:2] == ['auth', 'status']:
    sys.exit(1 if mode == 'unauthenticated' else 0)
if args[:2] == ['release', 'view']:
    queries = sum(json.loads(line)[:2] == ['release', 'view'] for line in p.read_text().splitlines())
    if mode == 'api-error': sys.exit(1)
    print('false' if mode == 'unready' or (mode == 'delayed' and queries == 1) else 'true')
    sys.exit(0)
if args[:2] == ['workflow', 'run']:
    sys.exit(1 if mode == 'dispatch-error' else 0)
sys.exit(99)
'''


class NotifyTests(unittest.TestCase):
    def run_script(self, mode, version='1.1.0-beta.1'):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            gh = root / 'gh'
            gh.write_text(FAKE_GH)
            gh.chmod(0o755)
            calls = root / 'calls'
            env = dict(os.environ, PATH=folder + os.pathsep + os.environ['PATH'],
                       MODE=mode, CALLS=str(calls), SDK_RELEASE_ATTEMPTS='2',
                       SDK_RELEASE_INTERVAL_SECONDS='0')
            result = subprocess.run(['bash', str(SCRIPT), version], env=env,
                                    capture_output=True, text=True)
            commands = [json.loads(line) for line in calls.read_text().splitlines()] if calls.exists() else []
            return result, commands

    def test_waits_for_binary_then_dispatches_exact_version(self):
        result, commands = self.run_script('delayed')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(sum(c[:2] == ['release', 'view'] for c in commands), 2)
        self.assertEqual(commands[-1], ['workflow', 'run', 'app-update.yml', '--repo',
                         'beBit-tech/test-ios-app', '--ref', 'main', '-f', 'version=1.1.0-beta.1'])

    def test_never_dispatches_without_ready_binary_or_auth(self):
        for mode in ['unready', 'api-error', 'unauthenticated']:
            with self.subTest(mode=mode):
                result, commands = self.run_script(mode)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(any(c[:2] == ['workflow', 'run'] for c in commands))

    def test_dispatch_failure_returns_failure_and_retry_command(self):
        result, _ = self.run_script('dispatch-error')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Retry: bash scripts/notify-test-app.sh 1.1.0-beta.1', result.stderr)

    def test_invalid_version_cannot_reach_github(self):
        result, commands = self.run_script('ready', '1.1.0; echo unexpected')
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(commands, [])
