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

    ldr r0,=0x1E8480
    bl sys_wait

    pin_num .req r0
    pin_val .req r1
    mov pin_num,#16
    mov pin_val,#1
    bl set_gpio
    .unreq pin_num
    .unreq pin_val

    ldr r0,=0x1E8480
    bl sys_wait

  b loop$
