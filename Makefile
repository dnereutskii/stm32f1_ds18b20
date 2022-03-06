# path to STM32F103 standard peripheral library
# STD_PERIPH_LIBS ?= ./STM32F10x_StdPeriph_Lib_V3.5.0/

# list of source files
SOURCES  = core/main.c
SOURCES += cmsis/src/system_stm32f1xx.c
SOURCES += core/indicator/indicator.c
SOURCES += core/indicator/gpio/indicator_gpio.c
SOURCES += core/indicator/timer/indicator_timer.c

# add startup file to build
SOURCES += ./startup/startup_stm32f103xb.s

# name for output binary files
PROJECT ?= test

# compiler, objcopy (should be in PATH)
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# path to st-flash (or should be specified in PATH)
# ST_FLASH ?= st-flash
ST_FLASH ?= ST-LINK_CLI
ST_INFO = st-info

# specify compiler flags
CFLAGS  = -g -O0 -Wall
CFLAGS += -T ./startup/STM32F103XB_FLASH.ld
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m3 -mthumb-interwork
# CFLAGS += -mfloat-abi=hard #-mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F10X_MD
CFLAGS += -Wl,--gc-sections
CFLAGS += -I.
CFLAGS += -I ./cmsis/inc/
CFLAGS += -I ./core/indicator/
CFLAGS += -I ./core/indicator/gpio
CFLAGS += -I ./core/indicator/timer

OBJS = $(SOURCES:.c=.o)

all: $(PROJECT).elf size

# compile
$(PROJECT).elf: $(SOURCES)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJECT).elf $(PROJECT).hex
	$(OBJCOPY) -O binary $(PROJECT).elf $(PROJECT).bin

# remove binary files
clean:
	rm -f *.o *.elf *.hex *.bin

# flash
burn:
	$(ST_FLASH) -c SWD -P $(PROJECT).hex 0x8000000 -Rst
# $(ST_FLASH) write $(PROJECT).bin 0x8000000

# size info
size:
	@$(SIZE) -B -d ./$(PROJECT).elf

# MCU info
info:
	@$(ST_INFO) --probe

