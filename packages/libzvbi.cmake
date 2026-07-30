ExternalProject_Add(libzvbi
    DEPENDS
        libpng
        libiconv
    GIT_REPOSITORY https://github.com/zapping-vbi/zvbi.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR> && git clean -dfx && unset CC CXX && NOCONFIGURE=1 ./autogen.sh && CONF=1 ./configure
        CC=${TARGET_ARCH}-gcc
        CXX=${TARGET_ARCH}-g++
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --enable-static
        --with-pic
        --without-doxygen
        --without-x
        --disable-dvb
        --disable-bktr
        --disable-nls
        --disable-proxy
        --disable-examples
        --disable-tests
        --disable-dependency-tracking
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE_INSTALL} install
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libzvbi)
cleanup(libzvbi install)
