; no data
help_c:
	push si
	mov si, help_string
	call print_str_null
	pop si
	ret

help_string:	db 0x0D, 0x0A, 'HELP:', 0x0D, 0x0A, 0x0D, 0x0A
		db 'print %s           : Prints string on terminal', 0x0D, 0x0A, 0x0D, 0x0A
		db 'hexdump %04X %02X  : Prints [2] 16B lines starting at addr [1]', 0x0D, 0x0A, 0x0D, 0x0A
		db 'help               : Prints a list of possible commands', 0x0D, 0x0A, 0x0D, 0x0A
		db 'regdump            : Prints a list of segment register', 0x0D, 0x0A, 0x0D, 0x0A
		db 'shutdown           : Shuts down the device', 0x0D, 0x0A, 0x0D, 0x0A
		db 'clear              : Clears screen', 0x0D, 0x0A, 0x0D, 0x0A
		db 'dsk                : Prints all drives available', 0x0D, 0x0A, 0x0D, 0x0A
		db 'mnt %02X           : Sets [1] as currently active drive', 0x0D, 0x0A
		db 0x00
