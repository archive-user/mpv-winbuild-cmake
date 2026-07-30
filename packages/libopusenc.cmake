ExternalProject_Add(libopusenc
    DEPENDS
        opus
    GIT_REPOSITORY https://github.com/xiph/libopusenc.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR> && git clean -dfx && unset CC CXX && NOCONFIGURE=1 ./autogen.sh && CONF=1 ./configure
        CC=${TARGET_ARCH}-gcc
        CXX=${TARGET_ARCH}-g++
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-doc
        --disable-examples
        --disable-dependency-tracking
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE_INSTALL} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libopusenc)
cleanup(libopusenc install)
