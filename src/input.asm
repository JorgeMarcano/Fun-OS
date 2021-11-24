KEY_ENTER	equ	0x0D
KEY_BACKSPACE	equ	0x08
KEY_SPACE	equ	' '

; di is start of buffer
; cx contains max size, cannot be 0
; creates a null terminated string and outputs each character
teletype_input:
	pusha

	dec cx
	mov dx, cx
	jz end_teletype_input

loop_teletype_input:
	mov ah, 0x00
	int 0x16
	cmp al, KEY_ENTER
	je end_teletype_input
	cmp al, KEY_BACKSPACE
	je backspace_teletype_input
	mov byte [di], al
	call print_char
	inc di
	dec cx
	jnz loop_teletype_input

end_teletype_input:
	mov byte [di], 0x00	; Null terminates the string
	call print_newl
	popa
	ret

backspace_teletype_input:
	cmp cx, dx
	je loop_teletype_input

handle_backspace_teletype_input:
	dec di
	inc cx
	mov byte [di], 0x00
	call print_backspace
	mov al, KEY_SPACE
	call print_char
	call print_backspace
	jmp loop_teletype_input
