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

include device/nvidia/foster/BoardConfig.mk

# Assert
TARGET_OTA_ASSERT_DEVICE := icosa

# Bootloader versions
TARGET_BOARD_INFO_FILE := device/nintendo/icosa_sr/board-info.txt

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/nintendo/icosa_sr/releasetools

# Manifest
DEVICE_MANIFEST_FILE += device/nintendo/icosa_sr/manifest.xml

# Kernel
ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_KERNEL_SOURCE := kernel/nvidia/linux-4.9_icosa/kernel/kernel-4.9
endif

# Partitions
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648

# IIO Sensor Defconfig
BOARD_SENSORS_STMICRO_IIO_DEFCONFIG := device/nintendo/icosa_sr/sensors/sensors_icosa_defconfig

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += device/nintendo/icosa_sr
