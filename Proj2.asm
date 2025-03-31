extern printf
extern fopen
extern fclose
extern feof
extern fscanf

section .bss
    ; file: C File pointer, must be a 64 bit variable
    file reso 1             
    ; MAX_LENGTH: CONST, max length of number in file
    MAX_LENGTH equ 16         
    ; line: char[MAX_LENGTH], buffer to store individual lines
    line resb MAX_LENGTH     
    ; number: parsed value of a line 
    number resb 1 
    ; numCount: number of lines given in the file, though ignored as we use feof
    numCount resw 1

section .data
    ; pathname: name of the file to parse numbers from
    pathname dq "randomInt100.txt", 0
    ; fmt: formatting used when parsing (or printing) numbers
    fmt db "%d", 10, 0
    ; linecount: string used when printing the number of lines in the file (according to the first line)
    linecount db "Line count = %d", 10, 0
    ; totalCount: string used when displaying the sum of the numbers in the file
    totalCount db "Total count = %d", 10, 0
    ; READ_MODE: C file open mode used when reading the file
    READ_MODE db "r", 0
    ; total: stores the sum of all numbers in the file
    total dd 0
    
section .text
global main

main:
    ; init
    push rbp
    mov rbp, rsp
    
    ; Open file, saves FILE pointer to file variable
    mov rdi, pathname
    mov rsi, READ_MODE
    call fopen
    mov [file], rax

read_first:

    ; Read a number from the file
    mov rdi, [file]
    mov rsi, fmt
    mov rdx, numCount
    call fscanf

    ; print number of lines
    mov rdi, linecount
    mov rsi, [numCount]
    xor eax, eax
    call printf

print_loop:

    ; Read a number from the file
    mov rdi, [file]
    mov rsi, fmt
    mov rdx, number
    call fscanf

    ; Uncomment to print the individual lines
    ; mov rdi, fmt
    ; mov rsi, [number]
    ; xor eax, eax
    ; call printf

    ; Add to the total
    mov rax, [number]
    mov rbx, [total]
    add rax, rbx
    mov [total], rax

    ; Loop
    mov rdi, [file]
    call feof ; sets rax to 0 if not end of file
    jz print_loop

print_total:

    ; prints the total
    mov rdi, totalCount
    mov rsi, [total]
    xor eax, eax
    call printf

close: 

    ; Close the file
    mov rdi, [file]
    call fclose

    mov rsp, rbp
    pop rbp
    ret