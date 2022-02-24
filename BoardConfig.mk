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

BOARD_FLASH_BLOCK_SIZE             := 4096
BOARD_BOOTIMAGE_PARTITION_SIZE     := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_PARTITION_SIZE    := 734003200
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10099646976
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 2147483648
BOARD_VENDORIMAGE_PARTITION_SIZE   := 1073741824
TARGET_USERIMAGES_USE_EXT4         := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR             := vendor
BOARD_BUILD_SYSTEM_ROOT_IMAGE      := true

# Assert
TARGET_OTA_ASSERT_DEVICE := icosa

# Bootloader versions
TARGET_BOARD_INFO_FILE := device/nintendo/icosa_sr/board-info.txt

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/nintendo/icosa_sr/releasetools

# Manifest
DEVICE_MANIFEST_FILE += device/nintendo/icosa_sr/manifest.xml

# Kernel
ifneq ($(TARGET_PREBUILT_KERNEL),)
BOARD_VENDOR_KERNEL_MODULES += $(wildcard $(dir $(TARGET_PREBUILT_KERNEL))/*.ko)
endif
KERNEL_TOOLCHAIN              := $(shell pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu-6.4.1/bin
KERNEL_TOOLCHAIN_PREFIX       := aarch64-linux-gnu-
TARGET_KERNEL_SOURCE 	      := kernel/nvidia/kernel-4.9-icosa
TARGET_KERNEL_CONFIG          := tegra_android_defconfig
TARGET_KERNEL_RECOVERY_CONFIG := tegra_android_recovery_defconfig
BOARD_KERNEL_IMAGE_NAME       := Image.gz

# Recovery
TARGET_RECOVERY_FSTAB        := device/nintendo/icosa_sr/initfiles/fstab.icosa_recovery
TARGET_RECOVERY_UPDATER_LIBS := librecoveryupdater_tegra
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Security Patch Level
VENDOR_SECURITY_PATCH := 2021-04-05

# IIO Sensor Defconfig
BOARD_SENSORS_STMICRO_IIO_DEFCONFIG := device/nintendo/icosa_sr/sensors/sensors_icosa_defconfig

# Treble
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_VNDK_VERSION                     := current
PRODUCT_FULL_TREBLE_OVERRIDE           := true

# TWRP Support
ifeq ($(WITH_TWRP),true)
include device/nintendo/icosa_sr/twrp/twrp.mk
endif

include device/nvidia/t210-common/BoardConfigCommon.mk
