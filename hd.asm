section .data
result db 0 ;variable for hamming distance, allocates 0 to start
stringprint1 db "Input 1: "
stringprint1length equ $-stringprint1
stringprint2 db "Input 2: "
stringprint2length equ $-stringprint2
maxlength equ 255 ;constant for max string length

section .bss
string1 resb maxlength
string1length resb 1
string2 resb maxlength
string2length resb 1
stringshortest resb 1

section .text
global _start




_start:
mov eax, 4 ;system call read 
mov ebx, 1       ;file descriptor cout
mov ecx, stringprint1  ;pointer to data needing to be printed
mov edx, stringprint1length    ;message length
int 0x80         ;call kernel
	
mov eax, 3 ;sys call read
mov ebx, 0 ;cin
mov ecx, string1 ;set pointer of ecx to string1
mov edx, maxlength ;set pointer of edx to max number of bits system will try to read
int 0x80 ;call kernel
mov [string1length], eax ;set length of string 1

mov eax, 4 ;system call read 
mov ebx, 1       ;file descriptor cout
mov ecx, stringprint2  ;pointer to data needing to be printed
mov edx, stringprint2length    ;message length
int 0x80         ;call kernel

mov eax, 3 ;sys call read
mov ebx, 0 ;cin
mov ecx, string2 ;set pointer of ecx to string2
mov edx, maxlength ;set pointer of edx to max number of bits system will try to read
int 0x80 ;call kernel
mov [string2length], eax ;set length of string 2

mov eax, [string1length] ;copy string1length to eax
mov ebx, [string2length] ;copy string2length to ebx

cmp eax, ebx ;compare eax and ebx
jle string1shortest

mov [stringshortest], ebx ;move string2length into stringshortest
jmp init ;skips past string1shortest

string1shortest:
mov [stringshortest], eax ;moves string1length into stringshortest




init:
mov edx, 0 ;register for storing hamming distance
mov ecx, 0 ;counter initialized at 0




loop:
mov ah, [string1 + ecx] ;passing each character of string1 into eax, ecx is offset and incremented with each loop
mov bh, [string2 + ecx]

xor ah, bh ;compare character in eax and ebx, store bitwise difference in eax
movsx eax, ah ;move comparison value into eax (convert from 8 bit to 32)
popcnt eax, eax ;calculates number of bits set to 1 in eax and stores that integer in eax

add edx, eax ;adds value of eax and edx, stores in edx

inc ecx ;increment ecx by 1

cmp ecx, [stringshortest] ;compares value of ecx and stringshortest
jne loop ;jump to loop if ecx not equal to string1length




print:
add edx, '0';convert ascii to int
mov [result], edx ;move int stored in edx, hamming distance, into result

mov eax, 4 ;system call read 
mov ebx, 1       ;file descriptor cout
mov ecx, result  ;pointer to data needing to be printed
mov edx, 1       ;message length
int 0x80         ;call kernel
    
mov eax, 1  ;system call exit
xor ebx, ebx;sets ebx to zero
int 0x80;call kernel
