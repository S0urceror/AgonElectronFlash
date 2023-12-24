        .org 42000h

NR_PAGES        .DB 040h 
START_PAGE      .DB 040h ; erase all pages from 10000 to 1ffff

SRC_ADDR        .DB 00h     ; L.H.U.
                .DB 00h
                .DB 05h
DEST_ADDR       .DB 00h
                .DB 00h
                .DB 01h

LENGTH          .DW FLASH_LEN
                .DB 000h
CRC             .DW 0,0

CRC_TEST        .DW FLASH_CRC_HIGH
                .DW FLASH_CRC_LOW
                
