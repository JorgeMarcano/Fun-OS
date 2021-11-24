; al is sectors to read
; ch is cylinder
; cl is sector
; dh is head
; dl is drive
; es:bx is dest buffer
read_drive:
	pusha
	mov ah, 0x02
	push ax

	int 0x13
	jnc finish_read_drive
	; it failed, try again
	pop ax
retry_read_drive:
	push ax
	int 0x13
	jnc finish_read_drive

failed_read_drive:
	mov si, failed_read_drive_msg
	call print_str_null
	cli
	hlt

finish_read_drive:
	; Make sure right amount of sectors read
	mov dl, al
	pop ax
	cmp al, dl
	jne failed_read_drive

done_read_drive:
	popa
	ret

failed_read_drive_msg: db 'Failed to read drive!', 0x0D, 0x0A, 0x00
