extern qsort
extern strcmp
extern strlen

global get_words
global compare_func
global sort

section .data
    shift:  dd  0                       ; folosit pt inserarea in **words
    aux:    dd  0                       ; variabila auxiliara

section .text

cmp:
    enter 0,0

    mov eax, [ebp + 8]
    mov eax, [eax]
    push eax
    call strlen                         ; in aux = lungimea primului string
    add esp, 4

    mov dword[aux], eax                 ; retin in aux lungimea cuvantului

    mov ecx, [ebp + 12]
    mov ecx, [ecx]
    push ecx
    call strlen                         ; aux = lung. celui de-al 2lea cuvant
    add esp, 4
    
    sub dword[aux], eax                 ; scad lungimile intre ele, si dupa aux
    mov eax, dword[aux]                 ; se decide cum vor fi interschimbate

    cmp eax, 0                          ; daca cuvintele au lungimi egale, gata
    jne finished

    mov eax, [ebp + 8]                  ; altfel trebuie sortate lexicografic
    mov eax, [eax]
    push eax                            ; pun pe stiva cele doua cuvinte
    mov ecx, [ebp + 12]
    mov ecx, [ecx]
    push ecx
    call strcmp                         ; apelez strcmp, va trebui sa schimb
    add esp, 8
    neg eax                             ; semnul rezultatului pt a sorta

    finished:
    leave
    ret

sort:
    enter 0, 0
    mov edi, [ebp + 8]                  ; adresa catre vectorul de cuvinte
    mov esi, [ebp + 12]                 ; numarul de cuvinte
    mov edx, [ebp + 16]                 ; dimenziunea unui cuvant
    mov ecx, cmp                        ; functia de comparare    
    push ecx
    push edx
    push esi
    push edi

    call qsort                          ; apelez qsort pentru sortare
    add esp, 16                         ; curat stiva
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
            cmp byte[eax + edx], 0x00   ; caracter null
            je skip
            cmp byte[eax + edx], ' '
            je skip
            cmp byte[eax + edx], '.'
            je soft_skip                ; soft_skip sare doar peste caracter
            cmp byte[eax + edx], ','
            je soft_skip                ; fara a considera punctul un cuvant
            cmp byte[eax + edx], 0Dh    ; carriage return
            je skip
            cmp byte[eax + edx], 0Ah    ; line feed
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
            inc edx                     ; se afla dupa spatiul de dupa , sau .
            jmp take_char
        skip:
            inc edx                     ; sar peste delimitator
            add dword[shift], 4         ; "trec" la urmatorul element din words
        next:
    loop divide_into_words
    
    done:
    leave
    ret
