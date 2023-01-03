list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# TC_PATH can be changed on command line.
if(NOT DEFINED TC_PATH)
    set(TC_PATH "${CMAKE_SOURCE_DIR}/toolchain/bin/")
    message(STATUS "No -DTC_PATH specified, using default toolchain.")
endif()

# Maybe make this work on Windows?
if(WIN32)
    set(TC_EXT ".exe" )
else()
    set(TC_EXT "" )
endif()

# LD_SCRIPT_PATH can be changed on command line.
if(NOT DEFINED LD_SCRIPT_PATH)
    set(LD_SCRIPT_PATH "${CMAKE_CURRENT_LIST_DIR}/aarch64-none-elf.ld")
    message(STATUS "No -DLD_SCRIPT_PATH specified, using default linker script.")
endif()

# get the name of the linker script
get_filename_component(LD_SCRIPT_NAME ${LD_SCRIPT_PATH} NAME)

# copy the linker script to the build directory
configure_file(
    ${LD_SCRIPT_PATH}
    ${CMAKE_CURRENT_BINARY_DIR}/${LD_SCRIPT_NAME}
    COPYONLY
)

# copy the config file to the toolchain directory
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/aarch64-none-elf.cfg
    ${TC_PATH}aarch64-none-elf.cfg
    COPYONLY
)

# assemble flags for clang
list(APPEND LLVM_CLANG_FLAGS "--config aarch64-none-elf.cfg")
list(APPEND LLVM_CLANG_FLAGS "-std=gnu99")

list(APPEND LLVM_CLANG_FLAGS "-funsigned-char")
list(APPEND LLVM_CLANG_FLAGS "-ffreestanding")
list(APPEND LLVM_CLANG_FLAGS "-fno-stack-protector")
list(APPEND LLVM_CLANG_FLAGS "-fno-exceptions")
list(APPEND LLVM_CLANG_FLAGS "-fno-rtti")

list(APPEND LLVM_CLANG_FLAGS "-mgeneral-regs-only")
list(APPEND LLVM_CLANG_FLAGS "-mstrict-align")

# join flags into a string
list(JOIN LLVM_CLANG_FLAGS " " LLVM_CLANG_FLAGS)

# Common flags
set(CMAKE_ASM_FLAGS "${LLVM_CLANG_FLAGS}" CACHE INTERNAL "ASM Compiler options")
set(CMAKE_C_FLAGS "${LLVM_CLANG_FLAGS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_CURRENT_LIST_DIR}/${LD_SCRIPT_NAME}" CACHE INTERNAL "Linker options")

# Debug flags
set(CMAKE_ASM_FLAGS_DEBUG "" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_C_FLAGS_DEBUG "-DDEBUG -Og -g" CACHE INTERNAL "C Compiler options for debug build type")
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

# ??? not sure what these do, took them from an example
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
