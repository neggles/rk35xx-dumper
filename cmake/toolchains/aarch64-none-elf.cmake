list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# We use "Generic" so cmake can expect to build for `none` platform.
set(CMAKE_SYSTEM_NAME Generic)
# Our buildroot toolchain is for `aarch64`
set(CMAKE_SYSTEM_PROCESSOR aarch64)
SET(CMAKE_CROSSCOMPILING 1)

# TC_PATH can be changed on command line.
if(NOT DEFINED TC_PATH)
    set(TC_PATH "")
    message(STATUS "No -DTC_PATH specified, using default toolchain path.")
endif()

# Some mininal cross-platform convienence.
if(WIN32)
    set(TC_EXT ".exe" )
else()
    set(TC_EXT "" )
endif()

# linker script
set(LLVM_LD_SCRIPT "aarch64.ld")

# assemble flags for clang
list(APPEND LLVM_CLANG_FLAGS "--config aarch64_bare.cfg")
list(APPEND LLVM_CLANG_FLAGS "-march=armv8-a")
list(APPEND LLVM_CLANG_FLAGS "-std=gnu99")

list(APPEND LLVM_CLANG_FLAGS "-funsigned-char")
list(APPEND LLVM_CLANG_FLAGS "-ffreestanding")
list(APPEND LLVM_CLANG_FLAGS "-mgeneral-regs-only")
list(APPEND LLVM_CLANG_FLAGS "-mstrict-align")

list(APPEND LLVM_CLANG_FLAGS "-fno-stack-protector")
list(APPEND LLVM_CLANG_FLAGS "-fno-exceptions")
list(APPEND LLVM_CLANG_FLAGS "-fno-rtti")

list(JOIN LLVM_CLANG_FLAGS " " LLVM_CLANG_FLAGS)


# Shun all C before C99
set(CMAKE_ASM_FLAGS "${LLVM_CLANG_FLAGS}" CACHE INTERNAL "ASM Compiler options")
set(CMAKE_C_FLAGS "${LLVM_CLANG_FLAGS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_CURRENT_SOURCE_DIR}/src/${LLVM_LD_SCRIPT}" CACHE INTERNAL "Linker options")

# Debug flags
set(CMAKE_ASM_FLAGS_DEBUG "" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_C_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# Release flags
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_C_FLAGS_RELEASE "-Os" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "" CACHE INTERNAL "Linker options for release build type")

# Binaries
set(CMAKE_LINKER ${TC_PATH}ld.lld${TC_EXT} CACHE FILEPATH "Linker Binary")
set(CMAKE_ASM_COMPILER ${TC_PATH}clang${TC_EXT} CACHE FILEPATH "ASM Compiler")
set(CMAKE_C_COMPILER ${TC_PATH}clang${TC_EXT} CACHE FILEPATH "C Compiler")
set(CMAKE_OBJCOPY ${TC_PATH}llvm-objcopy${TC_EXT} CACHE FILEPATH "Objcopy Binary")
set(CMAKE_AR ${TC_PATH}llvm-ar${TC_EXT} CACHE FILEPATH "Archiver Binary")

# TODO: Explain this.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
