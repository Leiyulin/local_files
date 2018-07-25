idndef CROSS_COMPILE
CROSS_COMPILE = mips64-linux-gnu-
endif

CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = inst_rom.o

export CROSS_COMPILE

# for annotation

all: inst_rom.o

%.o: %.S
	$(CC) $< -o $@
