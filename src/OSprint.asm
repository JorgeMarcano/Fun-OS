CHAR_NULL	equ 0x00
CHAR_BACKSPACE	equ 0x08

; no data is passed
print_init:
;	pusha
;	mov word [print_current_loc], 0x0000
;	mov ax, 0x0003
;	int 0x10
;	popa
	ret

; cx is string length
; si is string pointer
print_string:
	pusha
	cmp cx, 0x0000
	je end_print_string

	mov ah, 0x0E

print_string_loop:
	mov al, [si]
	int 0x10
	inc si
	inc bx
	dec cx
	jnz print_string_loop

end_print_string:
	popa
	ret

; si is string pointer
print_str_null:
	pusha
	mov ah, 0x0E

loop_print_str_null:
	mov al, [si]
	cmp al, CHAR_NULL
	jz end_print_str_null
	int 0x10
	inc si
	inc bx
	jmp loop_print_str_null

end_print_str_null:
	popa
	ret

; al contains ascii character
print_char:
	push ax
	mov ah, 0x0E
	int 0x10
	pop ax
	ret

print_newl:
	push ax
	mov ax, 0x0E0D
	int 0x10
	mov al, 0x0A
	int 0x10
	pop ax
	ret

print_backspace:
	push ax
	mov ax, 0x0E08
	int 0x10
	pop ax
	ret
