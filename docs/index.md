
ECE 4750 Section 11: Lab 4 Head Start
==========================================================================

 - Author: Christopher Batten
 - Date: November 11, 2022

**Table of Contents**

 - TinyRV2 Single-Core Processor Walk-Through
 - Compiling and Cross-Compiling a Simple C Program
 - Compiling and Cross-Compiling a Microbenchmark

This discussion section serves to introduce students to the basic build
system we will be using to compile and cross-compile programs to run on
the single- and multi-core processors we will be building in lab 4. You
should log into the `ecelinux` servers using the remote access option of
your choice and then source the setup script.

    % source setup-ece4750.sh
    % mkdir -p $HOME/ece4750
    % cd $HOME/ece4750
    % git clone git@github.com:cornell-ece4750/ece4750-sec11-sys sec11
    % cd sec11
    % TOPDIR=$PWD

TinyRV2 Single-Core Processor Walk-Through
--------------------------------------------------------------------------

The following figure shows the high-level interface for our TinyRV2
single-core system. We compose a processor model with an instruction and
data cache model. There are also mngr2proc and proc2mngr stream
interfaces for testing purposes. All interfaces are implemented using the
latency-insensitive val/rdy micro-protocol.

![](assets/fig/lab4-score.png)

Compiling and Cross-Compiling a Simple C Program
--------------------------------------------------------------------------

You can use the build system to compile a simple C program like this:

    % mkdir -p $TOPDIR/app/build-native
    % cd $TOPDIR/app/build-native
    % ../configure
    % make simple-avg

This is compiling the program natively. You can now run the program to
test it like this:

    % cd $TOPDIR/app/build-native
    % ./simple-avg

Always make sure your C programs work natively before trying to
cross-compile them!

We use a separate build directory with a different configure argument to
setup the cross-compilation build like this:

    % mkdir -p $TOPDIR/app/build
    % cd $TOPDIR/app/build
    % ../configure --host=riscv32-unknown-elf
    % make simple-avg

You can use objdump to look at the corresponding RISC-V assembly.

    % cd $TOPDIR/app/build
    % riscv32-objdump simple-avg

We can now test this RISC-V binary out using a functional-level simulator
of our single-core system.

    % mkdir -p $TOPDIR/sim/build
    % cd $TOPDIR/sim/build
    % ../lab4_sys/sys-sim ../../app/build/simple-avg
    % ../lab4_sys/sys-sim ../../app/build/simple-avg --trace

Compiling and Cross-Compiling a Microbenchmark
--------------------------------------------------------------------------

Now let's try the same thing but with the vector-vector add
microbenchmark. First, always make sure it works natively.

    % cd $TOPDIR/app/build-native
    % make ubmark-vvadd
    % ./ubmark-vvadd

Now let's cross-compile and look at the disassembly.

    % cd $TOPDIR/app/build
    % make ubmark-vvadd
    % riscv32-objdump ubmark-vvadd

Finally, let's run it on our functional-level simulator.

    % cd $TOPDIR/sim/build
    % ../lab4_sys/sys-sim ../../app/build/ubmark-vvadd
    % ../lab4_sys/sys-sim ../../app/build/ubmark-vvadd --trace

The instructor will explain the line trace that corresponds to running
this program on the RTL composition of the fully bypassed processor and
two-way set associative cache.

**To-Do On Your Own** Try writing an accumulate microbenchmark in the
`ubmark-accumulate.c` file. Compile it natively to verify it works.
Then cross-compile it and look at the disassembly. Finally, try it out
on the functional-levle simulator.

