ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoUnwantedLSStuff
NoUnwantedLSStuff_FILES = Tweak.xm
NoUnwantedLSStuff_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
