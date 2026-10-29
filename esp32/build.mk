PROG        ?= firmware
ARCH        ?= esp32
TARGET      ?= xtensa-freestanding-none
MDK         ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)
ESPFLASH    ?= espflash
BUILDFLAGS  ?= -mcpu=xtensa -target $(TARGET) -O ReleaseSmall $(EXTRA_BUILDFLAGS)
LINKFLAGS   ?= -T$(MDK)/$(ARCH)/link.ld -nostdlib -nostartfiles -Wl,--gc-sections $(EXTRA_LINKFLAGS)
CWD         ?= $(realpath $(CURDIR))
FLASH_ADDR  ?= 0x1000  # 2nd stage bootloader flash offset
EXTENSA_ELF ?= $(ESP32_ELF_BIN)/
TOOLCHAIN   ?= $(ESP32_ELF_BIN)xtensa-esp32-elf
SRCS        ?= $(MDK)/$(ARCH)/boot.c $(SOURCES)

build: $(PROG).bin

$(PROG).o: $(SRCS)
	zig build-obj -femit-bin=$@ $(BUILDFLAGS) -O ReleaseSmall $(SRCS)

$(PROG).elf: $(SRCS)
	$(TOOLCHAIN)-gcc $(CFLAGS) $(SRCS) $(LINKFLAGS) -o $@
#	$(TOOLCHAIN)-size $@

$(PROG).bin: $(PROG).elf $(ESPUTIL)
	$(ESPUTIL) mkbin $(PROG).elf $@

flash: $(PROG).bin $(ESPUTIL)
	$(ESPUTIL) flash $(FLASH_ADDR) $(PROG).bin

monitor: $(ESPUTIL)
	$(ESPUTIL) monitor

$(MDK)/esputil/esputil.c:
	git submodule update --init --recursive

$(ESPUTIL): $(MDK)/esputil/esputil.c
	make -C $(MDK)/esputil esputil

clean:
	@rm -rf *.{bin,elf,map,lst,tgz,zip,hex} $(PROG)*
