ExternalProject_Add(x264
    GIT_REPOSITORY https://code.videolan.org/videolan/x264.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --enable-static
        --disable-cli
        --disable-swscale
        --disable-lavf
        --disable-ffms
        --disable-gpac
        --disable-lsmash
        --extra-cflags="-m64 -mstackrealign -Wno-error"
        --extra-ldflags="-Wl,--no-undefined"
    BUILD_COMMAND ${EXEC} LTO=1 make -j${MAKEJOBS}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)