; On-Chip Flash Memory Control


_enableFlashKeyRegister:
	; actual work here
	ld	a, 0b6h			; unlock
	out0	(FLASH_KEY), a
	ld	a, 049h
	out0	(FLASH_KEY), a
	ret

_lockFlashKeyRegister:
	; actual work here
	ld	a, 0ffh			; lock
	out0	(FLASH_KEY), a
	ret

FLASH:
        ld hl, s_UNLOCK_PROTECTION
        call PRINT
        ;
        call _enableFlashKeyRegister    ; unlock Flash Key Register, so we can write to the Flash Write/Erase protection registers
        ld a, 00000000b                 ; remove protection from all pages
        out0 (FLASH_PROT),a		; disable protection on block 00000 - 1ffff

        call _enableFlashKeyRegister    ; will need to unlock again after previous write to the flash protection register
        ld a, 05fh                      ; Ceiling(18Mhz * 5,1us) = 95, or 5F
        out0 (FLASH_FDIV),a			    
			
        ; erase first 1k page at upper blocks
        ld hl, s_ERASE_FLASH
        call PRINT
        ;
        ld a, (NR_PAGES)
        ld b, a
        ld a, (START_PAGE)      ; page 00h = adress 00000h
        ld c, a
        ld d, 0
FLASH_ERASE_LOOP:        
        ld a, d                 ; page counter
        add a,c                 ; add start page
        out0 (FLASH_PAGE), a    ; set in page register
        ld a, 00000010b         ; page erase enable
        out0 (FLASH_PGCTL), a   ; start erasing
FLASH_WAIT:
        in0 a, (FLASH_PGCTL)    ; check page erase bit
        and 00000010b
        jr nz, FLASH_WAIT       ; already 0?
        ;
        inc d
        djnz FLASH_ERASE_LOOP

        ; start flashing by writing new contents into memory
        ; could also be an ldir
        ld hl, s_WRITE_FLASH
        call PRINT
        ;
        ld hl, (SRC_ADDR)
        ld de, (DEST_ADDR)
        ld bc, (LENGTH)
        ldir
        ; lock protection
        call _lockFlashKeyRegister
        ;
        ld hl, s_LOCK_PROTECTION
        call PRINT
        ret

s_UNLOCK_PROTECTION     .db "+Unlock protection \r\n" ,0
s_ERASE_FLASH           .db "+Erase flash \r\n",0
s_WRITE_FLASH           .db "+Write flash \r\n",0
s_LOCK_PROTECTION       .db "+Lock protection \r\n",0