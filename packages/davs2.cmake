function(build_davs2 TARGET_CPU TARGET_ARCH MINGW_INSTALL_PREFIX)
    set(SYSROOT "/usr/${TARGET_ARCH}")
    
    if(${TARGET_CPU} MATCHES "i686")
        set(disable_asm "--disable-asm")
    endif()
    
    ExternalProject_Add(davs2
        GIT_REPOSITORY https://github.com/saindiches/davs2.git
        SOURCE_DIR ${SOURCE_LOCATION}
        GIT_CLONE_FLAGS "--filter=tree:0"
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND 
            ${EXEC} bash -c "
                cd ${SOURCE_LOCATION}/build/linux && 
                CC=${TARGET_ARCH}-gcc 
                CXX=${TARGET_ARCH}-g++ 
                CPPFLAGS='-I${SYSROOT}/include -I${MINGW_INSTALL_PREFIX}/include' 
                LDFLAGS='-L${SYSROOT}/lib -L${MINGW_INSTALL_PREFIX}/lib' 
                ./configure 
                    --host=${TARGET_ARCH} 
                    --cross-prefix=${TARGET_CPU}-w64-mingw32- 
                    --prefix=${MINGW_INSTALL_PREFIX} 
                    --disable-cli 
                    --bit-depth=10 
                    ${disable_asm}
            "
        BUILD_COMMAND 
            ${EXEC} bash -c "
                cd ${SOURCE_LOCATION}/build/linux && 
                make CC=${TARGET_ARCH}-gcc 
                     CXX=${TARGET_ARCH}-g++ 
                     CPPFLAGS='-I${SYSROOT}/include -I${MINGW_INSTALL_PREFIX}/include' 
                     LDFLAGS='-L${SYSROOT}/lib -L${MINGW_INSTALL_PREFIX}/lib'
            "
        INSTALL_COMMAND 
            ${EXEC} bash -c "
                cd ${SOURCE_LOCATION}/build/linux && 
                make install
            "
        BUILD_IN_SOURCE 1
    )
endfunction()