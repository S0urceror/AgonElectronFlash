ASM=../../development/spasm-ng-master/spasm
BINHEX=../../development/ihex-master/bin2ihex -b 0x20 
HEXBIN=/usr/local/bin/hex2bin
HEX2BIN=../../development/ihex-master/ihex2bin 
AGON-ZDI-LOAD=../../development/agon-zdi-load/agon-zdi-load.py

all: eos build/flash_hdr.hex build/flash.hex 

build/flash.bin: main.asm flash_hdr.asm includes/print.inc includes/flash.inc includes/crc32.inc includes/ez80.inc includes/uart.inc includes/ez80f92.inc
	$(ASM) -E -T -S main.asm build/flash.bin

build/flash.hex: build/flash.bin
	$(BINHEX) -a 0x41000 -i build/flash.bin -o build/flash.hex
	python3 $(AGON-ZDI-LOAD) build/flash.hex 0 /dev/tty.usbserial-21130 500000
	#python3 $(AGON-ZDI-LOAD) build/flash.hex 0 /dev/tty.usbserial-02B1CCD1 500000
	#python3 $(AGON-ZDI-LOAD) build/flash.hex 0 /dev/tty.usbserial-10 500000

build/flash_hdr.bin: flash_hdr.asm
	$(ASM) -E -T -S flash_hdr.asm build/flash_hdr.bin

build/flash_hdr.hex: build/flash_hdr.bin
	$(BINHEX) -a 0x42000 -i build/flash_hdr.bin -o build/flash_hdr.hex
	python3 $(AGON-ZDI-LOAD) build/flash_hdr.hex 0 /dev/tty.usbserial-21130 500000
	#python3 $(AGON-ZDI-LOAD) build/flash_hdr.hex 0 /dev/tty.usbserial-02B1CCD1 500000
	#python3 $(AGON-ZDI-LOAD) build/flash_hdr.hex 0 /dev/tty.usbserial-10 500000

mos: mos-convert mos-checksum mos-upload

mos-high: mos-convert-high mos-checksum-high mos-upload

mos-eos: mos-convert-64k

# convert base address 0x00000 to base address 0x50000
# then upload to AgonLight
mos-convert: ../../software/agon-mos/Debug/MOS.hex
	$(HEX2BIN) -i ../../software/agon-mos/Debug/MOS.hex -o MOS-versions/MOS.bin
	$(BINHEX) -a 0x50000 -i MOS-versions/MOS.bin -o MOS-versions/MOS.hex

mos-convert-64k: ../../software/agon-mos/Debug/MOS.hex
	cp ../../software/agon-mos/Debug/MOS.hex MOS-versions/MOS.hex
	$(HEXBIN) -l 0x10000 MOS-versions/MOS.hex
	$(HEX2BIN) -i ../../software/AgonElectronOS/Debug/AgonElectronOS.hex -o EOS/AgonElectronOS.bin
	cat MOS-versions/MOS.bin EOS/AgonElectronOS.bin > EOS/MOS-EOS.bin

mos-convert-high: ../../software/agon-mos/Debug/MOS.hex
	$(HEX2BIN) -i ../../software/agon-mos/Debug/MOS.hex -o MOS-versions/MOS.bin
	#split -d -b 64k MOS-versions/MOS.bin MOS-versions/MOS-
	#$(BINHEX) -a 0x50000 -i MOS-versions/MOS-01 -o MOS-versions/MOS.hex
	$(BINHEX) -a 0x50000 -i MOS-versions/MOS.bin -o MOS-versions/MOS.hex

# calculate CRC32 and add to flash_hdr.asm
mos-checksum:
	cp flash_hdr-template.asm flash_hdr.asm
	@echo Inserting CRC32 and MOS binary filesize in flash_hdr
	$(eval MYCRC32 = $$(shell crc32 MOS-versions/MOS.bin))
	$(eval MYCRC32_LOW = $$(shell echo $(MYCRC32) | cut -c 1-4))
	$(eval MYCRC32_HIGH = $$(shell echo $(MYCRC32) | cut -c 5-8))
	$(eval MYSIZE = $$(shell stat -f%z MOS-versions/MOS.bin))
	sed -i -e 's/FLASH_LEN/$(MYSIZE)/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_LOW/0$(MYCRC32_LOW)h/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_HIGH/0$(MYCRC32_HIGH)h/g' flash_hdr.asm

mos-checksum-high:
	cp flash_hdr-template-high.asm flash_hdr.asm
	@echo Inserting CRC32 and MOS binary filesize in flash_hdr
	$(eval MYCRC32 = $$(shell crc32 MOS-versions/MOS.bin))
	$(eval MYCRC32_LOW = $$(shell echo $(MYCRC32) | cut -c 1-4))
	$(eval MYCRC32_HIGH = $$(shell echo $(MYCRC32) | cut -c 5-8))
	$(eval MYSIZE = $$(shell stat -f%z MOS-versions/MOS.bin))
	sed -i -e 's/FLASH_LEN/$(MYSIZE)/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_LOW/0$(MYCRC32_LOW)h/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_HIGH/0$(MYCRC32_HIGH)h/g' flash_hdr.asm

mos-checksum-high-old:
	cp flash_hdr-template-high.asm flash_hdr.asm
	@echo Inserting CRC32 and MOS binary filesize in flash_hdr
	$(eval MYCRC32 = $$(shell crc32 MOS-versions/MOS-01))
	$(eval MYCRC32_LOW = $$(shell echo $(MYCRC32) | cut -c 1-4))
	$(eval MYCRC32_HIGH = $$(shell echo $(MYCRC32) | cut -c 5-8))
	$(eval MYSIZE = $$(shell stat -f%z MOS-versions/MOS-01))
	sed -i -e 's/FLASH_LEN/$(MYSIZE)/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_LOW/0$(MYCRC32_LOW)h/g' flash_hdr.asm
	sed -i -e 's/FLASH_CRC_HIGH/0$(MYCRC32_HIGH)h/g' flash_hdr.asm

mos-upload: 
	python3 $(AGON-ZDI-LOAD) MOS-versions/MOS.hex 0 /dev/tty.usbserial-21130 500000

eos: eos-convert eos-checksum eos-upload

# convert base address 0x00000 to base address 0x50000
# then upload to AgonLight
eos-convert: ../../software/AgonElectronOS/Debug/AgonElectronOS.hex
	$(HEX2BIN) -i ../../software/AgonElectronOS/Debug/AgonElectronOS.hex -o EOS/AgonElectronOS.bin
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
	python3 $(AGON-ZDI-LOAD) EOS/AgonElectronOS.hex 0 /dev/tty.usbserial-21130 500000
	#python3 $(AGON-ZDI-LOAD) EOS/AgonElectronOS.hex 0 /dev/tty.usbserial-02B1CCD1 500000
	#python3 $(AGON-ZDI-LOAD) EOS/AgonElectronOS.hex 0 /dev/tty.usbserial-10 500000