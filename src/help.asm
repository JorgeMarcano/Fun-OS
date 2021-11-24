; no data
help_c:
	push si
	mov si, help_string
	call print_str_null
	pop si
	ret

help_string:	db 0x0D, 0x0A, 'HELP:', 0x0D, 0x0A, 0x0D, 0x0A
		db 'print %s           : prints string on terminal', 0x0D, 0x0A, 0x0D, 0x0A
		db 'hexdump %04x %02x  : prints [2] 16B lines start at addr [1]', 0x0D, 0x0A, 0x0D, 0x0A
		db 'help               : prints a list of possible commands', 0x0D, 0x0A, 0x0D, 0x0A
		db 'regdump            : prints a list of segment register', 0x0D, 0x0A, 0x0D, 0x0A
		db 'put %04x %02X      : puts byte [2] in addr [1]', 0x0D, 0x0A, 0x0D, 0x0A
		db 'clear              : clears screen', 0x0D, 0x0A, 0x00
