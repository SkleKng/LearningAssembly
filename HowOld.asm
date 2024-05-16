.386
.model flat, stdcall
.stack 16384
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

STD_OUTPUT_HANDLE EQU -11
STD_INPUT_HANDLE EQU -10
BUFFER_LENGTH EQU 256

.data
    question db "How old are you? ",13,10
    msg_size equ $ - offset question
.data?
    consoleOutHandle dd ? 
    consoleInHandle dd ?
    buffer db BUFFER_LENGTH dup(?)
    bytesRead dd ?
    charsWritten dd ?

.code
start:
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov [consoleOutHandle], eax

    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov [consoleInHandle], eax

    ; https://learn.microsoft.com/en-us/windows/console/writeconsole
    ; BOOL WINAPI WriteConsole(
    ;     _In_             HANDLE  hConsoleOutput,
    ;     _In_       const VOID    *lpBuffer,
    ;     _In_             DWORD   nNumberOfCharsToWrite,
    ;     _Out_opt_        LPDWORD lpNumberOfCharsWritten,
    ;     _Reserved_       LPVOID  lpReserved
    ; )
    invoke WriteConsole, consoleOutHandle, addr question, msg_size, addr charsWritten, NULL

    ; https://learn.microsoft.com/en-us/windows/console/readconsole
    ; BOOL WINAPI ReadConsole(
    ;     _In_     HANDLE  hConsoleInput,
    ;     _Out_    LPVOID  lpBuffer,
    ;     _In_     DWORD   nNumberOfCharsToRead,
    ;     _Out_    LPDWORD lpNumberOfCharsRead,
    ;     _In_opt_ LPVOID  pInputControl
    ; )
    invoke ReadConsole, consoleInHandle, addr buffer, BUFFER_LENGTH, addr bytesRead, NULL

    invoke WriteConsole, consoleOutHandle, addr buffer, bytesRead, addr charsWritten, NULL

    INVOKE ExitProcess, 0 
end start
