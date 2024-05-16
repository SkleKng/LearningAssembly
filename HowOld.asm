; This is a simple program that asks the user for their age and prints it back to them

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
    question db "How old are you? ",13,10 ; 13 = CR, 10 = LF
    msg_size equ $ - offset question
    outputFormat db "You are %s years old.",13,10,0 ; 13 = CR, 10 = LF, 0 = Terminator
.data?
    consoleOutHandle dd ? 
    consoleInHandle dd ?
    buffer db BUFFER_LENGTH dup(?)
    formattedBuffer db BUFFER_LENGTH dup(?)
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
    invoke WriteConsole, consoleOutHandle, addr question, msg_size, addr charsWritten, NULL ; "How old are you?\n"

    ; https://learn.microsoft.com/en-us/windows/console/readconsole
    ; BOOL WINAPI ReadConsole(
    ;     _In_     HANDLE  hConsoleInput,
    ;     _Out_    LPVOID  lpBuffer,
    ;     _In_     DWORD   nNumberOfCharsToRead,
    ;     _Out_    LPDWORD lpNumberOfCharsRead,
    ;     _In_opt_ LPVOID  pInputControl
    ; )
    invoke ReadConsole, consoleInHandle, addr buffer, BUFFER_LENGTH, addr bytesRead, NULL

    ; We need to remove CRLF in order to use wsprintf. To do this, We will figure out where CR is and replace it with a null terminator

    mov eax, [bytesRead] ; move bytesRead into eax
    dec eax ; decrement eax for LF
    dec eax ; decrement eax for CR
    mov byte ptr [buffer + eax], 0 ; At this point, buffer + eax is the CR character. We replace it with a null terminator

    ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-wsprintfa
    ; int WINAPIV wsprintfA(
    ;     [out] LPSTR  unnamedParam1,
    ;     [in]  LPCSTR unnamedParam2,
    ;             ...    
    ; )
    ; this returns the number of characters written to the buffer into eax, hence using eax as the third parameter in WriteConsole
    invoke wsprintf, addr formattedBuffer, addr outputFormat, addr buffer

    invoke WriteConsole, consoleOutHandle, addr formattedBuffer, eax, addr charsWritten, NULL ; "You are %s years old.\n"

    INVOKE ExitProcess, 0 
end start

; This took me an hour. I could do this in less than a minute in python
; print("How old are you?")
; age = input()
; print(f"You are {age} years old.")

; I don't care, I love learning