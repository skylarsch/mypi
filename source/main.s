/**
    Raspberry Pi OS

    Skylar Schipper
*/
.section .init
.globl _start

_start:
  // Set the GPIO address into reg 0
  ldr r0,=0x20200000

  // Enable GPIO
  mov r1,#1
