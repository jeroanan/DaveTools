  BITS 16
  ORG 32768
  %INCLUDE 'mikedev.inc'

start:
  mov   di, .restofstring
  call  os_string_copy

  mov   ax, si
  call  .check_file_out
  jc    .write_to_file

  mov   ax, .restofstring
  mov   bx, .eol
  mov   cx, .outstr
  call  os_string_join        ; Take command-line param and put CRLF on the end.

  mov   si, .outstr
  call  os_print_string       ; Print command-line param + CRLF string

  jmp   .end

  .outstr     times 1000 db 0

.check_file_out:
  clc

  mov   si, ax            ; Command-line parameters are to be passed in ax.
  call  os_string_parse

  mov   di, .file_flag    
  call  os_string_compare ; Check whether the first word of cmdline says that we should write to file
  jc    .set_write_file   ; If it is then go and indicate that this is the case

  ret

.set_write_file:
  mov   ax, bx            ; Set ax to the second cmdline param (i.e. the file to write)

  stc                     ; Set carry flag -- this indicates that we will write to file
  ret

  .file_flag  db '-f', 0 

.write_to_file:
  push  ax                ; ax is our filename -- save for later

  mov   si, dx
  mov   di, .restofstring 
  call os_string_copy     ; dx contains the final words of our input -- save for later

  mov   ax, cx            ; The first word to echo was in cx
  mov   bx, .space        ; Put a space after the first word -- it was swallowed by earlier os_string_parse
  call  os_string_join

  mov   ax, cx
  mov   bx, .restofstring
  call  os_string_join    ; cx now contains first word + space + last words

  mov   ax, cx
  mov   bx, .eol
  call  os_string_join    ; Add a CRLF to the end

  mov   ax, cx
  call  os_string_length
  mov   bx, ax            ; Store the string length in bx for now so we can do jiggery-pokery in a few lines

  pop   ax                ; The filename from cmdline goes into ax
  push  bx                ; Push string length
  mov   bx, cx            ; Our string to write
  pop   cx                ; The string length
  call  os_write_file

  ret

  .eol          db 10, 13, 0
  .space        db ' ', 0
  .restofstring times 1000 db 0
  .tracer       db 'here i am!', 10, 13, 0

.end:
  ret

