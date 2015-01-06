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
  pin_num .req r0
  pin_func .req r1
  mov pin_num,#16
  mov pin_func,#1
  bl set_gpio_function
  .unreq pin_num
  .unreq pin_func

  loop$:
    // Turn the pin off to turn on the LED
    pin_num .req r0
    pin_val .req r1
    mov pin_num,#16
    mov pin_val,#0
    bl set_gpio
    .unreq pin_num
    .unreq pin_val

    decr .req r0
    mov decr,#0x3F0000
    wait1$:
      sub decr,#1
      teq decr,#0
      bne wait1$
    .unreq decr

    pin_num .req r0
    pin_val .req r1
    mov pin_num,#16
    mov pin_val,#1
    bl set_gpio
    .unreq pin_num
    .unreq pin_val

    decr .req r0
    mov decr,#0x3F0000
    wait2$:
      sub decr,#1
      teq decr,#0
      bne wait2$
    .unreq decr

  b loop$
