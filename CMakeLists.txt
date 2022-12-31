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

if (NOT ${PROJECT_NAME}-MultiBuild)
    set(${PROJECT_NAME}-MultiBuild ON)

    macro (setup_build target_name build_type)
        set(ELFNAME "${target_name}.elf")
        set(QEMU_BUILD OFF)
        set(CMAKE_BUILD_TYPE ${build_type})

        if (${build_type} STREQUAL "Qemu")
            set(CMAKE_BUILD_TYPE "Debug")
            set(QEMU_BUILD ON)
        endif()

        add_subdirectory(
            ${CMAKE_CURRENT_SOURCE_DIR}
            ${build_type}
        )
    endmacro()

    setup_build(${PROJECT_NAME}_d Debug)
    setup_build(${PROJECT_NAME} Release)
    setup_build(${PROJECT_NAME}_qemu Qemu)

    return()
endif()

# Blindly grab all .c files in the source directory
set(CMAKE_SOURCE_DIR ./src)

# if (CMAKE_BINARY_DIR MATCHES "build-qemu")
#     message(FATAL_ERROR "In-source builds are not allowed.")
#     set(TARGET_NAME "${PROJECT_NAME}_qemu.elf")
# else()
#     set(TARGET_NAME "${PROJECT_NAME}.elf")
#     add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR} build-qemu)
# endif()

message("Target: ${ELFNAME} (${CMAKE_BUILD_TYPE})")
message("QEMU build: ${QEMU_BUILD}")

file(GLOB sources ./src/*.c)

add_executable(${ELFNAME} ${sources})
target_include_directories(${ELFNAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

if (QEMU_BUILD)
    target_compile_definitions(${ELFNAME} PRIVATE QEMU_BUILD=${QEMU_BUILD})
endif()

set_target_properties(${ELFNAME} PROPERTIES
    LINK_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/${LLVM_LD_SCRIPT}"
    LINK_FLAGS "-mstrict-align -mgeneral-regs-only -ffreestanding -e 0"
)
