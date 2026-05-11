# AGENTS.md

## Ops-Only Rule (Strict)
For any change or operational action related to SuperCmd or Linearmouse, use scripts under `ops/` only.

## SuperCmd Commands
- Register or replace LaunchAgent: `./ops/supercmd/register_launchagent.sh`
- Remove LaunchAgent: `./ops/supercmd/remove_launchagent.sh`

## Linearmouse Commands
- Register config symlink flow: `./ops/linearmouse/register_config_symlink.sh`
- Remove config symlink flow: `./ops/linearmouse/remove_config_symlink.sh`

## Shared Command
- Ensure executable bits: `./ops/set_executable_permissions.sh`

## Do Not
- Do not run ad-hoc `launchctl`, `ln -s`, `rm`, or `chmod` commands for these flows.
- Do not manually edit `~/Library/LaunchAgents` or `~/.config/linearmouse` for routine operations.

## If a Script Is Missing or Outdated
1. Add or update the script in `ops/` first.
2. Execute the operation through that script.

## Note
If your `bash` command is not usable in the current shell, run scripts with `/bin/bash <script-path>`.
