include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoUnwantedLSStuff
NoUnwantedLSStuff_FILES = NULSRootListController.m
NoUnwantedLSStuff_INSTALL_PATH = /Library/PreferenceBundles
NoUnwantedLSStuff_FRAMEWORKS = UIKit
NoUnwantedLSStuff_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoUnwantedLSStuff.plist$(ECHO_END)
