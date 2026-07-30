get_property(src_graphengine TARGET graphengine PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(libzimg
    DEPENDS
        graphengine
    GIT_REPOSITORY https://github.com/sekrit-twc/zimg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR> && rm -rf graphengine && ln -sf ${src_graphengine} graphengine && git clean -dfx -e graphengine && sed -i "s/Windows.h/windows.h/g" src/zimg/common/arm/cpuinfo_arm.cpp && unset CC CXX && NOCONFIGURE=1 ./autogen.sh && CONF=1 ./configure
        CC=${TARGET_ARCH}-gcc
        CXX=${TARGET_ARCH}-g++
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-shared
        --disable-dependency-tracking
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE_INSTALL} install
            COMMAND bash -c "git -C ${src_graphengine} clean -dfx"
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libzimg)
cleanup(libzimg install)
