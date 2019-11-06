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
TARGET_SWITCH_VARIANT := erista

ifneq ($(PRODUCT_IS_ATV),true)

# System properties
include $(LOCAL_PATH)/system_prop.mk
endif

$(call inherit-product, device/nvidia/foster/device.mk)
include device/nvidia/shield-common/shield.mk

ifneq ($(PRODUCT_IS_ATV),true)

# Set product to tab
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

# Common Init
PRODUCT_PACKAGES += \
    init.icosa_sr_common.rc

# Bluetooth
ifeq ($(TARGET_TEGRA_BT),btlinux)
PRODUCT_PACKAGES += \
    BCM4356A3
endif

# Device Settings
PRODUCT_PACKAGES += \
    DeviceSettingsSR

# Joycons
PRODUCT_PACKAGES += \
    joycond \
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
    sensors.stmicro

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

# Shieldtech OSS override
PRODUCT_PACKAGES += \
    vendor.nvidia.hardware.shieldtech.inputflinger@2.0-service
