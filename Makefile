ASM=../../development/spasm-ng-master/spasm
BINHEX=../../development/ihex-master/bin2ihex -b 0x20 
HEXBIN=../../development/ihex-master/ihex2bin 
AGON-ZDI-LOAD=../../development/agon-zdi-load/agon-zdi-load.py

all: eos build/flash_hdr.hex build/flash.hex 

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
	cp flash_hdr-template.asm flash_hdr.asm
	@echo Inserting CRC32 and MOS binary filesize in flash_hdr
	$(eval MYCRC32 = $$(shell crc32 MOS-versions/MOS-RC4.bin))
	$(eval MYCRC32_LOW = $$(shell echo $(MYCRC32) | cut -c 1-4))
	$(eval MYCRC32_HIGH = $$(shell echo $(MYCRC32) | cut -c 5-8))
	$(eval MYSIZE = $$(shell stat -f%z MOS-versions/MOS-RC4.bin))
	sed -i -e 's/FLASH_LEN/$(MYSIZE)/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_LOW/0$(MYCRC32_LOW)h/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_HIGH/0$(MYCRC32_HIGH)h/g' flash_hdr.asm

mos-upload: 
	python3 $(AGON-ZDI-LOAD) MOS-versions/MOS-RC4.hex 0

eos: eos-convert eos-checksum eos-upload

# convert base address 0x00000 to base address 0x50000
# then upload to AgonLight
eos-convert: ../../software/AgonElectronOS/Debug/AgonElectronOS.hex
	$(HEXBIN) -i ../../software/AgonElectronOS/Debug/AgonElectronOS.hex -o EOS/AgonElectronOS.bin
	$(BINHEX) -a 0x50000 -i EOS/AgonElectronOS.bin -o EOS/AgonElectronOS.hex

# calculate CRC32 and add to flash_hdr.asmb
eos-checksum:
	cp flash_hdr-template.asm flash_hdr.asm
	@echo Inserting CRC32 and EOS binary filesize in flash_hdr
	$(eval MYCRC32 = $$(shell crc32 EOS/AgonElectronOS.bin))
	$(eval MYCRC32_LOW = $$(shell echo $(MYCRC32) | cut -c 1-4))
	$(eval MYCRC32_HIGH = $$(shell echo $(MYCRC32) | cut -c 5-8))
	$(eval MYSIZE = $$(shell stat -f%z EOS/AgonElectronOS.bin))
	sed -i -e 's/FLASH_LEN/$(MYSIZE)/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_LOW/0$(MYCRC32_LOW)h/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_HIGH/0$(MYCRC32_HIGH)h/g' flash_hdr.asm

eos-upload: 
	cp EOS/AgonElectronOS.bin ../../development/agon-light-emulator-main
	python3 $(AGON-ZDI-LOAD) EOS/AgonElectronOS.hex 0