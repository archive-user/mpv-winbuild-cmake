if(${TARGET_CPU} MATCHES "i686")
    set(disable_asm "--disable-asm")
endif()

ExternalProject_Add(davs2
    GIT_REPOSITORY https://github.com/saindriches/davs2.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CC=${TARGET_ARCH}-gcc CXX=${TARGET_ARCH}-g++ cd <SOURCE_DIR>/build/linux && ./configure
        --host=${TARGET_ARCH}
        --cross-prefix=${TARGET_CPU}-w64-mingw32-
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-cli
        --bit-depth=10
        ${disable_asm}
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux CC=${TARGET_ARCH}-gcc CXX=${TARGET_ARCH}-g++
    INSTALL_COMMAND ${MAKE} -C <SOURCE_DIR>/build/linux install CC=${TARGET_ARCH}-gcc CXX=${TARGET_ARCH}-g++
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(davs2)
cleanup(davs2 install)
