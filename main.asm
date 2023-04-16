        #include "includes/ez80f92.inc"

        .ASSUME	ADL = 1
        .org 40000h

_start_of_jumptable:
        jp _mos_init
_end_of_jumptable:
        .fill 64-(_end_of_jumptable-_start_of_jumptable)
        .DB	"MOS"				; Flag for MOS - to confirm this is a valid MOS command
		.DB	00h				; MOS header version 0
		.DB	01h				; Flag for run mode (0: Z80, 1: ADL)

_mos_init:  
        PUSH	AF			; Preserve registers
        PUSH	BC
        PUSH	DE
        PUSH	IX
        PUSH	IY			; Need to preserve IY for MOS			

        LD	A, MB			; Save MB
        PUSH 	AF
        XOR 	A
        LD 	MB, A                   ; Clear to zero so MOS API calls know how to use 24-bit addresses.

        call    _main

        POP AF
        LD	MB, A

        POP	IY			; Restore registers
        POP	IX
        POP	DE
        POP 	BC
        POP	AF
        RET

_main:
        DI      ; disable interrupts

        call UART0_INIT
        
        LD	HL, s_WELCOME
        CALL	PRINT

        ; check CRC of buffer holding to be flashed program
        LD IX,(SRC_ADDR)
        ; calculate CRC32, placed in (CRC)
        call crc32_calc
        ; compare to value in (CRC_TEST)
        call crc32_compare
        jr c, crc_src_error
        ld hl, s_CRC_SRC_OKAY
        call PRINT

        ; flash
        ld      HL, s_FLASHING
        call    PRINT
        CALL    FLASH

        ; check CRC upper 64kb bank of ROM
        LD IX,(DEST_ADDR)
        ; calculate CRC32, placed in (CRC)
        call crc32_calc
        ; compare to value in (CRC_TEST)
        call crc32_compare
        jr c, crc_dst_error
        ld hl, s_CRC_DST_OKAY
        call PRINT

        ; return value
        LD	HL, 0
        EI      ; enable interrupts
        RET

crc_src_error:
        ld hl, s_CRC_SRC_ERROR
        call PRINT
        ld hl,0
        EI      ; enable interrupts
        RET
crc_dst_error:
        ld hl, s_CRC_DST_ERROR
        call PRINT
        ld hl,0
        EI      ; enable interrupts
        RET        


        #include "includes/ez80.inc"
        #include "includes/uart.inc"
        #include "includes/flash.inc"
        #include "includes/print.inc"
        #include "includes/crc32.inc"

; Sample text
;
s_WELCOME:	.DB 	"Agon Electron - flash utility\n\r", 0
s_FLASHING:     .DB "Flashing...\r\n", 0
s_CRC_SRC_ERROR:     .DB "CRC upload error!!\r\n", 0
s_CRC_DST_ERROR:     .DB "CRC flash error!!\r\n", 0
s_CRC_SRC_OKAY:     .DB "CRC uploaded code okay\r\n", 0
s_CRC_DST_OKAY:     .DB "CRC flashed code okay\r\n", 0

        #include "flash_hdr.asm"