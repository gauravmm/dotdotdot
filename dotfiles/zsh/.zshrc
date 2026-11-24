HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
autoload -Uz compinit
compinit
setopt appendhistory extendedglob
setopt INTERACTIVE_COMMENTS
unsetopt autocd beep nomatch
bindkey -e
# Make PATH visible as the array path
typeset -gU path PATH

# Language setting
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

#
# AI coding tool detection happens in ~/.zshenv so it's also active in
# non-interactive subshells spawned by Claude Code / opencode / codex.
# IN_AI_CODING_TOOL is set there if any of those env vars are present.
#

#
# Additional key bindings
#

# ctrl-left/right
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

# ctrl-backspace/delete
bindkey "\C-_" backward-kill-word
bindkey "\e[3;5~" kill-word

# alt-backspace
bindkey "\e\d" undo

bindkey "\e[3~" delete-char
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

#
# Environment Variables & Config
#

# addpath is defined in ~/.zshenv so every shell — including the non-interactive
# subshells spawned by Claude Code, opencode, and codex — shares one definition.
# ~/.local/bin is added there too, for the same reason.

addpath "/opt/zerobrew/bin"

# General aliases
alias ls='ls --color'
alias ll='ls -al'
alias clear='echo -ne "\e[0;$[LINES]r"'

# Default Editor
export EDITOR='nano'

# Lazy-load nvm via zgenom in interactive non-AI shells. AI shells get the
# eager load from ~/.zshenv instead (zgenom is skipped for them below).
if [[ -z "$IN_AI_CODING_TOOL" ]]; then
	export NVM_LAZY_LOAD=true

	#
	# dotdotdot updater
	#
	if [[ -x ~/.dotdotdot/update ]]; then
		(~/.dotdotdot/update)
	fi

	#
	# ZSH (skip in AI tools for faster startup)
	#
	source "${HOME}/.zgenom/zgenom.zsh"
	zgenom autoupdate

	# ZSH interaction tools options:
	znt_list_bold=1
	znt_list_colorpair="default/default"
	znt_list_border=1
	znt_list_instant_select=1

	# if the init scipt doesn't exist
	if ! zgenom saved; then
		echo "Generating new zgenom file."

		zgenom ohmyzsh plugins/git
		zgenom ohmyzsh plugins/command-not-found
		zgenom load ptavares/zsh-direnv
		zgenom load lukechilds/zsh-nvm
		zgenom load zdharma-continuum/fast-syntax-highlighting
		zgenom load zsh-users/zsh-autocomplete
		zgenom load z-shell/zsh-navigation-tools
		zgenom load gauravmm/zsh-reap
		# generate the init script from plugins above
		zgenom save

		# Weekly update tasks:
		oh-my-posh upgrade

		if [[ -x "${HOME}/.dotdotdot/update" ]]; then
			(
				cd ${HOME}/.dotdotdot
				./update
			)
		fi
	fi

	# Case-insensitive completion (only in interactive shells)
	zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
	autoload -Uz compinit && compinit

	if which oh-my-posh &>/dev/null; then
		eval "$(oh-my-posh init zsh --config ${HOME}/.gauravmm.omp.yaml)"
	else
		echo "Error: oh-my-posh is not loaded."
	fi
fi

