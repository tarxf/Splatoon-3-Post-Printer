#
#             LUFA Library
#     Copyright (C) Dean Camera, 2014.
#
#  dean [at] fourwalledcubicle [dot] com
#           www.lufa-lib.org
#
# --------------------------------------
#         LUFA Project Makefile.
# --------------------------------------

# Run "make help" for target help.

MCU_TEENSY   = at90usb1286
MCU_UNO      = atmega16u2
MCU_MICRO    = atmega32u4
# set the Teensy controller as default.
MCU         ?= $(MCU_TEENSY)
ARCH         = AVR8
F_CPU        = 16000000
F_USB        = $(F_CPU)
OPTIMIZATION = s
TARGET       = Joystick
SRC          = $(TARGET).c Descriptors.c image.c $(LUFA_SRC_USB)
LUFA_PATH    = ../LUFA/LUFA
CC_FLAGS     = -DUSE_LUFA_CONFIG_HEADER -IConfig/
LD_FLAGS     =
IMG_SRC_DEF  = splatoonpattern.png
IMG_SRC     ?= post.png

# Default target
all: image

# Include LUFA build script makefiles
include $(LUFA_PATH)/Build/lufa_core.mk
include $(LUFA_PATH)/Build/lufa_sources.mk
include $(LUFA_PATH)/Build/lufa_build.mk
include $(LUFA_PATH)/Build/lufa_cppcheck.mk
include $(LUFA_PATH)/Build/lufa_doxygen.mk
include $(LUFA_PATH)/Build/lufa_dfu.mk
include $(LUFA_PATH)/Build/lufa_hid.mk
include $(LUFA_PATH)/Build/lufa_avrdude.mk
include $(LUFA_PATH)/Build/lufa_atprogram.mk

# Target for LED/buzzer to alert when print is done
with-alert: all
with-alert: CC_FLAGS += -DALERT_WHEN_DONE

teensy:
	MCU=$(MCU_TEENSY) make all
uno:
	MCU=$(MCU_UNO) make all
micro:
	MCU=$(MCU_MICRO) make all

image: $(IMG_SRC)
	python png2c.py $(IMG_SRC)

$(IMG_SRC):
	@echo "using default image source"
	cp $(IMG_SRC_DEF) $(IMG_SRC)
