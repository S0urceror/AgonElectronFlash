        .org 41000h

NR_PAGES        .DB 040h ; erase all pages from 00000 to 0ffff
START_PAGE      .DB 000h

SRC_ADDR        .DB 00h     ; L.H.U.
                .DB 00h
                .DB 05h
DEST_ADDR       .DB 00h
                .DB 00h
                .DB 00h

LENGTH          .DW 43578
                .DB 000h
CRC             .DW 0,0

CRC_TEST        .DW 0e18ah
                .DW 04909h
                
