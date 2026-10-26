TARGET := iphone:clang:latest:16.0
ARCHS := arm64
FINALPACKAGE := 1
GO_EASY_ON_ME := 1
KEEP_LOGOS_INTERMEDIATES := 1

YTM_VERSION := $(or $(shell cat ../version.txt 2>/dev/null),1.0.0)
PACKAGE_VERSION := $(subst -,~,$(YTM_VERSION))

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := YTMVitrine

YTMVitrine_FILES := $(shell find Sources -name '*.m' -o -name '*.x' -o -name '*.mm' | sort)
YTMVitrine_CFLAGS := -fobjc-arc -ISources -ISources/Core -ISources/Hooks -ISources/Redesigned -ISources/Settings -DYTM_VERSION=\"$(YTM_VERSION)\" -Wno-unused-variable -Wno-unused-function -Wno-deprecated-declarations -Wno-unused-property-ivar
YTMVitrine_FRAMEWORKS := UIKit QuartzCore MediaPlayer CoreImage AudioToolbox AVFoundation CoreHaptics Accelerate CoreMotion CoreText
YTMVitrine_LIBRARIES := z
YTMVitrine_LOGOS_DEFAULT_GENERATOR := internal

include $(THEOS_MAKE_PATH)/tweak.mk
