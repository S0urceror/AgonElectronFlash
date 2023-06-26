
EZ80_INIT:
    di
    rsmix
    ; embedded flash upper address 00
    ld      a,$00
    out0    (FLASH_ADDR_U),a
    ; embedded flash enable
    ld      a,00101000b ; flash enabled, 1 wait state
    out0    (FLASH_CTRL),a
    ; configure internal RAM chip-select range
    ld a, 0bch      ; bc0000h
    out0 (RAM_ADDR_U),a
    ld a, 080h      ; enable
    out0 (RAM_CTL),a
    ; configure RAM chip-select range
    ld a, 04h
    out0 (CS0_LBR), a
    ld a, 0bh
    out0 (CS0_UBR), a
    ld a, 001h  ; 1 wait-state, ez80 mode
    out0 (CS0_BMC), a
    ld a, 008h  ; memory chip select, cs0 enabled
    out0 (CS0_CTL), a

    ; setup Stack Pointer
    ld sp, 0bffffh

