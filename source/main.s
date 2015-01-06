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

  mov r0,#1024
  mov r1,#768
  mov r2,#16

  bl init_framebuffer

  teq r0,#0
  bne no_error$

    bl gpio_set_status_on

    error$:
      b error$

  no_error$:
  buffer_addr .req r4
  mov buffer_addr,r0

  render$:
    addr .req r3
    ldr addr,[buffer_addr,#32]

    color .req r0
    y .req r1
    mov y,#768
    draw_row$:
      x .req r2
      mov x,#1024
      draw_pixel$:
        strh color,[addr]
        add addr,#2
        sub x,#1
        teq x,#0
        bne draw_pixel$

      sub y,#1
      add color,#1
      teq y,#0
      bne draw_row$

    b render$

  .unreq addr
  .unreq buffer_addr
