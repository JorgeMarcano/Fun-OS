; si contains string that needs to contains smaller string
; di contains substring that we will compare
; Both string must match until one terminate
; returns al as bool (0 if failed, 1 if match)
cmp_substr:
	pusha

loop_cmp_substr:
	mov al, byte [di]
	cmp al, 0x00
	je end_cmp_substr_success
	cmp byte [si], al
	jne end_cmp_substr_failed
	inc di
	inc si
	jmp loop_cmp_substr

end_cmp_substr_success:
	popa
	mov al, 0x01
	ret

end_cmp_substr_failed:
	popa
	mov al, 0x00
	ret

; si contains string 1
; di contains string 2
; Both string much match exactly and terminate at the same time
; returns al as bool
cmp_str:
	pusha

loop_cmp_str:
	mov al, byte [di]
	cmp byte [si], al
	jne end_cmp_substr_failed
	cmp al, 0x00
	je end_cmp_str_success
	inc di
	inc si
	jmp loop_cmp_str

end_cmp_str_success:
	popa
	mov al, 0x01
	ret

end_cmp_str_failed:
	popa
	mov al, 0x00
	ret
