# Copyright (C) ARM Limited, 2009-2016. All rights reserved.
#
# This makefile is intended for use with GNU make
# This example is intended to be built with Linaro bare-metal GCC

TARGET=executable.axf

ARCH = armv8-a
CC = aarch64-elf-gcc
LD = aarch64-elf-gcc
C_SRC := $(wildcard *.c)
S_SRC := $(wildcard *.s)
OBJ_DIR = obj
OBJ_FILES := $(C_SRC:%.c=$(OBJ_DIR)/%.o) $(S_SRC:%.s=$(OBJ_DIR)/%.o)

# START - do not touch!
# Select build rules based on Windows or Unix
ifdef WINDIR
DONE=@if exist $(1) echo Build completed.
RM=if exist $(1) del /q $(1)
SHELL=$(WINDIR)\system32\cmd.exe
else
ifdef windir
DONE=@if exist $(1) echo Build completed.
RM=if exist $(1) del /q $(1)
SHELL=$(windir)\system32\cmd.exe
else
DONE=@if [ -f $(1) ]; then echo Build completed.; fi
RM=rm -f $(1)
endif
endif
# END - do not touch!

all: $(TARGET)
	$(call DONE,$(TARGET))
	
rebuild: clean all

clean:
	$(call RM,$(OBJ_DIR)/*.o)
	$(call RM,$(TARGET))
#	$(call RM,$(OBJ_DIR)/*.o)

$(OBJ_DIR):
	mkdir $@

# $@ is the filename of the target. For example, main.o
# $< is the filename of the prerequisite, in this case, for example, main.c
$(OBJ_DIR)/%.o : %.c | $(OBJ_DIR)
	$(CC) -c -march=$(ARCH) -g -O0 -o $@ $<

$(OBJ_DIR)/%.o : %.s | $(OBJ_DIR)
	$(CC) -c -march=$(ARCH) -g -O0 -o $@ $<

$(TARGET): $(OBJ_FILES)
	$(LD) --specs=aem-ve.specs -Wl,--build-id=none,-Map=linkmap.txt $(OBJ_FILES)  -o $@