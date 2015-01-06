/**
 *  Get the pointer for the system timer
 *  C++ `void *get_sys_timer()`
 */
.globl get_sys_timer
get_sys_timer:
  ldr r0,=0x20003000
  mov pc,lr

/**
 *  Get the current system timestamp
 *  C++ `u64 get_sys_timestamp()`
 */
.globl get_sys_timestamp
get_sys_timestamp:
  push {lr}
  bl get_sys_timer
  ldrd r0,r1,[r0,#4]
  pop {pc}

/**
 *  Wait for at least number of microseconds before returning.
 *  Duration is passed in r0
 *  C++ `void sys_wait(u32 delay)`
 */
.globl sys_wait
sys_wait:
  delay .req r2
  mov delay,r0

  push {lr}

  bl get_sys_timestamp
  start .req r3
  mov start,r0
  loop$:
    bl get_sys_timestamp
    elapsed .req r1
    sub elapsed,r0,start
    cmp elapsed,delay
    .unreq elapsed
    bls loop$

  .unreq delay
  .unreq start

  pop {pc}
