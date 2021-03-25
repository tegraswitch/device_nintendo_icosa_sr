/*
   Copyright (c) 2013, The Linux Foundation. All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "init_tegra.h"

#include <map>

void vendor_set_usb_product_ids(tegra_init *ti)
{
	std::map<std::string, std::string> mDeviceUsbIds;

	mDeviceUsbIds["ro.vendor.nv.usb.vid"]           = "057E";
	mDeviceUsbIds["ro.vendor.nv.usb.pid.mtp"]       = "2000";
	mDeviceUsbIds["ro.vendor.nv.usb.pid.mtp.adb"]   = "2000";
	mDeviceUsbIds["ro.vendor.nv.usb.pid.ptp"]       = "2000";
	mDeviceUsbIds["ro.vendor.nv.usb.pid.ptp.adb"]   = "2000";
	mDeviceUsbIds["ro.vendor.nv.usb.pid.rndis"]     = "2000";
	mDeviceUsbIds["ro.vendor.nv.usb.pid.rndis.adb"] = "2000";

	for (auto const& id : mDeviceUsbIds)
		ti->property_set(id.first, id.second);
}

void vendor_load_properties()
{
	//                                              device   name          model    id  sku boot device type                 api dpi
	std::vector<tegra_init::devices> devices = { { "icosa", "icosa_emmc", "Switch", 20,  1, tegra_init::boot_dev_type::EMMC, 27, 192 },
	                                             { "icosa", "icosa",      "Switch", 20,  0, tegra_init::boot_dev_type::SD,   27, 192 } };
	tegra_init::build_version tav = { "9", "PPR1.180610.011", "4199485_1739.5219" };
	std::vector<std::string> parts = { "APP", "CAC", "LNX", "SOS", "UDA", "vendor", "DTB" };

	tegra_init ti(devices);

	ti.set_properties();
	ti.set_fingerprints(tav);

	if (!ti.vendor_context() && !ti.recovery_context() &&
	    ti.property_get("ro.build.characteristics") == "tv")
		ti.property_set("ro.sf.lcd_density", "192");

	if (ti.recovery_context()) {
		ti.recovery_links(parts);
		ti.property_set("ro.product.vendor.model", ti.property_get("ro.product.model"));
		ti.property_set("ro.product.vendor.manufacturer", ti.property_get("ro.product.manufacturer"));
	}

	if (ti.vendor_context() || ti.recovery_context())
		vendor_set_usb_product_ids(&ti);
}
