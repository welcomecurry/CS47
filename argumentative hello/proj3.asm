section .data
    hello db 'hello '
    newLine db `!\n`
    numArguments dq 0

section .text
    global _start

_start:
    ;we don't have enough registers and can't modify rsp so we must store argc into a variable
    mov rbx, [rsp] ;move argc into rbx so we have the length of the stack
    mov [numArguments], rbx ;move argc into numArguments
    mov rbx, rsp ;move address of stack into rbx since we cannot modify rsp
    add rbx, 8 ;move to arg path
    mov rcx, 1 ;we need to subtract a variable with a register for it to work
    sub [numArguments], rcx ;subtract 1 since we don't want to count argpath

    jnz printCurrentArg ;if there are args, print them
    jmp exit ;otherwise if we have no args then just exit

    printCurrentArg:
        add rbx, 8 ;move to next argument

        ;print hello
        mov rax, 1
        mov rdi, 1
        mov rsi, hello
        mov rdx, 6
        syscall
        
        mov rdx, 1 ;reset rdx to 1, (the length)
        mov rax, [rbx] ;move current arg value into rax

        getLength:
            add rax, 1 ;increment current indice
            add rdx, 1 ;increment length
            sub byte [rax], 0x00 ;check if current char is null
            jnz getLength ;if we still have remaining characters loop again

        ;print current arg
        mov rax, 1 
        mov rdi, 1
        mov rsi, [rbx]
        ;we do not need to move anything into rdx since we have already populated it with currentArg length
        syscall

        ;append ! and newline to current arg
        mov rax, 1 
        mov rdi, 1
        mov rsi, newLine
        mov rdx, 2
        syscall

        mov rcx, 1 ;we need to subtract a variable with a register for it to work
        sub [numArguments], rcx ;decrement amount of args left
        mov rcx, [numArguments] ;move amount of args left into rcx
        sub rcx, 0 ;check if we have any remaining args, if it is zero then we are done, otherwise we loop again
        jnz printCurrentArg ;loop again if we have reamining args

    ;exit
    exit:
        mov rax, 60
        mov rdi, 0
        syscall
        
