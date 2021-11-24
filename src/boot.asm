org 0x7C00

KERNEL_SEG		equ	0x1000
KERNEL_SIZE_ADDR	equ	0x0000
KERNEL_START_ADDR	equ	0x0001

; Let User know we are loading data
	mov si, init_string
	call print_str_null

; Wait for user key press
	mov ah, 0x00
	int 0x16

; Try to load data past this sector
	mov al, 1	; Load just one sector for now
	mov cx, 0x0002	; 2nd sector of cylinder 0
	mov dh, 0x00	; head 0 of current drive

	mov bx, KERNEL_SEG
	mov es, bx
	xor bx, bx

	call read_drive

	mov bx, KERNEL_SEG
	mov ds, bx

	mov bl, byte [0x0000]
	dec bl
	jz load_kernel

	mov al, bl	; Load remaining sectors
	mov cx, 0x0003	; 3rd sector of cylinder 0
	mov bx, 0x200	; Save after first sector
	call read_drive

load_kernel:
	mov si, success_msg
	call print_str_null

	jmp KERNEL_SEG:KERNEL_START_ADDR

include 'print.asm'
include 'drive.asm'

variables:
init_string: db 'Attempting to load OS', 0x0D, 0x0A, 'Press any key to continue...', 0x0D, 0x0A, 0x00
success_msg: db 'Successfully read sector', 0x0D, 0x0A, 0x00

; Boot Sector Padding and Magic Number
times 510-($-$$) db 0
dw 0x55AA
