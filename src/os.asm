org 0x0000

db (end_pointer - $$) / 512	; Should contain how many sectors this OS is

	jmp main			; Jumps to start address of OS

main:
	call print_init
	mov si, welcome_msg
	call print_str_null

main_loop:
	cmp byte [cmd_skip_newl], 0x00
	jne main_loop_skip_newl
	call print_newl
	jmp continue_main_loop
main_loop_skip_newl:
	mov byte [cmd_skip_newl], 0x00
continue_main_loop:
	mov si, prompt
	call print_str_null

	mov cx, 0x0100		; Maximum size of 256 characters
	mov di, cmd_buffer
	call teletype_input	; Get next command

	mov si, di
	call handle_cmd

	jmp main_loop

	cli
	hlt


include 'OSprint.asm'
include 'input.asm'
include 'cmd.asm'

welcome_msg: db 'Welcome to Fun OS, a 16-bit real mode OS', 0x00
prompt: db '> ', 0x00
cmd_buffer: times 256 db 0x00

times 512 - ( ($ - $$) mod 512) db 0x00

end_pointer:
