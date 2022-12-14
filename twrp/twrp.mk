# Copyright (C) 2018 The LineageOS Project
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

TARGET_KERNEL_CONFIG := tegra_android_recovery_defconfig
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive
LZMA_RAMDISK_TARGETS := recovery

PRODUCT_COPY_FILES += \
    device/nintendo/icosa_sr/twrp/twrp.fstab.emmc:recovery/root/system/etc/twrp.fstab.emmc \
    device/nintendo/icosa_sr/twrp/twrp.fstab.sd:recovery/root/system/etc/twrp.fstab.sd

TW_THEME             := landscape_hdpi
TW_NO_SCREEN_TIMEOUT := true
TW_NO_SCREEN_BLANK   := true
TW_BRIGHTNESS_PATH   := /sys/class/backlight/pwm-backlight/brightness
TW_MAX_BRIGHTNESS    := 255
TW_INPUT_BLACKLIST   := "Nintendo Switch Left Joy-Con Serial\\x0aNintendo Switch Right Joy-Con Serial"
