if(${TARGET_CPU} MATCHES "i686")
    set(disable_asm "--disable-asm")
endif()

# davs2's configure treats CC as the C++ compiler (default: ${cross_prefix}g++).
# Its endian test fails when cross-compiling - it tries to run strings on
# a cross-compiled binary and may not find the expected patterns.
# Workaround: sed-patch the configure to skip the endian test (Windows x86/x64
# are always little-endian), and use CC=g++ throughout.
set(DAVS2_CONFIGURE_SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/davs2-configure.sh)
file(WRITE ${DAVS2_CONFIGURE_SCRIPT}
"#!/bin/bash
set -e
cd ${SOURCE_LOCATION}/build/linux

# Endian test is broken for cross-compilation. Windows is always little-endian.
# Change 'exit 1' after 'endian test failed' to a no-op so configure continues.
sed -i '/endian test failed/,/exit 1/s/exit 1/true # patched for cross-compile/' configure

export CC=${TARGET_ARCH}-g++
export CFLAGS=\"-static-libgcc -static-libstdc++\"
./configure \\
    --host=${TARGET_ARCH} \\
    --cross-prefix=${TARGET_ARCH}- \\
    --prefix=${MINGW_INSTALL_PREFIX} \\
    --disable-cli \\
    --bit-depth=10 \\
    ${disable_asm}
")
file(CHMOD ${DAVS2_CONFIGURE_SCRIPT}
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# davs2 only uses CC (not CXX) in its Makefile, and CC must be g++
ExternalProject_Add(davs2
    GIT_REPOSITORY https://github.com/saindriches/davs2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} ${DAVS2_CONFIGURE_SCRIPT}
    BUILD_COMMAND ${EXEC} make -C <SOURCE_DIR>/build/linux CC=${TARGET_ARCH}-g++ AR=${TARGET_ARCH}-ar
    INSTALL_COMMAND ${EXEC} make -C <SOURCE_DIR>/build/linux install CC=${TARGET_ARCH}-g++
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(davs2)
cleanup(davs2 install)
