ASM=../../development/spasm-ng-master/spasm
BINHEX=../../development/ihex-master/bin2ihex -b 0x20 
HEXBIN=../../development/ihex-master/ihex2bin 
AGON-ZDI-LOAD=../../development/agon-zdi-load/agon-zdi-load.py

all: build/flash_hdr.hex build/flash.hex 

build/flash.bin: main.asm flash_hdr.asm includes/print.inc includes/flash.inc includes/crc32.inc includes/ez80.inc includes/uart.inc includes/ez80f92.inc
	$(ASM) -E -T -S main.asm build/flash.bin

build/flash.hex: build/flash.bin
	$(BINHEX) -a 0x40000 -i build/flash.bin -o build/flash.hex
	python3 $(AGON-ZDI-LOAD) build/flash.hex 0
	
build/flash_hdr.bin: flash_hdr.asm
	$(ASM) -E -T -S flash_hdr.asm build/flash_hdr.bin

build/flash_hdr.hex: build/flash_hdr.bin
	$(BINHEX) -a 0x41000 -i build/flash_hdr.bin -o build/flash_hdr.hex
	python3 $(AGON-ZDI-LOAD) build/flash_hdr.hex 0

mos: mos-convert mos-checksum mos-upload

# convert base address 0x00000 to base address 0x50000
# then upload to AgonLight
mos-convert: ../../software/mos/Debug/MOS.hex
	$(HEXBIN) -i ../../software/mos/Debug/MOS.hex -o MOS-versions/MOS-RC4.bin
	$(BINHEX) -a 0x50000 -i MOS-versions/MOS-RC4.bin -o MOS-versions/MOS-RC4.hex

# calculate CRC32 and add to flash_hdr.asm
mos-checksum:
	crc32 MOS-versions/MOS-RC4.bin

mos-upload: 
	python3 $(AGON-ZDI-LOAD) MOS-versions/MOS-RC4.hex 0