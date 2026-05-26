# ~/.zshenv is sourced for every zsh invocation, including non-interactive
# subshells. Keep this minimal and idempotent.

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
