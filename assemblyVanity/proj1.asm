;amit bhandal 014172912

section .data
    name db "amit bhandal"
    len dq 12
    newLine db `\n`

section .text
    global _start

_start:
    mov rbx, 1 ;set substring index
    mov rcx, [len] ;set rcx to size of string

    loop:
        ;print current substring
        mov rax, 1 ;call on rax register
        mov rdi, 1 ;first arg: STDOUT
        mov rsi, name ;second arg: message to STDOUT
        mov rdx, rbx ;thrid arg: length of messagee
        syscall ;invoke kernal

        ;print new line
        mov rax, 1
        mov rdi, 1
        mov rsi, newLine
        mov rdx, 1
        syscall

        mov rcx, [len] ;rcx changes on syscall, so reset it
        sub rcx, rbx ;then subtract current substring size from rcx

    add rbx, 1 ;increment rbx
    sub rcx, 0 ;subtract with 0 since we already did operation in loop but the jnz command looks if last operation was not zero so we just subtract 0 to jnz looks at rcx operation
    jnz loop ;if rcx is not zero then loop again
    
    ;another way of doing it, but we can't since we can only use jmp or jnz for this assignement
    ;sub rcx, 1 ;decrement rcx
    ;cmp rbx, rcx ;compare rbx and rcx
    ;jle loop ;if rbx(counter) <= rcx(len), loop again

    ;exit
    mov rax, 60
    mov rdi, 0 ;exit code of 0
    syscall