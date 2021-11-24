; no data
regdump_c:
	push ax
	push bx
	push si

	call print_newl

	mov si, regdump_cs_str
	call print_str_null
	mov bx, cs
	mov al, bh
	call print_hex_char
	mov al, bl
	call print_hex_char
	call print_newl

	mov si, regdump_ds_str
	call print_str_null
	mov bx, ds
	mov al, bh
	call print_hex_char
	mov al, bl
	call print_hex_char
	call print_newl

	mov si, regdump_es_str
	call print_str_null
	mov bx, es
	mov al, bh
	call print_hex_char
	mov al, bl
	call print_hex_char
	call print_newl

	mov si, regdump_ss_str
	call print_str_null
	mov bx, ss
	mov al, bh
	call print_hex_char
	mov al, bl
	call print_hex_char
	call print_newl

	pop si
	pop bx
	pop ax
	ret

regdump_cs_str:	db 'CS: ', 0x00
regdump_ds_str: db 'DS: ', 0x00
regdump_es_str: db 'ES: ', 0x00
regdump_ss_str: db 'SS: ', 0x00
