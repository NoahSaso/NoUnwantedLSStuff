ARCHS = armv7 arm64

include theos/makefiles/common.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp NoUnwantedLSStuff.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoUnwantedLSStuff.plist$(ECHO_END)
	$(ECHO_NOTHING)cp *.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)
