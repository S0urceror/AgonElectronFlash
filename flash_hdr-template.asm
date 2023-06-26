        .org 41000h

NR_PAGES        .DB 040h ; erase all pages from 00000 to 0ffff
START_PAGE      .DB 000h

SRC_ADDR        .DB 00h     ; L.H.U.
                .DB 00h
                .DB 05h
DEST_ADDR       .DB 00h
                .DB 00h
                .DB 00h

LENGTH          .DW FLASH_LEN
                .DB 000h
CRC             .DW 0,0

CRC_TEST        .DW FLASH_CRC_HIGH
                .DW FLASH_CRC_LOW
                
