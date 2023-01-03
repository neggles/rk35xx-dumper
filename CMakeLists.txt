# CMake Version Declaration Always First
cmake_minimum_required(VERSION 3.16)
include("./cmake/toolchains/aarch64-none-elf.cmake")

project(rk35xx-dumper LANGUAGES C)

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
#set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_SKIP_INSTALL_RULES ON)

# Ninja monkey patch. Should be fixed in cmake 3.18
# Defaults to "-MD -MT <OBJECT> -MF <DEPFILE>" ('as' no likey).
set(CMAKE_DEPFILE_FLAGS_ASM "")

# set the SoC we're building for (this mostly affects which ddr blob we use)
set(ROCKCHIP_SOC "rk3568")

# Set output elf name
set(OUTPUT_ELF "${PROJECT_NAME}.elf")
message("Target: ${OUTPUT_ELF} (${CMAKE_BUILD_TYPE})")

# Set source and rkbin directory variables
set(TARGET_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(RKBIN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/rkbin)

# Grab all the C files in the source directory and add the build target
file(GLOB sources ${TARGET_SOURCE_DIR}/*.c)

add_executable(${OUTPUT_ELF} ${sources})
target_include_directories(${OUTPUT_ELF} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(${OUTPUT_ELF} PROPERTIES
    LINK_DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${LLVM_LD_SCRIPT}"
    LINK_FLAGS "-Bstatic -nostdlib"
)

set(PAYLOAD_BIN ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-payload.bin)
# Custom command to objcopy the elf to a raw binary
add_custom_command(
    OUTPUT ${PAYLOAD_BIN}
    COMMAND ${CMAKE_OBJCOPY} -O binary ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_ELF} ${PAYLOAD_BIN}
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_ELF}
    COMMENT "Generating binary payload..."
)
add_custom_target(payload ALL
    DEPENDS ${PAYLOAD_BIN}
)

# Generate the boot_merger config file
configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/RKBOOT/${ROCKCHIP_SOC}.ini.in
    ${CMAKE_CURRENT_BINARY_DIR}/${ROCKCHIP_SOC}.ini
    @ONLY
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin
    COMMAND ${RKBIN_DIR}/tools/boot_merger ${CMAKE_CURRENT_BINARY_DIR}/${ROCKCHIP_SOC}.ini
    DEPENDS ${PAYLOAD_BIN} ${CMAKE_CURRENT_BINARY_DIR}/${ROCKCHIP_SOC}.ini
    COMMENT "Generating final binary..."
)
add_custom_target(bootimg ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin
)
