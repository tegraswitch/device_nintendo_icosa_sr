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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE        := lkm_loader_sr
LOCAL_SRC_FILES     := lkm_loader_sr.sh
LOCAL_MODULE_SUFFIX := .sh
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := lkm_sr.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := lkm_sr.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.icosa_sr_common.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.icosa_sr_common.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := icosa_gatekeeper.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := icosa_gatekeeper.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init
include $(BUILD_PREBUILT)

# Goes on system due to needing `settings` and `svc`
include $(CLEAR_VARS)
LOCAL_MODULE        := wifi_reset
LOCAL_SRC_FILES     := wifi_reset.sh
LOCAL_MODULE_SUFFIX := .sh
LOCAL_INIT_RC       := wifi_reset.rc
LOCAL_MODULE_CLASS  := EXECUTABLES
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := jc_setup
LOCAL_SRC_FILES     := jc_setup.sh
LOCAL_MODULE_SUFFIX := .sh
LOCAL_INIT_RC       := icosa_jc.rc
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)
