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

# Inherit some common lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Inherit device configuration for icosa_sr.
include device/nvidia/foster/lineage.mk
TARGET_INIT_VENDOR_LIB := //device/nintendo/icosa_sr:libinit_icosa_sr
$(call inherit-product, device/nintendo/icosa_sr/full_icosa_sr.mk)

PRODUCT_NAME := lineage_icosa_sr
PRODUCT_DEVICE := icosa_sr
