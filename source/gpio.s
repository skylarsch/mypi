
/*
 *  return the base address of the GPIO region.
 *  C++ `void *get_gpio_address()`
 */
.global get_gpio_address
get_gpio_address:
  ldr r0,=0x20200000
  mov pc,lr

/*
 * Sets the function of GPIO register addressed by r0 to low 3 bit of r1
 * C++ `void set_gpio_function(u32 register, u32 function)`
 */
.global set_gpio_function
set_gpio_function:
  // Check that r0 <= 53 && r1 <= 7
  cmp r0,#53
  cmpls r1,#7
  movhi pc,lr

  push {lr}
  mov r2,r0 // Move r0 into r2 so we can get the address of GPIO
  bl get_gpio_address

  function_loop$:
    cmp r2,#9
    subhi r2,#10  // If the number is higher than 9 subtract 10
    addhi r0,#4   // Add 4 so r0 has the GPIO function address
    bhi function_loop$

  add r2, r2,lsl #1 // r2 * 3
  lsl r1,r2
  str r1,[r0]
  pop {pc}

/*
 * Sets the GPIO pin addressed by r0 to high if r1 != 0 and low other
 * C++ `void set_gpio(u32 register, u32 value)`
 */
.global set_gpio
set_gpio:
  pin_num .req r0
  pin_val .req r1

  cmp pin_num,#53 // Check that pin is <= 53
  movhi pc,lr

  push {lr}

  // Store num in r2
  mov r2,pin_num
  .unreq pin_num

  // Set pin_num to r2
  pin_num .req r2

  // Get GPIO address
  bl get_gpio_address
  gpio_addr .req r0

  // Set the correct pin pointer
  pin_bank .req r3
  lsr pin_bank,pin_num,#5 // Same as pin_num / 32
  lsl pin_bank,#2 // Multiply by 4
  add gpio_addr, pin_bank
  .unreq pin_bank

  // Generate the value to set pin
  and pin_num,#31
  set_bit .req r3
  mov set_bit,#1
  lsl set_bit,pin_num
  .unreq pin_num

  teq pin_val,#0
  .unreq pin_val
  streq set_bit,[gpio_addr,#40] // Pin off
  strne set_bit,[gpio_addr,#28] // Pin on

  .unreq set_bit
  .unreq gpio_addr

  pop {pc}
