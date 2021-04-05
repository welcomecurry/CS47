;amit bhandal 014172912
section .data
    num_fmt db `%d %s\n\0`
    fmt db `%s\n\0`

section .text
    global show_taunt
    global list_taunts
    extern taunt_array
    extern printf

list_taunts:
    push rax ;16-byte align
    mov rcx, taunt_array ;move taunt_array address into rcx
    mov rbx, 1 ;line number

    printAllTaunts:
        mov rdx, 0 ;reset rdx otherwise we get floating point exception
        mov al, [rcx] ;move current string into al
        sub al, 0x00 ;checking if first byte of is a null byte
        jz done ;if it is null byte then we are done so jump

        ;iterate
        mov rdi, num_fmt ;move num_fmt into first arg
        mov rsi, rbx ;move line number into 3rd param
        mov rdx, [rcx] ;move taunt string into rdx (4th)
        call printf wrt ..plt
        mov rcx, taunt_array ;rcx is reset on printf
        mov rax, 8 ;multiplier
        mul rbx ;rbx * 8
        add rcx, rax ;move to next element in the array result inrax
        add rbx, 1 ;go to next line number
        jmp printAllTaunts ;loop again till we hit null byte
    
    done:
        pop rax ;pop off rax since we need return on top of stack
        ret

show_taunt:
    push rax ;16-byte align
    mov rcx, taunt_array ;move array address into rcx
    mov rax, 8 ;multiplier
    sub rdi, 1 ;sub one since array is zero indexed
    mul rdi ;rdi * 8, result in rax
    add rcx, rax ;move to appropriate string

    mov rdi, fmt ;move first arg into rdi
    mov rsi, [rcx] ;put current taunt string into rsi (second arg)
    call printf wrt ..plt ;print current taunt
    pop rax ;pop off rax since we need return addy on top of stack
    ret ;return from function call