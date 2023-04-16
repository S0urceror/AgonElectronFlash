;************************************************************************
;*    eZ80F92.inc
;*
;*		eZ80F92 Registers
;*
;************************************************************************
;* Start eZ80F92 Include file

;* TIMER registers

TMR0_CTL:	.equ 80h
TMR0_DR_L:	.equ 81h
TMR0_RR_L:	.equ 81h
TMR0_DR_H:	.equ 82h
TMR0_RR_H:	.equ 82h
TMR1_CTL:	.equ 83h
TMR1_DR_L:	.equ 84h
TMR1_RR_L:	.equ 84h
TMR1_DR_H:	.equ 85h
TMR1_RR_H:	.equ 85h
TMR2_CTL:	.equ 86h
TMR2_DR_L:	.equ 87h
TMR2_RR_L:	.equ 87h
TMR2_DR_H:	.equ 88h
TMR2_RR_H:	.equ 88h
TMR3_CTL:	.equ 89h
TMR3_DR_L:	.equ 8ah
TMR3_RR_L:	.equ 8ah
TMR3_DR_H:	.equ 8bh
TMR3_RR_H:	.equ 8bh
TMR4_CTL:	.equ 8ch
TMR4_DR_L:	.equ 8dh
TMR4_RR_L:	.equ 8dh
TMR4_DR_H:	.equ 8eh
TMR4_RR_H:	.equ 8eh
TMR5_CTL:	.equ 8fh
TMR5_DR_L:	.equ 90h
TMR5_RR_L:	.equ 90h
TMR5_DR_H:	.equ 91h
TMR5_RR_H:	.equ 91h
TMR_ISS:	.equ 92h

;* WDT Registers

WDT_CTL:	.equ 93h
WDT_RR:	.equ 94h


;* PORT Registers

PB_DR:		.equ 09Ah
PB_DDR:		.equ 09Bh
PB_ALT1:	.equ 09Ch
PB_ALT2:	.equ 09Dh
PC_DR:		.equ 09Eh
PC_DDR:		.equ 09Fh
PC_ALT1:	.equ 0A0h
PC_ALT2:	.equ 0A1h
PD_DR:		.equ 0A2h
PD_DDR:		.equ 0A3h
PD_ALT1:	.equ 0A4h
PD_ALT2:	.equ 0A5h

;* Chip Select
CS0_LBR:	.equ 0A8h
CS0_UBR:	.equ 0A9h
CS0_CTL:	.equ 0AAh
CS1_LBR:	.equ 0ABh
CS1_UBR:	.equ 0ACh
CS1_CTL:	.equ 0ADh
CS2_LBR:	.equ 0AEh
CS2_UBR:	.equ 0AFh
CS2_CTL:	.equ 0B0h
CS3_LBR:	.equ 0B1h
CS3_UBR:	.equ 0B2h
CS3_CTL:	.equ 0B3h

;* RAMCTL Registers
RAM_CTL0:	.equ 0B4h
RAM_CTL:	.equ 0B4h
RAM_ADDR_U:	.equ 0B5h

;* SPI Registers

SPI_BRG_L:	.equ 0B8h
SPI_BRG_H:	.equ 0B9h
SPI_CTL:	.equ 0BAh
SPI_SR:		.equ 0BBh
SPI_RBR:	.equ 0BCh
SPI_TSR:	.equ 0BCh

;* UART0 Registers

UART0_RBR:	.equ 0C0h
UART0_THR:	.equ 0C0h
UART0_BRG_L:	.equ 0C0h
UART0_IER:	.equ 0C1h
UART0_BRG_H:	.equ 0C1h
UART0_IIR:	.equ 0C2h
UART0_FCTL:	.equ 0C2h
UART0_LCTL:	.equ 0C3h
UART0_MCTL:	.equ 0C4h
UART0_LSR:	.equ 0C5h
UART0_MSR:	.equ 0C6h
UART0_SPR:	.equ 0C7h

;* I2C Registers

I2C_SAR:	.equ 0C8h
I2C_XSAR:	.equ 0C9h
I2C_DR:		.equ 0CAh
I2C_CTL:	.equ 0CBh
I2C_SR:		.equ 0CCh
I2C_CCR:	.equ 0CCh
I2C_SRR:	.equ 0CDh

;* UART1 Registers

UART1_RBR:	.equ 0D0h
UART1_THR:	.equ 0D0h
UART1_BRG_L:	.equ 0D0h
UART1_IER:	.equ 0D1h
UART1_BRG_H:	.equ 0D1h
UART1_IIR:	.equ 0D2h
UART1_FCTL:	.equ 0D2h
UART1_LCTL:	.equ 0D3h
UART1_MCTL:	.equ 0D4h
UART1_LSR:	.equ 0D5h
UART1_MSR:	.equ 0D6h
UART1_SPR:	.equ 0D7h

;* IR Registers

IR_CTL:		.equ   0BFh

;* CLK Registers

CLK_PPD1:	.equ   0DBh
CLK_PPD2:	.equ   0DCh

;* RTC Registers

RTC_SEC:	.equ 0E0h
RTC_MIN:	.equ 0E1h
RTC_HRS:	.equ 0E2h
RTC_DOW:	.equ 0E3h
RTC_DOM:	.equ 0E4h
RTC_MON:	.equ 0E5h
RTC_YR:		.equ 0E6h
RTC_CEN:	.equ 0E7h
RTC_ASEC:	.equ 0E8h
RTC_AMIN:	.equ 0E9h
RTC_AHRS:	.equ 0EAh
RTC_ADOW:	.equ 0EBh
RTC_ACTRL:	.equ 0ECh
RTC_CTRL:	.equ 0EDh

;* CSBMC Registers

CS0_BMC:	.equ 0F0h
CS1_BMC:	.equ 0F1h
CS2_BMC:	.equ 0F2h
CS3_BMC:	.equ 0F3h

;* FLASH Registers

FLASH_KEY:	.equ 0F5h
FLASH_DATA:	.equ 0F6h
FLASH_ADDR_U:	.equ 0F7h
FLASH_CTRL:	.equ 0F8h
FLASH_FDIV:	.equ 0F9h
FLASH_PROT:	.equ 0FAh
FLASH_IRQ:	.equ 0FBh
FLASH_PAGE:	.equ 0FCh
FLASH_ROW:	.equ 0FDh
FLASH_COL:	.equ 0FEh
FLASH_PGCTL:	.equ 0FFh

;* End eZ80F92 inc file 