# Support SSH_AUTH_SOCK updating in tmux. On macOS, launchd manages the agent
# and sets SSH_AUTH_SOCK for us, so skip the symlink rewriting there.
if [[ "$OSTYPE" != darwin* ]]; then
	if [[ -S "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
		ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock.$HOST
	fi
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.$HOST
fi

#
# Software
#

if [[ -d "/usr/lib/nvidia" ]]; then
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/nvidia"
fi

addpath "$HOME/.dotdotdot"
addpath "/snap/bin"
addpath "$HOME/.opencode/bin"
addpath "/home/gauravmm/.nvm/versions/node/v24.18.0/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
if [[ -d "$BUN_INSTALL" ]]; then
	[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
	addpath "$BUN_INSTALL/bin"
fi

# opencode
addpath "$HOME/.opencode/bin"

# cat with syntax highlighting
if which batcat &>/dev/null; then
	alias bat="batcat"
fi

#
# Shortcuts
#

# Set LS_COLORS to brighten bold colors, for compatiblity with Kitty
if which kitty &>/dev/null; then
	export LS_COLORS='rs=0:di=01;94:ln=01;96:mh=00:pi=40;33:so=01;95:do=01;95:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;92:*.tar=01;91:*.tgz=01;91:*.arc=01;91:*.arj=01;91:*.taz=01;91:*.lha=01;91:*.lz4=01;91:*.lzh=01;91:*.lzma=01;91:*.tlz=01;91:*.txz=01;91:*.tzo=01;91:*.t7z=01;91:*.zip=01;91:*.z=01;91:*.dz=01;91:*.gz=01;91:*.lrz=01;91:*.lz=01;91:*.lzo=01;91:*.xz=01;91:*.zst=01;91:*.tzst=01;91:*.bz2=01;91:*.bz=01;91:*.tbz=01;91:*.tbz2=01;91:*.tz=01;91:*.deb=01;91:*.rpm=01;91:*.jar=01;91:*.war=01;91:*.ear=01;91:*.sar=01;91:*.rar=01;91:*.alz=01;91:*.ace=01;91:*.zoo=01;91:*.cpio=01;91:*.7z=01;91:*.rz=01;91:*.cab=01;91:*.wim=01;91:*.swm=01;91:*.dwm=01;91:*.esd=01;91:*.jpg=01;95:*.jpeg=01;95:*.mjpg=01;95:*.mjpeg=01;95:*.gif=01;95:*.bmp=01;95:*.pbm=01;95:*.pgm=01;95:*.ppm=01;95:*.tga=01;95:*.xbm=01;95:*.xpm=01;95:*.tif=01;95:*.tiff=01;95:*.png=01;95:*.svg=01;95:*.svgz=01;95:*.mng=01;95:*.pcx=01;95:*.mov=01;95:*.mpg=01;95:*.mpeg=01;95:*.m2v=01;95:*.mkv=01;95:*.webm=01;95:*.ogm=01;95:*.mp4=01;95:*.m4v=01;95:*.mp4v=01;95:*.vob=01;95:*.qt=01;95:*.nuv=01;95:*.wmv=01;95:*.asf=01;95:*.rm=01;95:*.rmvb=01;95:*.flc=01;95:*.avi=01;95:*.fli=01;95:*.flv=01;95:*.gl=01;95:*.dl=01;95:*.xcf=01;95:*.xwd=01;95:*.yuv=01;95:*.cgm=01;95:*.emf=01;95:*.ogv=01;95:*.ogx=01;95:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
fi

#
# Remote machines.
#
if [[ "$(hostname)" == "Gewisse" ]]; then
	eval $(ssh-agent) >/dev/null
	ssh-add 2>/dev/null
	ssh-add ~/.ssh/id_ed25519_imcb 2>/dev/null
fi

alias unbolt='uv run --python /home/gauravmm/unbolt-project/unbolt/.venv unbolt'

alias claude-alt="CLAUDE_CONFIG_DIR=$HOME/.claude-secondary claude"

alias gst='git status'

# >>> Codex installer >>>
export PATH="/home/gauravmm/.local/bin:$PATH"
# <<< Codex installer <<<

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# bun completions
[ -s "/home/gauravmm/.bun/_bun" ] && source "/home/gauravmm/.bun/_bun"

# >>> Herdr Core agent launchers >>>
_hc_agent_executable() {
	local executable
	if executable=$(whence -p -- "$1") && [[ -x "$executable" ]]; then
		print -r -- "$executable"
		return
	fi

	# Look for npm-installed agents before nvm has loaded into this shell.
	case "$1" in
		cline|cmd|cmdc|command-code|commandcode)
			for executable in "$HOME"/.nvm/versions/node/v*/bin/"$1"(NnOn); do
				if [[ -x "$executable" ]]; then
					print -r -- "$executable"
					return
				fi
			done
			;;
	esac
	return 1
}

_hc_agent() {
	emulate -L zsh
	local agent=$1 executable
	shift
	executable=$(_hc_agent_executable "$agent") || {
		print -u2 -- "$agent: executable not found"
		return 127
	}

	local -x PATH=$PATH
	if [[ $executable == "$HOME"/.nvm/versions/node/*/bin/* ]]; then
		PATH="${executable:h}:$PATH"
	fi
	if [[ ! -o interactive || ! -t 0 || ! -t 1 || ! -t 2 || -n $IN_AI_CODING_TOOL ]]; then
		"$executable" "$@"
		return
	fi

	local -a direct_commands direct_flags value_flags foreground
	case "$agent" in
		codex)
			direct_commands=(agents exec e review login logout mcp plugin app-server remote-control completion update doctor sandbox debug apply queue archive delete unarchive migrate-rollouts migrate-nfs-db cloud exec-server features help app)
			direct_flags=(--remote)
			value_flags=(-c --config --enable --disable --local-provider -i --image -m --model -p --profile -s --sandbox -C --cd --add-dir -a --ask-for-approval)
			foreground=(--no-daemon)
			;;
		claude)
			direct_commands=(agents attach auth auto-mode doctor install login logout logs mcp plugin remote-control respawn rm setup-token stop kill update upgrade)
			direct_flags=(-p --print --bg --background --desktop --cloud)
			value_flags=(--add-dir --agent --agents --allowedTools --allowed-tools --append-system-prompt --append-system-prompt-file --debug-file --disallowedTools --disallowed-tools --effort --fallback-model --file --mcp-config --model -n --name --permission-mode --plugin-dir --session-id --setting-sources --settings --system-prompt --system-prompt-file -r --resume --from-pr)
			;;
		grok)
			direct_commands=(agent clone completions doctor du disk-usage export help inspect leader login logout mcp memory models plugin sessions setup trace update usage version v worker worktree wrap)
			direct_flags=(-p --single)
			value_flags=(--allow --cwd --debug-file --deny --disallowed-tools --json-schema --leader-socket -m --model --max-turns --output-format --permission-mode -r --resume -s --session-id --reasoning-effort --effort)
			;;
		opencode)
			direct_commands=(completion acp mcp run debug providers auth agent upgrade uninstall serve web models stats export import github session plugin plug db service)
			value_flags=(--log-level --port --hostname --mdns-domain --cors -m --model -s --session --prompt --agent --replay-limit)
			;;
		omp)
			direct_commands=(acp agents anonymize auth auth-broker auth-gateway bench browser-relay cleanse clip collab commit completions compress config dry-balance find gallery gc git grep grievances if-bench images install join login models play plugin predict ps read render say search session setup share shell skill skills ssh stats stream tiny-models token toks ttsr update usage worktree)
			direct_flags=(-p --print --mode --list-models)
			value_flags=(--model --smol --slow --plan --goal --provider --thinking --service-tier --session --session-dir --models --tools --system-prompt --append-system-prompt -e --extension --hook)
			;;
		cline)
			direct_commands=(auth config plugin skill connect mcp doctor history h hook schedule hub dashboard update version kanban)
			direct_flags=(--json --acp -z --zen --update --kanban)
			value_flags=(-c --cwd --compaction --id -P --provider -k --key -m --model -s --system -t --timeout --auto-approve --config --data-dir --hooks-dir)
			;;
		cmd|cmdc|command-code|commandcode)
			direct_commands=(info status help whoami update feedback issue taste learn-taste mcp cloud skills acp mods login logout)
			direct_flags=(-p --print --list-models)
			value_flags=(-r --resume --session -n --name -m --model --effort --theme --config --permission-mode --add-dir --base --mod --mod-option --skill)
			;;
	esac

	local arg option first_arg=''
	local -i position=0 skip_value=0 explicit_tui=0 has_positional=0
	for arg in "$@"; do
		(( ++position ))
		if (( skip_value )); then
			skip_value=0
			continue
		fi
		if [[ $arg == -- ]]; then
			(( position < $# )) && has_positional=1
			break
		fi
		option=${arg%%=*}
		case "$agent:$option" in
			codex:-V|claude:-v|grok:-v|opencode:-v|omp:-v|cline:-V|cmd:-v|cmdc:-v|command-code:-v|commandcode:-v)
				direct_flags+=("$option") ;;
			claude:-p?*|grok:-p?*|omp:-p?*|cmd:-p?*|cmdc:-p?*|command-code:-p?*|commandcode:-p?*)
				direct_flags+=("$option") ;;
			codex:--no-daemon) foreground=() ;;
			cline:-i|cline:--tui) explicit_tui=1 ;;
		esac
		if [[ $option == (-h|--help|--version) ]] || (( direct_flags[(Ie)$option] )); then
			"$executable" "$@"
			return
		fi
		case "$arg" in
			-*)
				if [[ $arg == "$option" ]] && (( value_flags[(Ie)$option] )); then
					skip_value=1
				fi
				;;
			*)
				if (( ! has_positional )); then
					first_arg=$arg
					has_positional=1
				fi
				;;
		esac
	done
	if (( direct_commands[(Ie)$first_arg] )); then
		"$executable" "$@"
		return
	fi
	if [[ $agent == cline ]] && (( ! explicit_tui )); then
		if (( has_positional )); then
			"$executable" "$@"
			return
		fi
		foreground=(--tui)
	fi
	if [[ -n $HC_TERMINAL_ID ]]; then
		"$executable" "${foreground[@]}" "$@"
		return
	fi

	# The Core daemon starts at boot. Pass paths from this interactive shell.
	local -a launch_env=("PATH=$PATH")
	local variable
	for variable in BROWSER SSH_AUTH_SOCK CODEX_HOME CLAUDE_CONFIG_DIR GROK_HOME OPENCODE_CONFIG OPENCODE_CONFIG_DIR PI_CODING_AGENT_DIR; do
		[[ -v $variable ]] && launch_env+=("$variable=${(P)variable}")
	done

	local address
	address=$(
		setopt pipefail
		hc run --bg --json --cwd "$PWD" -- /usr/bin/env "${launch_env[@]}" \
			"$executable" "${foreground[@]}" "$@" |
			jq -er '.address | strings | select(length > 0)'
	) || return
	hc attach "$address"
}

path=("${(@)path:#$HOME/.local/herdr-shims}")
for _hc_agent_name in codex claude grok opencode omp cline cmd cmdc command-code commandcode; do
	if _hc_agent_executable "$_hc_agent_name" >/dev/null; then
		alias "$_hc_agent_name=_hc_agent $_hc_agent_name"
	fi
done
unset _hc_agent_name
# <<< Herdr Core agent launchers <<<

export BROWSER=/bin/true
