#!/usr/bin/env bash

qemu-system-aarch64 \
   -semihosting-config enable=off \
   -nographic -monitor none \
   -machine virt \
   -cpu cortex-a53 \
   -kernel ./Qemu/rk35xx-dumper_qemu.elf
