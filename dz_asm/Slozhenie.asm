section .data 
    num1 dd 123         ; первое число
    num2 dd 456         ; второе число
    result dd 0         ; результат переменная
    
    msg db "Sum = "     
    msg_len equ $-msg   
    
    newline db 10       ; перевод строки
    
    buffer times 12 db 0 ; буфер для строки
    
section .text
    global _start

_start:
    mov eax, [num1]     ; загружаем первое число в eax
    add eax, [num2]     ; прибавляем второе число
    mov [result], eax   
    ; надо вывести ответ
    mov rax, 1          
    mov rdi, 1          
    mov rsi, msg        
    mov rdx, msg_len    
    syscall
    
    ; преобразуем число в строку
    mov eax, [result]
    mov rdi, buffer+11
    mov byte [rdi], 0   ; ставим ноль в конец строки
    mov rbx, 10         ; делить на 10 будем
    
    test eax, eax       ; чекаем положительное или нет
    jns .convert        
    
    
.convert:
    ; делим на 10
    xor edx, edx        ; обнуляем edx
    div ebx             ; делим eax на ebx
    ; результат в eax, остаток в edx
    
    add dl, '0'         ; превращаем цифру в символ
    dec rdi             ; двигаемся назад по буферу
    mov [rdi], dl       ; ссохраняем символ в буфер
    
    ; если не ноль то дальше идем
    test eax, eax
    jnz .convert        ; пока eax не ноль
    
    ; выводим
    mov rsi, rdi        ; начало строки
    ; Нужно вычислить длину
    mov rdx, buffer+11  ; конец буфера
    sub rdx, rdi
    
    mov rax, 1
    mov rdi, 1
    syscall
    
    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; код 0
    syscall
