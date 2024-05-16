.386
.model flat,stdcall
.stack 4096
option casemap:none 

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

STD_OUTPUT_HANDLE EQU -11 ; stdout

.data
    message db "Hello World",13,10 ; 13 - CR, 10 - LF
    msg_size equ $ - offset message ; size of message in bytes
.data?

consoleOutHandle dd ? ; Initialize space for the console output handle
bytesWritten dd ?   ; Initialize space for the number of bytes written

.code
    start:
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; Get the standard output handle
    mov [consoleOutHandle],eax ; Save the handle in the consoleOutHandle variable

invoke WriteConsole,                   \ ; https://learn.microsoft.com/en-us/windows/console/writeconsole
       eax,                         \
       offset message,              \
       msg_size,                    \
       offset bytesWritten,              \
       0

INVOKE ExitProcess,0 
end start