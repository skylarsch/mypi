/**
    Raspberry Pi OS

    Skylar Schipper
*/
.section .init
.globl _start
_start:
  b main

.section .text
main:
  mov sp,#0x8000

  // Set function to 1 on pin 16
  mov r0,#16
  mov r1,#1
  bl set_gpio_function

  ptrn .req r4
  ldr ptrn,=pattern
  ldr ptrn,[ptrn]
  seq .req r5
  mov seq,#0

  mov r1,#1
  lsl r1,seq
  and r1,ptrn

  loop$:
    mov r0,#16
    mov r1,#1
    lsl r1,seq
    and r1,ptrn
    bl set_gpio

    ldr r0,=250000
    bl sys_wait

    add seq,#1
    and seq,#0b11111

  b loop$

.section .data
.align 2
pattern:
  .int 0b11111111101010100010001000101010
