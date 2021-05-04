;amit bhandal 014172912
section .data
    hex db `%02X \0`
    eol db `\n\0`
    check db `test\n`

section .text
    global main
    extern printf
    extern strtol

main:
    mov rcx, rsi ;move stack arg pointer into rcx
    add rcx, 8 ;go to inputted arg
    mov rcx, [rcx] ;move string value at address into rcx
    mov rdi, rcx ;move address of string to parse into rdi
    mov rsi, 0 ;not using 2nd parameter of strtol
    mov rdx, 16 ;move base 16 into 3rd parameter
    call strtol wrt ..plt ;conversion is in rax

    ;we now need to determine how many bytes the string needs
    ;USE BSR for byte range, <= 6 1byte, <= 10 2bytes, <= 15 3bytes, <= 20 4bytes
    ;bits - 1 since 0 zero indexed

    bsr rdx, rax ;rdx will help is determine how many bytes
    
    cmp rdx, 6 
    jle oneByte ;arg <= 127 1 byte

    mov rcx, 0
    mov rbx, 2 ;2 bytes
    mov cl, 0 ;byte offset set to 0
    cmp rdx, 10
    jle computeContinuationBytes ;arg <= 2047 2 bytes

    mov rbx, 3 ;3 bytes
    mov cl, 0 ;byte offset set to 0
    cmp rdx, 15 
    jle computeContinuationBytes ;arg <= 65535 3 bytes

    mov rbx, 4 ;4 bytes
    mov cl, 0 ;byte offset set to 0
    jmp computeContinuationBytes    

    computeContinuationBytes:
        mov rdx, 0 ;reset  rdx
        mov dh, 6 ;we want to extract 6 bits
        add dl, cl
        bextr rsi, rax, rdx ;rsi contains lower six bits
        add rsi, 128 ;add continuation byte 10000000
            
        push rsi ;cache last byte onto stack
        add cl, 6 ;move to next byte position
        sub rbx, 1 ;remaining bytes
        cmp rbx, 1
        jg computeContinuationBytes ;if rbx > 1 loop and compute next byte
    
        bsr rdx, rax ;rdx will help is determine what leading byte to add

        ;cmp rax, 2047
        cmp rdx, 10
        jle twoBytes ;arg <= 2047 2 bytes

        ;cmp rax, 65535 
        cmp rdx, 15
        jle threeBytes ;arg <= 65535 3 bytes

        jmp fourBytes ; arg > 65535 4 bytes



    oneByte:
        ;if one byte just print it
        push rax ;16-byte align
        mov rdi, hex
        mov rsi, rax
        call printf wrt ..plt

        ;print new line
        mov rdi, eol
        call printf wrt ..plt
        jmp exit


    ;when we have output, just read 8bits at a time, put it into hex and print

    twoBytes:
            ;just compute leading byte and print
            mov rdx, 0 ;reset  rbx
            mov dh, 6 ;we want to extract 6 bits
            mov dl, 6 ;move starting bit into bl
            bextr rsi, rax, rdx ;rsi contains lower six bits
            add rsi, 192 ;add leading byte 11000000

            ;print first byte
            mov rdi, hex
            ;mov rsi, rdx, result is already in rsi
            call printf wrt ..plt

            pop rbx ;retrieve cached continuation byte
            push rax ;realign stack

            ;print last byte
            mov rdi, hex
            mov rsi, rbx
            call printf wrt ..plt

            ;print new line
            mov rdi, eol
            call printf wrt ..plt

            jmp exit ;exit


    threeBytes:
        ;just compute leading byte and print
            mov rdx, 0 ;reset  rbx
            mov dh, 6 ;we want to extract 6 bits
            mov dl, 12 ;move starting bit into bl
            bextr rsi, rax, rdx ;rsi contains lower six bits
            add rsi, 224 ;add leading byte 11100000

            push rsi ;align

            ;print
            mov rdi, hex
            ;mov rsi, rdx, result is already in rsi
            call printf wrt ..plt

            pop rax ;unalign
            pop rbx ;align

            ;print second last byte
            mov rdi, hex
            mov rsi, rbx
            call printf wrt ..plt

            pop rbx
            push rax ;realign

            ;print last byte
            mov rdi, hex
            mov rsi, rbx
            call printf wrt ..plt

            ;print new line
            mov rdi, eol
            call printf wrt ..plt

            jmp exit ;exit


    fourBytes:
        ;just compute leading byte and print
            mov rdx, 0 ;reset  rbx
            mov dh, 6 ;we want to extract 6 bits
            mov dl, 18 ;move starting bit into bl
            bextr rsi, rax, rdx ;rsi contains lower six bits
            add rsi, 240 ;add leading byte 11110000

            ;print
            mov rdi, hex
            ;mov rsi, rdx, result is already in rsi
            call printf wrt ..plt
            
            pop rbx ;retrieve cached byte
            push rax ;realign

            ;print third last byte
            mov rdi, hex
            mov rsi, rbx
            call printf wrt ..plt

            pop rax ;unalign
            pop rbx ;realign
            ;push rax ;realign

            ;print second last byte
            mov rdi, hex
            mov rsi, rbx
            call printf wrt ..plt

            pop rbx ;unalign
            push rax ;realign

            mov rdi, hex
            mov rsi, rbx
            call printf wrt ..plt

            ;print new line
            mov rdi, eol
            call printf wrt ..plt

            jmp exit ;exit


    ;exit
    exit:
        pop rax
        mov rax, 60
        mov rdx, 0
        syscall