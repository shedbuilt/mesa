#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_GALLIUM_DRIVERS='swrast'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[panfrost]}" ]; then
    SHED_PKG_LOCAL_GALLIUM_DRIVERS="panfrost,kmsro"
fi
# Build and Install
mkdir build &&
cd build &&
meson --prefix=/usr                    \
      --sysconfdir=/etc                \
      -Ddri-drivers=                   \
      -Dvulkan-drivers=                \
      -Dgallium-drivers=${SHED_PKG_LOCAL_GALLIUM_DRIVERS} \
      -Dlibunwind=false                \
      -Dplatforms=drm,wayland          \
      -Dgbm=true                       \
      -Dglx=disabled                      \
      ..                              &&
NINJAJOBS=$SHED_NUM_JOBS ninja &&
DESTDIR="$SHED_FAKE_ROOT" ninja install || exit 1
