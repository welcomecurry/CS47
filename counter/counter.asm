;amit bhandal 014172912
section .data
    initial db `000\n`
    currNum db `000\n`
    len dq 4
    iterations dq 256
    
section .text
    global _start

_start:
    mov rbx, 0 ;curr num
    loop:
        mov rdi, 2 ;byte mover
        mov rax, rbx ;rbx is our number to ouput

        populateCurrNum:
            mov rcx, 10 ;we want to divide rax by 10 and grab remainder from rdx
            mov rdx, 0 ;reset rdx otherwise we get floating point exception if its already pointing to address
            div rcx ;divide rax by 10 remainder is in rdx
            mov rcx, rax ;store result into rcx then reset rax later
            mov rax, currNum ;move string to rax
            add rax, rdi ;add rdi to rax since we want to move over rdi bytes, read from end digit
            mov al, [rax] ;move byte index value rax into al 8 bit register
            add rax, rdx ;add rdx to rax since that is remainder
            mov rsi, currNum ;move string into rsi
            add rsi, rdi ;write at end digit, move over to byte to be changed
            mov [rsi], al ;write byte
            mov rax, rcx ;reset rax since we changed it
            sub rdi, 1 ;decrement byte to change indice

        sub rax, 0 ;if we run out of numbers terminate loop
        jnz populateCurrNum

        ;print
        mov rax, 1
        mov rdi, 1 
        mov rsi, currNum
        mov rdx, 4
        syscall

        mov rax, [iterations] ;move iterations into rax so we can sub from rbx
        mov rcx, [initial] ;move inital into rcx so we can reset currNum
        mov [currNum], rcx ;reset currNum with initial
        add rbx, 1 ;increment rbx (currNum)
        sub rax, rbx ;sub iterations from currNum, if not zero loop again

        jnz loop ;loop again till we hit 255

    ;exit
    mov rax, 60
    mov rdx, 0
    syscall


