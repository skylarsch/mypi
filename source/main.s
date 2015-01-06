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
  lsl r1,#18
  str r1,[r0,#4]

  // Turn off the pin to turn on the LED
  mov r1,#1
  lsl r1,#16
  str r1,[r0,#40]

  // Loop forever
  loop$:
  b loop$
