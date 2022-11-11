#=========================================================================
# crt0.S : Entry point for TinyRV2 user programs
#=========================================================================
# This file is originally grabbed from riscv-gnu-toolchain repo
#
#  - https://github.com/riscv/riscv-gnu-toolchain/blob/master/newlib/libgloss/riscv/riscv.ld
#
# According to this:
#
#  - https://github.com/riscv/riscv-gnu-toolchain/issues/42
#
# The execution environment (e.g., OS kernel) is expected to have
# initialized sp before jumping to the program's entry point. If you're
# in an embedded domain with different constraints, you need to use a
# different crt0 that sets up that kind of thing. gp is the ABI global
# pointer to the small data section. The OS doesn't initialize it because
# it's a property of the binary, not the execution environment (unlike
# the stack).
#
#  Author : Shunning Jiang
#  Date   : Sep 22, 2016
#

  .text
  .global _start
_start:
1:
  # initialize global pointer

  auipc gp, %pcrel_hi(_gp)
  addi  gp, gp, %pcrel_lo(1b)

  # initialize stack pointer to 0xffffc

  lui   sp, 256
  addi  sp, sp, -4

  # allocate 0x4000 (16KB) stack memory for each core
  #  - core #0 uses 0x100000~0xfc000 as stack
  #  - core #1 uses 0xfc0000-0xf8000 as stack
  #  - core #2 uses 0xf80000-0xf4000 as stack
  #  - core #3 uses 0xf40000-0xf0000 as stack

  addi  t0, zero, 0
  lui   t0, 4
  csrr  t1, 0xF14
  mul   t2, t0, t1
  sub   sp, sp, t2

  # clear the bss segment

  la    t0, _fbss
  la    t1, _end

  sw    zero,0(t0)
  addi  t0, t0, 4
  bltu  t0, t1, 1b

  # call main

  jal   x1, main

  # use return value from main (a0) as exit code

  lui   t0, 0x10
  add   t0, t0, a0
  csrw  0x7c0, t0

  # infinite loop, should not get here

1:
  beq     zero, zero, 1b
