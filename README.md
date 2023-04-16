# AgonLight Flash application
This application is written in assembly and flashes a binary that is described by a separate flash_hdr.asm file.

In this file you can specify the following:
```
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
```
The current version of the flash application assumes this header to sit at 0x41000. The rest is described in this header.

## Manually from Electron HAL
Do the following steps to start this application from Electron HAL.
* Press CTRL-Z
* Copy & paste the compiled flash_hdr.hex file from the /build directory
* Copy & paste the compiled flash.hex file from the /build directory
* Copy & paste the file you want to flash
* Type J 040000

The application should now check the CRC and commence flashing and check the CRC again. Press reset and your new OS should be running.

## Use Makefile
Check the Makefile with this project to see how you can use the agon-zdi-load.py script to do the uploading and converting MOS.bin files.