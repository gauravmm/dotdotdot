# CLAUDE.md

**Python** Use `uv`
**Use Classic Terms** whitelist/blacklist, master/slave, dummy data, master branch
**Tools** Use rg not grep, find not fd, tree
**Long-running processes** Launch long-running tasks (servers, workers, watchers) in a hooked zsh shell so `zsh-reap` tracks them, and restart them cooperatively via `zsh-reap restart <id>`. Use `zsh-reap list` to identify long-running jobs (TSV: ID/PID/SHELL/CWD/UPTIME/COMMAND). Other subcommands: `show <id>`, `kill <id>` (SIGTERM, SIGKILL after 5s), `restart <id> [--wait]`, `forget <id>`. Only tracks jobs started from a hooked zsh shell - npx/node children spawned underneath aren't tracked individually. Feel free to restart appropriate jobs (e.g. a dev/serve process to pick up code changes) without asking.
**Node/npx** Available via nvm; `~/.local/bin/{node,npx,npm}` are symlinks to the nvm LTS so they resolve on minimal PATHs (e.g. MCP server spawns, which don't source ~/.zshenv). Re-point these symlinks after an nvm version bump.
**Dependencies** When proposing or adding a new dependency (or a version bump), check the internet for the latest version first - the knowledge cutoff lags real releases. Use the registry (`npm view <pkg> version`, `pip index versions`, etc.) or a web search.
**Website** Site repos live at `~/(work/)?(www|redirects)/` — `www` is the Jekyll site (gauravmanek.com, GitLab, branch `production`), `redirects` is the manek.sg short-link map (`_redirects`, GitHub). A new short link usually means an entry in both.
**Commits** When making large changes to a codebase, feel free to make intermediate commits.
**sudo** No TTY here; plain `sudo` fails. Use `sudo -A <cmd>` - `SUDO_ASKPASS` (in `~/.zshenv`) points at `~/.local/bin/wsl-askpass`, a masked Windows dialog via WSLg interop.
**Subagents + git stash** When ponytail skills are in effect (parallel cleanup agents share one working tree), subagents MUST NOT run `git stash`/`pop`/scoped `checkout` to isolate their own edits - it churns every other agent's concurrent changes. Have them edit in place and let the parent verify the combined tree.
