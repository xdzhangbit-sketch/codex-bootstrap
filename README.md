# codex-bootstrap

A portable, Git-managed bootstrap for this Codex setup, generated on
2026-08-16. It contains the non-DingTalk local skills plus an auditable list of
the enabled Codex plugins and connectors.

## Contents

- `skills/`: versioned copies of the five local skills currently installed:
  `codex-ppt`, `frontend-slides`, `handdrawn-tech-illustrations`,
  `image-to-editable-ppt`, and `ppt-master`.
- `manifests/plugins.toml`: the enabled-plugin snapshot, including the observed
  marketplace versions.
- `scripts/install.sh`: safe bootstrap script for a new machine.
- `config/config.template.toml`: an intentionally minimal place for portable
  preferences.

The DingTalk skills are intentionally excluded.

## Restore on a new machine

```bash
git clone <your-remote-url> codex-bootstrap
cd codex-bootstrap
./scripts/install.sh
```

Use `./scripts/install.sh skills` or `./scripts/install.sh plugins` to restore
only one category. The script does not overwrite an existing skill directory;
review, remove, or rename a conflicting local directory first.

## Connector security

Google Calendar and Slack are restored as plugins, not as copied sessions. You
must complete their authorization in Codex on the target machine. OAuth tokens,
browser profiles, credentials, project trust state, and the full local Codex
configuration are deliberately excluded from this repository.

## Versioning policy

The five local skills are vendored so their exact contents are reproducible.
Plugins are installed from configured marketplaces; their observed versions are
recorded in `manifests/plugins.toml`, but the current CLI does not provide an
install-by-version option. After restoring, compare `codex plugin list` with
the manifest and commit any intentional update.

## First commit

```bash
git add .
git commit -m "Bootstrap Codex skills and plugins"
git remote add origin <your-remote-url>
git push -u origin main
```
