#
# Copyright (C) 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_TEGRA_BT ?= btlinux
TARGET_SHIELDTECH_INPUTFLINGER := switchroot

include device/nvidia/shield-common/shield.mk

$(call inherit-product, device/nvidia/foster/device.mk)

ifneq ($(PRODUCT_IS_ATV),true)
# System properties
include $(LOCAL_PATH)/system_prop.mk

PRODUCT_CHARACTERISTICS := tablet

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    device/nintendo/icosa_sr/overlay/tablet

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml
endif

# Bluetooth
ifeq ($(TARGET_TEGRA_BT),btlinux)
PRODUCT_PACKAGES += \
    icosa_bt.rc \
    BCM4356A3
endif

# Device Settings
PRODUCT_PACKAGES += \
    DeviceSettingsSR

# Joycon setup
PRODUCT_PACKAGES += \
    jc_setup

# Kernel
ifeq ($(TARGET_PREBUILT_KERNEL),)
PRODUCT_PACKAGES += \
    cypress-fmac-upstream
endif

# STMicroElectronics IMU
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-service \
    android.hardware.sensors@1.0-impl \
    sensors.stmicro \
    icosa_sensors.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml

# Loadable kernel modules
PRODUCT_PACKAGES += \
    lkm_sr.rc \
    lkm_loader_sr

# Icosa WiFi reset script
PRODUCT_PACKAGES += \
    wifi_reset
