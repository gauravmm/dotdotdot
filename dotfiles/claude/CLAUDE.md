# CLAUDE.md

**Python** Use `uv`
**Use Classic Terms** whitelist/blacklist, master/slave, dummy data, master branch
**Tools** Use rg not grep, find not fd, tree
**Long-running processes** Launch long-running tasks (servers, workers, watchers) in a hooked zsh shell so `zsh-reap list` tracks them (TSV: ID/PID/SHELL/CWD/UPTIME/COMMAND), and restart them cooperatively via `zsh-reap restart <id>`. Also `show <id>`, `kill <id>` (SIGTERM, SIGKILL after 5s), `restart <id> [--wait]`, `forget <id>`. npx/node children spawned underneath aren't tracked individually. Feel free to restart appropriate jobs without asking.
**Node/npx** Available via nvm; `~/.local/bin/{node,npx,npm}` are symlinks to the nvm LTS. Re-point these symlinks after an nvm version bump.
**Dependencies** When proposing, adding, updating a new dependency check the internet for the latest version first - the knowledge cutoff lags real releases. Use the registry (`npm view <pkg> version`, `pip index versions`, etc.) or a web search.
**Website** Site repos live at `~/(work/)?(www|redirects)/` — `www` is the Jekyll site (gauravmanek.com, GitLab, branch `production`), `redirects` is the manek.sg short-link map (`_redirects`, GitHub). A new short link usually means an entry in both.
**Commits** When making large changes to a codebase, feel free to make intermediate commits.
**sudo** No TTY here; plain `sudo` fails. Use `sudo -A <cmd>` to use `wsl-askpass`.
**Subagents + git stash** When parallel cleanup agents share one working tree, subagents MUST NOT run `git stash`/`pop`/scoped `checkout` which churns every other agent's concurrent changes. Have them edit in place and let the parent verify the combined tree.
