#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_GALLIUM_DRIVERS='swrast'
SHED_PKG_LOCAL_PLATFORMS='drm,surfaceless'
# Configure
if [ -n "${SHED_PKG_LOCAL_OPTIONS[lima]}" ]; then
    SHED_PKG_LOCAL_GALLIUM_DRIVERS="lima,kmsro,swrast"
elif [ -n "${SHED_PKG_LOCAL_OPTIONS[panfrost]}" ]; then
    SHED_PKG_LOCAL_GALLIUM_DRIVERS="panfrost,kmsro,swrast"
fi
if [ -n "${SHED_PKG_LOCAL_OPTIONS[wayland]}" ]; then
    SHED_PKG_LOCAL_PLATFORMS='drm,surfaceless,wayland'
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
      -Dplatforms=${SHED_PKG_LOCAL_PLATFORMS} \
      -Dgbm=true                       \
      -Degl=true                       \
      -Dllvm=false                     \
      -Dglx=disabled                   \
      ..                              &&
NINJAJOBS=$SHED_NUM_JOBS ninja &&
DESTDIR="$SHED_FAKE_ROOT" ninja install || exit 1
