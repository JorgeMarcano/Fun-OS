cmd_print: 	db 'print ', 0x00
CMD_PRINT_LEN	equ	6
cmd_error:	db 'ERROR: Command not recognized!', 0x00
cmd_hexdump:	db 'hexdump ', 0x00
cmd_syntax_err:	db 'ERROR: Invalid syntax!', 0x00
cmd_shutdown:	db 'shutdown', 0x00
cmd_help:	db 'help', 0x00
cmd_regdump:	db 'regdump', 0x00
cmd_clear:	db 'clear', 0x00

; si contains buffer
; cx contains maximum size
handle_cmd:
	pusha

	mov bl, 0x00
	mov di, cmd_print
	call cmp_substr
	cmp al, bl
	jne handle_print_cmd

	mov di, cmd_clear
	call cmp_str
	cmp al, bl
	jne handle_clear_cmd

	mov di, cmd_shutdown
	call cmp_substr
	cmp al, bl
	jne handle_shutdown_cmd

	mov di, cmd_hexdump
	call cmp_substr
	cmp al, bl
	je not_cmd_hexdump
	call hexdump_c
	jmp end_handle_cmd

not_cmd_hexdump:

	mov di, cmd_help
	call cmp_str
	cmp al, bl
	je not_cmd_help
	call help_c
	jmp end_handle_cmd

not_cmd_help:

	mov di, cmd_regdump
	call cmp_str
	cmp al, bl
	je not_cmd_regdump
	call regdump_c
	jmp end_handle_cmd

not_cmd_regdump:

	jmp handle_cmd_error

handle_print_cmd:
	add si, CMD_PRINT_LEN
	call print_str_null
	jmp end_handle_cmd

handle_clear_cmd:
	mov ax, 0x0600
	mov bx, 0x0700
	mov cx, 0x0000
	mov dx, 0x1850
	int 0x10
	mov ah, 0x02
	mov bh, 0x00
	mov dx, 0x0000
	int 0x10
	mov byte [cmd_skip_newl], 0x01
	jmp end_handle_cmd

handle_shutdown_cmd:
	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 0x15

handle_cmd_error:
	mov si, cmd_error
	call print_str_null

end_handle_cmd:
	popa
	ret

include 'string.asm'
include 'hexdump.asm'
include 'help.asm'
include 'regdump.asm'

cmd_skip_newl:	db 0x00
