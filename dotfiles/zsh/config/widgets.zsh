# Reduce `vi-cmd-mode` sensitivity
vi-cmd-mode() {
	local is_esc=1 REPLY
	while (( KEYS_QUEUED_COUNT || PENDING )); do
		is_esc=0
		zle read-command
	done
	((is_esc)) && zle .$WIDGET
}
zle -N vi-cmd-mode
export KEYTIMEOUT=10
