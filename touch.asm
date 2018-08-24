  BITS 16
  ORG 32768
  %INCLUDE 'mikedev.inc'

start:
  call  os_string_compare
  jc    .print_usage        ; If no commnand-line args print usage and exit

  mov   ax,si 
  call  os_create_file
  ret

.print_usage:
  mov   si, .usageline1
  call  os_print_string
  ret

.usageline1   db 'Usage: touch <filename>', 10, 13, 0
