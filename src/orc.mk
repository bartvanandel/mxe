# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := orc
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/orc.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.31
$(PKG)_CHECKSUM := a0ab5f10a6a9ae7c3a6b4218246564c3bf00d657cbdf587e6d34ec3ef0616075
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

$(PKG)_UPDATE = $(subst gstreamer/refs,orc/refs,$(gstreamer_UPDATE))

# Commands extracted from on CI config at https://gitlab.freedesktop.org/orc/-/blob/master/.gitlab-ci.yml
#    meson '$(SOURCE_DIR)/' \
#        --cross-file $(PKG).win-$(TARGET).ini \
#        --default-library $(if $(BUILD_SHARED), shared, static) \
#        --werror \
#        '$(BUILD_DIR)/'
define $(PKG)_BUILD
    $(TARGET)-meson \
        '$(SOURCE_DIR)/' \
        '$(BUILD_DIR)/'
    meson configure \
        "-Dorc-test=disabled" \
        "-Dbenchmarks=disabled" \
        "-Dexamples=disabled" \
        "-Dgtk_doc=disabled" \
        "-Dtests=disabled" \
        "-Dtools=enabled" \
        "$(BUILD_DIR)"
    ninja -C "$(BUILD_DIR)"
    ninja -C "$(BUILD_DIR)" install

#    $(INSTALL) '$(1)'/*.exe '$(PREFIX)'/$(TARGET)/lib
#    $(INSTALL) '$(1)'/*.exe '$(PREFIX)'/$(TARGET)/bin/orc
endef
