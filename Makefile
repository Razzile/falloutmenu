THEOS_DEVICE_IP = 192.168.0.5
TARGET = iphone:latest
ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = FalloutMenu
FalloutMenu_FILES = Tweak.xm $(wildcard ./*.mm ./*.cpp)
FalloutMenu_FRAMEWORKS = UIKit QuartzCore CoreGraphics
FalloutMenu_CFLAGS += -stdlib=libc++ -std=c++11

include $(THEOS_MAKE_PATH)/tweak.mk
