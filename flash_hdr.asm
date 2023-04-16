        .org 41000h

NR_PAGES        .DB 040h ; erase all pages from 00000 to 0ffff
START_PAGE      .DB 000h

SRC_ADDR        .DB 00h     ; L.H.U.
                .DB 00h
                .DB 05h
DEST_ADDR       .DB 00h
                .DB 00h
                .DB 00h
LENGTH          .DB 07eh
                .DB 0c2h
                .DB 000h
CRC             .DW 0,0
CRC_TEST        .DB 069h,0d6h,03ah,08ah ;8a3ad669