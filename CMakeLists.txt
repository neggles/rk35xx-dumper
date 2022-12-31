# CMake Version Declaration Always First
cmake_minimum_required(VERSION 3.16)
include("./cmake/toolchains/aarch64-none-elf.cmake")

project(rk35xx-dumper LANGUAGES C)

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_SKIP_INSTALL_RULES ON)

# Ninja monkey patch. Should be fixed in cmake 3.18
# Defaults to "-MD -MT <OBJECT> -MF <DEPFILE>" ('as' no likey).
set(CMAKE_DEPFILE_FLAGS_ASM "")

# Blindly grab all .c files in the source directory
set(CMAKE_SOURCE_DIR ./src)

set(ELFNAME "${PROJECT_NAME}.elf")

message("Target: ${ELFNAME} (${CMAKE_BUILD_TYPE})")

file(GLOB sources ./src/*.c)

add_executable(${ELFNAME} ${sources})
target_include_directories(${ELFNAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

set_target_properties(${ELFNAME} PROPERTIES
    LINK_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/${LLVM_LD_SCRIPT}"
    LINK_FLAGS "-Bstatic -nostdlib"
)
