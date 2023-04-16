; Calculating ZIP CRC-32 in Z80
; =============================
;
; Calculate a ZIP 32-bit CRC from data in memory. This code is as
; tight and as fast as it can be, moving as much code out of inner
; loops as possible. Can be made shorter, but slower, by replacing
; JP with JR.
;
; On entry, crc..crc+3   =  incoming CRC
;           addr..addr+1 => start address of data
;           num..num+1   =  number of bytes
; On exit,  crc..crc+3   =  updated CRC
;           addr..addr+1 => undefined
;           num..num+1   =  undefined
;
; Multiple passes over data in memory can be made to update the CRC.
; For ZIP, initial CRC must be &FFFFFFFF, and the final CRC must
; be EORed with &FFFFFFFF before being stored in the ZIP file.
; Total 70 bytes. 
;
crc32_calc:
    push ix
    ld ix,CRC
    ld (ix+0),0ffh
    ld (ix+1),0ffh
    ld (ix+2),0ffh
    ld (ix+3),0ffh
    pop ix
    LD BC,(LENGTH)  ;\ Address, Count
    LD DE,(CRC)
    LD HL,(CRC+2) ;\ Incoming CRC
;
; Enter here with IX=addr, BC=num, HLDE=crc
;
bytelp:
    PUSH BC                   ;\ Save count
    LD A,(IX)                 ;\ Fetch byte from memory
; The following code updates the CRC with the byte in A ---------+
    XOR E                     ;\ XOR byte into CRC bottom byte       |
    LD B,8                    ;\ Prepare to rotate 8 bits            |
rotlp:                        ;\                                     |
    SRL H                     ;\ Rotate CRC                          |
    RR L
    RR D
    RRA       
    JP NC,clear               ;\ b0 was zero                         |
    LD E,A                    ;\ Put CRC low byte back into E        |
    ;
    LD A,H                    ;\ CRC=CRC XOR &EDB88320, ZIP polynomic|
    XOR 0EDh
    LD H,A     
    ;
    LD A,L
    XOR 0B8h
    LD L,A
    ;
    LD A,D
    XOR 083h
    LD D,A
    ;
    LD A,E                    ;\ And get CRC low byte back into A    |
    XOR 020h
clear: 
    DEC B
    JP NZ,rotlp               ;\ Loop for 8 bits                     |
    LD E,A                    ;\ Put CRC low byte back into E        |
; ---------------------------------------------------------------+
;
    INC IX                    ;\ Step to next byte
    POP BC
    DEC BC                    ;\ num=num-1
    LD A,B
    OR C
    JP NZ,bytelp              ;\ Loop until num=0
    LD (CRC),DE
    LD (CRC+2),HL             ;\ Store outgoing CRC

    ld hl,CRC
    ld b,4
crc32_loop:
    ld a, (hl)
    xor 0ffh
    ld (hl),a
    inc hl
    djnz crc32_loop

    RET

crc32_compare:

        ld hl,CRC
        ld de,CRC_TEST
        ld bc,4
loop_crc_test:
        ld a, (de)
        cpi
        jr nz, crc32_error
        inc de
        ld a,c
        and a
        jr nz, loop_crc_test
        or a
        ret
crc32_error:
        scf
        ret
