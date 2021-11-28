hard_drive_count:	db 0x00
floppy_drive_count:	db 0x00

current_drive_index:	db 0x00

CMD_MNT_LEN	equ	3

; dl contains drive to query
print_drive_info:
	ret


; no data, saves to drive_count
get_drive_count:
	pusha
	mov ah, 0x08
	mov dl, 0x00
	mov di, 0x00
	mov es, di
	pusha
	int 0x13
	jnc no_error_get_drive_count_1

	mov dl, 0x00
no_error_get_drive_count_1:
	mov [floppy_drive_count], dl
	popa
	mov dl, 0x80
	int 0x13
	jnc no_error_get_drive_count_2

	mov dl, 0x00
no_error_get_drive_count_2:
	mov [hard_drive_count], dl
	popa
	ret

; dl contains drive index
get_drive_info:
	pusha
	mov si, get_drive_info_title_msg
	call print_str_null
	mov al, dl
	call print_hex_char
	call print_newl

	mov ah, 0x08
	int 0x13

	jc error_get_drive_info

	mov al, cl
	shr al, 6
	inc ch
	jnc skip_inc_get_drive_info
	inc al
skip_inc_get_drive_info:
	mov si, get_drive_info_cyl_msg
	call print_str_null
	call print_hex_char
	mov al, ch
	call print_hex_char
	call print_newl

	mov si, get_drive_info_sec_msg
	call print_str_null
	mov al, cl
	and al, 0x3F
	call print_hex_char
	call print_newl

	mov si, get_drive_info_head_msg
	call print_str_null
	mov al, dh
	inc al
	call print_hex_char

	jmp end_get_drive_info

error_get_drive_info:
	mov al, ah
	mov si, get_drive_info_error_msg
	call print_str_null
	call print_hex_char

end_get_drive_info:
	popa
	ret

; no data, updates drive_count
list_dsk_c:
	pusha

	call get_drive_count

	mov si, print_floppy_count_msg
	call print_str_null
	mov al, [floppy_drive_count]
	call print_hex_char

	xor dl, dl
	cmp al, dl
	je hdd_list_dsk_c

loop_floppy_list_dsk_c:
	call print_newl
	call get_drive_info
	inc dl
	cmp dl, al
	jne loop_floppy_list_dsk_c

hdd_list_dsk_c:
	mov si, print_hdd_count_msg
	call print_newl
	call print_str_null
	mov al, [hard_drive_count]
	call print_hex_char

	xor dl, dl
	cmp al, dl
	je end_list_dsk_c

	add dl, 0x80
	add al, dl
loop_hdd_list_dsk_c:
	call print_newl
	call get_drive_info
	inc dl
	cmp dl, al
	jne loop_hdd_list_dsk_c

end_list_dsk_c:
	popa
	ret

; si contains command string
; Proper syntax 'mnt XX'
mnt_c:
	pusha

	add si, CMD_MNT_LEN
	cmp byte [si], ' '
	jne syntax_mnt_c
	inc si

	xor bl, bl
	call parse_hex_byte
	cmp ah, bl
	jne syntax_mnt_c

	inc si
	inc si
	cmp [si], bl
	jne syntax_mnt_c

	push ax
	mov dl, al
	mov ah, 0x08
	int 0x13
	jc error_mnt_c

	pop ax
	mov [current_drive_index], al
	mov si, mnt_c_success_msg
	call print_str_null
	call print_hex_char
	jmp end_mnt_c

error_mnt_c:
	pop ax
	mov si, mnt_c_error_msg
	call print_str_null
	call print_hex_char
	jmp end_mnt_c

syntax_mnt_c:
	mov si, cmd_syntax_err
	call print_str_null

end_mnt_c:
	popa
	ret

print_hdd_count_msg: 		db 'Hard Drive Count: 0x', 0x00
print_floppy_count_msg:		db 'Floopy Drive Count: 0x', 0x00
get_drive_info_error_msg:	db 'Error Getting information: 0x', 0x00
get_drive_info_title_msg:	db '== Drive 0x', 0x00
get_drive_info_cyl_msg:		db ' |- Cylinders: 0x', 0x00
get_drive_info_sec_msg:		db ' |- Sectors: 0x', 0x00
get_drive_info_head_msg:	db ' |- Heads: 0x', 0x00

mnt_c_error_msg:		db 'Failed to mount 0x', 0x00
mnt_c_success_msg:		db 'Successfully mounted 0x', 0x00
