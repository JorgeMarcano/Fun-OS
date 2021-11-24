; cx is string length
; si is string pointer
print_string:
	pusha
	xor bx, bx
	cmp cx, 0x00
	je end_print_string
	mov ah, 0x0E

print_string_loop:
	mov al, [si]
	int 0x10
	inc si
	dec cx
	jnz print_string_loop

end_print_string:
	popa
	ret

; si is string pointer
print_str_null:
	pusha
	xor bx, bx
	mov ah, 0x0E

loop_print_str_null:
	mov al, [si]
	cmp al, 0x00
	jz end_print_str_null
	int 0x10
	inc si
	jmp loop_print_str_null

end_print_str_null:
	popa
	ret
