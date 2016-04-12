ARCHS = armv7 arm64
TARGET = :clang

include $(THEOS)/makefiles/common.mk
TARGET_LIB_EXT = `-`

TWEAK_NAME = Weather
Weather_FILES = $(wildcard *.xm)
Weather_FRAMEWORKS = UIKit
Weather_INSTALL_PATH = /var/mobile/Library/Lydia/Views/com.apple.weather/

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather$(ECHO_END)
	$(ECHO_NOTHING)cp Info.plist $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/$(ECHO_END)

	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp Preferences/Root.plist $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/Preferences/$(ECHO_END)

	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/Assets$(ECHO_END)
	$(ECHO_NOTHING)cp Assets/*.png $(THEOS_STAGING_DIR)/var/mobile/Library/Lydia/Views/com.apple.weather/Assets/$(ECHO_END)



after-stage::
	find $(FW_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

after-install::
	install.exec "killall -9 SpringBoard"
