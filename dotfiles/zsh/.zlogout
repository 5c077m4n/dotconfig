if [[ -o rcs ]]; then
	# delete system mail file
	[[ -f "/var/mail/$USER" ]] && rm "/var/mail/$USER"
fi
