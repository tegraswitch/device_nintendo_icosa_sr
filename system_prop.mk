# AV
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.media.avsync=true

# Charger
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.NV_ECO.IF.CHARGING=false

# Gamestreaming specific properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gamestream.display.optimize=1

# USB configfs
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.sys.usb.udc=700d0000.xudc \
    sys.usb.controller=700d0000.xudc

# Force sw compositing
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.tegra.composite.policy=composite-always \
    persist.vendor.tegra.compositor=surfaceflinger \
    persist.vendor.tegra.composite.range=Auto
