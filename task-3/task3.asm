%include "printf32.asm"
extern printf
extern qsort
extern strcmp
extern strlen

global get_words
global compare_func
global sort

section .data
    shift:    dd 0
    aux:    dd 0

section .text

banane:
    enter 0,0

    mov eax, [ebp + 8]
    mov eax, [eax]
    push eax
    call strlen                         ; aflu lungimea primului string
    add esp, 4

    mov dword[aux], eax

    mov ecx, [ebp + 12]
    mov ecx, [ecx]
    push ecx
    call strlen                         ; aflu lungimea celui de-al doilea
    add esp, 4
    
    sub dword[aux], eax                 ; scad lungimile intre ele
    mov eax, dword[aux]                 ; cri cri cri

    ;PRINTF32 `%d\n\x0`, eax

    cmp eax, 0
    jne finished

    mov eax, [ebp + 8]
    mov eax, [eax]
    push eax
    mov ecx, [ebp + 12]
    mov ecx, [ecx]
    push ecx
    call strcmp
    add esp, 8
    neg eax

    finished:
    leave
    ret

sort:
    enter 0, 0
    mov edi, [ebp + 8]                  ; adresa catre vectorul de cuvinte
    mov esi, [ebp + 12]                 ; numarul de cuvinte
    mov edx, [ebp + 16]                 ; dimenziunea unui cuvant
    mov ecx, banane                     ; functia de comparare    
    push ecx
    push edx
    push esi
    push edi

    call qsort
    add esp, 16
    leave
    ret

get_words:
    enter 0, 0
    mov eax, [ebp + 8]                  ; string-ul s de caractere
    mov edi, [ebp + 12]                 ; adresa catre vectorul de cuvinte
    mov edi, [edi]
    mov ecx, [ebp + 16]                 ; numarul de cuvinte

    xor edx, edx                        ; folosit pt pozitionarea in s
    mov ebx, 0
    
    divide_into_words:
        mov esi, 0
        take_char:
            cmp byte[eax + edx], 0x00
            je skip
            cmp byte[eax + edx], ' '
            je skip
            cmp byte[eax + edx], '.'
            je soft_skip
            cmp byte[eax + edx], ','
            je soft_skip
            cmp byte[eax + edx], 0Dh
            je skip
            cmp byte[eax + edx], 0Ah
            je skip

            mov bh, byte[eax + edx]     ; preiau litera din string-ul s
            mov edi, [ebp + 12]
            add edi, dword[shift]
            mov edi, [edi]
            mov byte[edi + esi], bh     ; o inserez in vectorul de cuvinte
            inc edx                     ; trec la urmatoarea litera din s
            inc esi                     ; urmatoarea litera din words
        jmp take_char
        soft_skip:                      ; doar sar peste delimitator, cuvantul
            inc edx                     ; se afla dupa spatiul de dupa virgula
            jmp take_char
        skip:
            inc edx                     ; sar peste delimitator
            add dword[shift], 4
        next:
    loop divide_into_words
    
    done:
    leave
    ret
