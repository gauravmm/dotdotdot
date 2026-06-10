# ~/.zshenv is sourced for every zsh invocation, including non-interactive
# subshells. Keep this minimal and idempotent.

# Ensure PATH/path stay deduplicated in every shell, including the
# non-interactive subshells that never source .zshrc.
typeset -gU path PATH

# addpath: append $1 to $path if it's an existing directory. Defined here (not
# .zshrc) so non-interactive subshells (Claude Code, opencode, codex) can use it
# too, and so .zshrc's addpath calls resolve against this single definition.
addpath() {
	if [[ -d "$1" ]]; then
		path+=("$1")
		return 0
	fi
	return 1
}

# Local bin path. Oh-my-posh and the native Claude Code install live here, so we
# ensure it exists and is on PATH for every shell, interactive or not.
mkdir -p "${HOME}/.local/bin"
addpath "$HOME/.local/bin"

# AI coding tool detection. Done here (not .zshrc) because Claude Code, opencode,
# and codex spawn non-interactive subshells where .zshrc is skipped.
if [[ -n "$OPENCODE" || -n "$CLAUDECODE" || -n "$CODEX" ]]; then
	export IN_AI_CODING_TOOL=1

	# Eagerly load nvm so node/npm/npx are available in AI subshells without
	# requiring `source ~/.nvm/nvm.sh`. Interactive sessions still get the lazy
	# loader via zgenom in .zshrc (this branch is a no-op there because nvm.sh
	# is idempotent).
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
fi
