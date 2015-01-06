.section .data
.align 12
.globl framebuffer_info
framebuffer_info:
  .int 1024 // #0 Physical Width
  .int 768  // #4 Physical Height
  .int 1024 // #8 Virtual Width
  .int 768  // #12 Virtual Height
  .int 0    // #16 GPU pitch
  .int 16   // #20 Bit depth
  .int 0    // #24 X
  .int 0    // #28 Y
  .int 0    // #32 GPU - Pointer
  .int 0    // #36 GPU - Size

.section .text

/**
 * Initialize frame buffer with width & height passed in r0, r1 respectively.
 * Bit depth is passed in r2
 * C++ `framebuffer_info *init_framebuffer(u32 width, u32 height, uu32 bit_depth)`
 */
.globl init_framebuffer
init_framebuffer:
  width .req r0
  height .req r1
  bit_depth .req r2
  cmp width,#4096
  cmpls height,#4096
  cmpls bit_depth,#32
  result .req r0
  movhi result,#0
  movhi pc,lr

  push {r4, lr}
  fb_info_addr .req r4

  // Set the framebuffer info values
  ldr fb_info_addr,=framebuffer_info
  str width,[r4,#0]
  str height,[r4,#4]
  str width,[r4,#8]
  str height,[r4,#12]
  str bit_depth,[r4,#20]
  .unreq width
  .unreq height
  .unreq bit_depth

  mov r0,fb_info_addr
  add r0,#0x40000000  // Add 0x40000000 so the GPU doesn't use it's cache
  mov r1,#1
  bl mailbox_write

  mov r0,#1
  bl mailbox_read

  teq result,#0
  movne result,#0
  popne {r4,pc}

  mov result,fb_info_addr
  pop {r4,pc}
  .unreq result
  .unreq fb_info_addr
