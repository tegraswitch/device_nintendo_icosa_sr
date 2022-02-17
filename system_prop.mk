# Charger
PRODUCT_SYSTEM_PROPERTY_OVERRIDES += \
    persist.sys.NV_ECO.IF.CHARGING=false

# Force sw compositing
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.tegra.composite.policy=composite-always \
    persist.vendor.tegra.compositor=surfaceflinger \
    persist.vendor.tegra.composite.range=Auto
