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

TARGET_SHIELDTECH_INPUTFLINGER := switchroot
TARGET_SWITCH_VARIANT ?= erista

# Common system properties
include $(LOCAL_PATH)/system_prop.mk

include device/nvidia/shield-common/shield.mk

TARGET_REFERENCE_DEVICE ?= icosa
TARGET_TEGRA_VARIANT    ?= common

TARGET_TEGRA_AUDIO    ?= nvaudio
TARGET_TEGRA_CAMERA   ?= nvcamera
TARGET_TEGRA_CEC      ?= nvhdmi
TARGET_TEGRA_KERNEL   ?= 49
TARGET_TEGRA_KEYSTORE ?= nvkeystore
TARGET_TEGRA_MEMTRACK ?= nvmemtrack
TARGET_TEGRA_OMX      ?= nvmm
TARGET_TEGRA_PHS      ?= nvphs
TARGET_TEGRA_POWER    ?= aosp
TARGET_TEGRA_WIDEVINE ?= true
TARGET_TEGRA_WIFI     ?= bcm
TARGET_TEGRA_WIREGUARD ?= compat
TARGET_TEGRA_BT ?= btlinux

include device/nvidia/t210-common/t210.mk

PRODUCT_AAPT_PREF_CONFIG := hdpi
TARGET_SCREEN_HEIGHT     := 1280
TARGET_SCREEN_WIDTH      := 720
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi mdpi ldpi

$(call inherit-product, frameworks/native/build/tablet-7in-xhdpi-2048-dalvik-heap.mk)

$(call inherit-product, device/nintendo/icosa_sr/vendor/icosa-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    device/nintendo/icosa_sr/overlay/common

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += device/nintendo/icosa_sr

# Init related
PRODUCT_PACKAGES += \
    fstab.icosa \
    fstab.icosa_emmc \
    init.icosa.rc \
    init.icosa_common.rc \
    init.icosa_emmc.rc \
    init.recovery.icosa.rc \
    init.recovery.icosa_emmc.rc \
    power.icosa.rc \
    power.icosa_emmc.rc

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

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

# Audio
ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
PRODUCT_PACKAGES += \
    audio_effects.xml \
    audio_policy_configuration.xml \
    icosa_nvaudio_conf.xml \
    icosa_emmc_nvaudio_conf.xml \
    nvaudio_conf.xml \
    nvaudio_fx.xml
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

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Light
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service-nvidia

# Loadable kernel modules
PRODUCT_PACKAGES += \
    lkm_loader \
    init.lkm.rc

# Media config
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_ODM)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_ODM)/etc/media_codecs_google_video.xml
PRODUCT_PACKAGES += \
    media_codecs.xml
ifneq (,$(findstring nvmm,$(TARGET_TEGRA_OMX)))
PRODUCT_PACKAGES += \
    media_codecs_performance.xml \
    media_profiles_V1_0.xml
endif

# NVIDIA specific permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/com.nvidia.feature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nvidia.feature.xml

# PHS
ifeq ($(TARGET_TEGRA_PHS),nvphs)
PRODUCT_PACKAGES += \
    nvphsd.conf
endif

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-service-nvidia \
    thermalhal.icosa.xml \
    thermalhal.icosa_emmc.xml

# Trust HAL
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# WiFi
PRODUCT_PACKAGES += \
    wifi_reset \
    wifi_scan_config.conf

# Shieldtech OSS override
PRODUCT_PACKAGES += \
    vendor.nvidia.hardware.shieldtech.inputflinger@2.0-service
