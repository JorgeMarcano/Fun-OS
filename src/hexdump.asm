CMD_HEXDUMP_LEN	equ	8

; si contains command string
; Proper syntax is 'hexdump XXXX xx'
hexdump_c:
	pusha

	add si, CMD_HEXDUMP_LEN
	cmp byte [si], 0x00
	je error_hexdump_c	; If empty string then syntax error

	xor bx, bx
	mov cx, 0x0002
	mov dx, 0x0001
	call parse_hex_byte
	cmp ah, dl
	je error_hexdump_c
	mov bh, al
	add si, cx
	call parse_hex_byte
	cmp ah, dl
	je error_hexdump_c
	mov bl, al
	add si, cx
	cmp byte [si] , ' '
	jne error_hexdump_c
	inc si
	call parse_hex_byte
	cmp ah, dl
	je error_hexdump_c
	add si, cx
	cmp byte [si], 0x00
	jne error_hexdump_c

	mov si, bx
	xor cx, cx
	mov cl, al
	call print_hex_arr
	jmp end_hexdump_c

error_hexdump_c:
	mov si, cmd_syntax_err
	call print_str_null

end_hexdump_c:
	popa
	ret

; si contains 2 ascii char
; return hex number in al
; if error ah = 1, otherwise ah = 0
parse_hex_byte:
	push bx
	push si

	mov ax, 0x0100

	mov bl, [si]
	cmp bl, '9'
	jle calc_high_parse_hex_byte
	sub bl, 'A'-'9'-1
	cmp bl, '0'+16
	jge end_parse_hex_byte

calc_high_parse_hex_byte:
	cmp bl, '0'
	jl end_parse_hex_byte
	sub bl, '0'
	mov al, bl
	shl al, 0x04

	inc si
	mov bl, [si]
	cmp bl, '9'
	jle calc_low_parse_hex_byte
	sub bl, 'A'-'9'-1
	cmp bl, '0'+16
	jge end_parse_hex_byte

calc_low_parse_hex_byte:
	cmp bl, '0'
	jl end_parse_hex_byte
	sub bl, '0'
	or al, bl
	xor ah, ah

end_parse_hex_byte:
	pop si
	pop bx
	ret

; si contains start byte to print
; cx contains number of lines (max 256)
print_hex_arr:
	pusha

	cmp cx, 0x00
	je end_print_hex_arr

	and si, 0xFFF0
	inc cx
	xor bx, bx

break_line_loop_print_hex_arr:	; Finished a line, must enter next line and print addr
	call print_newl

	dec cx
	jz end_print_hex_arr

	mov dx, si
	mov al, dh
	call print_hex_char
	mov al, dl
	call print_hex_char
	mov si, hex_string_addr_delim
	call print_str_null
	mov si, dx

	mov bx, 0x008

loop_print_hex_arr:
	mov al, [si]
	call print_hex_char
	inc si
	mov al, [si]
	call print_hex_char
	inc si
	mov al, ' '
	call print_char
	dec bx
	jz break_line_loop_print_hex_arr
	jmp loop_print_hex_arr

end_print_hex_arr:
	popa
	ret

; al contains hex byte
print_hex_char:
	pusha

	mov ah, al
	mov di, hex_string+1
	and al, 0x0F
	add al, '0'
	cmp al, '9'
	jle big_print_hex_char
	add al, 'A'-'9'-1

big_print_hex_char:
	mov [di], al
	dec di
	shr ah, 0x04
	add ah, '0'
	cmp ah, '9'
	jle print_print_hex_char
	add ah, 'A'-'9'-1

print_print_hex_char:
	mov [di], ah
	mov si, di
	call print_str_null

end_print_hex_char:
	popa
	ret

hex_string: db '00', 0x00
hex_string_addr_delim: db ': ', 0x00
