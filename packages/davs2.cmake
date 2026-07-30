if(${TARGET_CPU} MATCHES "i686")
    set(disable_asm "--disable-asm")
endif()

# sed script to bypass endian test failure during cross-compilation
# written to a file to avoid shell eval quoting issues with $ and #
set(DAVS2_PATCH ${CMAKE_CURRENT_BINARY_DIR}/davs2-prefix/src/patch_configure.sh)
file(WRITE ${DAVS2_PATCH}
"#!/bin/bash
sed -i 's@exit 1$@true # patched for cross-compile@' configure
")

ExternalProject_Add(davs2
    GIT_REPOSITORY https://github.com/pkuvcl/davs2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    PATCH_COMMAND chmod 755 ${DAVS2_PATCH} && cd <SOURCE_DIR>/build/linux && ${DAVS2_PATCH}
    CONFIGURE_COMMAND ${EXEC} cd <SOURCE_DIR>/build/linux && CONF=1 CC=${TARGET_ARCH}-g++ ./configure
        --host=${TARGET_ARCH}
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-cli
        ${disable_asm}
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux CC=${TARGET_ARCH}-g++ AR=${TARGET_ARCH}-ar RANLIB=${TARGET_ARCH}-ranlib
    INSTALL_COMMAND ${MAKE_INSTALL} -C <SOURCE_DIR>/build/linux install CC=${TARGET_ARCH}-g++
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(davs2)
cleanup(davs2 install)