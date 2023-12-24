        .org 42000h

NR_PAGES        .DB 040h ; erase all pages from 00000 to 0ffff
START_PAGE      .DB 000h

SRC_ADDR        .DB 00h     ; L.H.U.
                .DB 00h
                .DB 05h
DEST_ADDR       .DB 00h
                .DB 00h
                .DB 00h

LENGTH          .DW 46823
                .DB 000h
CRC             .DW 0,0

CRC_TEST        .DW 0ecc2h
                .DW 0e880h
                
