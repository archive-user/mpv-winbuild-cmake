if(${TARGET_CPU} MATCHES "i686")
    set(disable_asm "--disable-asm")
endif()

# Generate a configure wrapper script to avoid CMake argument splitting issues
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/davs2-configure.sh
"#!/bin/bash
set -e
cd ${SOURCE_LOCATION}/build/linux
export CC=${TARGET_ARCH}-gcc
export CXX=${TARGET_ARCH}-g++
./configure \
    --host=${TARGET_ARCH} \
    --cross-prefix=${TARGET_ARCH}- \
    --prefix=${MINGW_INSTALL_PREFIX} \
    --disable-cli \
    --bit-depth=10 \
    ${disable_asm}
")
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/davs2-configure.sh
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

ExternalProject_Add(davs2
    GIT_REPOSITORY https://github.com/saindriches/davs2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} ${CMAKE_CURRENT_BINARY_DIR}/davs2-configure.sh
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux CC=${TARGET_ARCH}-gcc CXX=${TARGET_ARCH}-g++
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux install CC=${TARGET_ARCH}-gcc CXX=${TARGET_ARCH}-g++
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(davs2)
cleanup(davs2 install)
