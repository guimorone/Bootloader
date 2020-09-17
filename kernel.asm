org 0x7e00
jmp 0x0000:start

COUNT dw 0  ; percorre array_primo
ARRAY_PRIMO dw 17,313,421,173,59,37,73,197
TAM_ARRAY_PRIMO dw 8

criadores_string dw "CRIADORES:", 0
bilas_string dw "wssf (bilas)", 0
braia_string dw "gma2 (braia)", 0
labo_string dw "elm2 (labo)", 0
press_esc dw "Pressione ESC para voltar ao menu", 0

jogar_string dw "JOGAR (1)", 0
creditos_string dw "CREDITOS (2)", 0
sair_string dw "SAIR (3)", 0

pontuacao dw "NEO, SUA PONTUACAO FOI:", 0

CURSOR_X dw 0
CURSOR_Y dw 0

GAME_TIME dw 0

BALAS_X dw 100,200,300,150,250
BALAS_Y dw 100,150,56,150,25
BALA_X dw 100                   ;POSICAO DAS BALAS
BALA_Y dw 100

BALA_SIZE_X dw 07h              ;TAMANHO DAS BALAS
BALA_SIZE_Y dw 03h
BALA_SIZE_HORIZONTAL_X dw 07h
BALA_SIZE_HORIZONTAL_Y dw 03h
BALA_SIZE_VERTICAL_X dw 03h
BALA_SIZE_VERTICAL_Y dw 07h

BALAS_VELX dw 05h, 05h, -05h
BALAS_VELY dw 05h, -05h
BALA_VELX dw 05h                ;VELOCIDADE DAS BALAS 
BALA_VELY dw 05h

BALL_X dw 0Ah
BALL_Y dw 0Ah
BALL_SIZE dw 09h
BALL_VELX dw 06h
BALL_VELY dw 06h                ;BOLA CARACTERISTICAS

VAR_COLISAO db 0

jogador db 0, 0, 15, 15, 15, 15, 0, 0
        db 0, 0, 15, 15, 15, 15, 0, 0
        db 0, 0, 15, 15, 15, 15, 0, 0
        db 0, 0, 15, 15, 15, 15, 0, 0
        db 0, 0, 0, 15, 15, 0, 0, 0
        db 0, 0, 0, 0, 15, 15, 0, 0
        db 0, 0, 0, 0, 15, 0, 15, 0
        db 0, 0, 0, 0, 15, 0, 0, 15
        db 0, 0, 0, 15, 0, 15, 0, 0
        db 0, 0, 15, 0, 0, 0, 15, 0
        db 0, 15, 0, 0, 0, 0, 0, 15




menu:
    

    mov si, jogar_string
    mov dh, 0Bh
    mov dl, 0eh
    call set_cursor
    call print_string

    mov si, creditos_string
    mov dh, 0Dh
    mov dl, 0eh
    call set_cursor
    call print_string

    mov si, sair_string
    mov dh, 0Fh
    mov dl, 0eh
    call set_cursor
    call print_string

    mov ah, 0Ch        ;clear buffer
    int 21h

    call wait_char

    cmp al, '1'
    je jogar

    cmp al, '2'
    je .ircreditos

    cmp al, '3'
    je .fim

    jmp menu

    .ircreditos:
        call clear_screen
        jmp creditos

    .fim:
        call clear_screen
    
    ret


creditos:
    
    mov si, criadores_string
    mov dh, 03h
    mov dl, 0Fh
    call set_cursor
    call print_string

    mov si, bilas_string
    mov dh, 05h
    mov dl, 0Eh
    call set_cursor
    call print_string

    mov si, braia_string
    mov dh, 07h
    mov dl, 0Eh
    call set_cursor
    call print_string

    mov si, labo_string
    mov dh, 09h
    mov dl, 0Eh
    call set_cursor
    call print_string

    mov si, press_esc
    mov dh, 13h
    mov dl, 04h
    call set_cursor
    call print_string

    call wait_char

    cmp al, 27
    je .irmenu

    jmp creditos

    .irmenu:
        call clear_screen
        jmp menu

    ret


jogar:
    ;mov ah, 2Ch
    ;int 21h

    mov cx, 0             ;delay
    mov dx, 30000         ;delay 
    mov ah, 86h           ;delay
    int 15h               ;delay
    
    inc word [GAME_TIME]
 
    mov ah, 0Ch
    int 21h

    call clear_screen

    call atribui_mover_bala

    call atribui_draw_bala

    call wait_char

    call mover_ponde

    mov ah, 0Ch
    int 21h

    call draw_ball

    call atribui_compara_colisao

    cmp byte [VAR_COLISAO], 0
    je jogar

    call clear_screen
    mov byte [VAR_COLISAO], 0
    mov word [BALL_X], 0Ah
    mov word [BALL_Y], 0Ah
    ;mov dword [BALL_SIZE], 09h
    jmp printa_pontuacao


printa_pontuacao:

    call clear_screen

    xor dx, dx
    mov ax, word [GAME_TIME]
    mov bx, 10000
    div bx
    mov ax, dx
    xor dx, dx
    mov bx, 1000
    div bx
    add ax, 48
    push dx
    mov dh, 14h
    mov dl, 1Dh
    call set_cursor
    call print_char
    pop dx

    mov ax, dx
    mov bl, 100
    div bl
    add al, 48
    push ax
    mov dh, 14h
    mov dl, 1Eh
    call set_cursor
    call print_char
    pop ax

    mov al, ah
    xor ah, ah
    mov bl, 10
    div bl
    add al, 48
    push ax
    mov dh, 14h
    mov dl, 1Fh
    call set_cursor
    call print_char
    pop ax

    mov al, ah
    add al, 48
    mov dh, 14h
    mov dl, 20h
    call set_cursor
    call print_char

    mov word [GAME_TIME], 0

    mov si, pontuacao
    mov dh, 14h
    mov dl, 05h
    call set_cursor
    call print_string

    mov cx, 50             ;delay
    mov dx, 30000         ;delay 
    mov ah, 86h           ;delay
    int 15h    

    call clear_screen

    jmp menu


atribui_mover_bala:
    mov ax,[BALAS_X+0]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+0]
    mov [BALA_Y],ax
    mov ax, [BALAS_VELX+0]
    mov [BALA_VELX], ax

    call mover_bala_horizontal

    mov ax,[BALA_X]
    mov [BALAS_X+0],ax
    mov ax, [BALA_Y]
    mov [BALAS_Y+0],ax

    mov ax,[BALAS_X+1*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+1*2]
    mov [BALA_Y],ax
    mov ax, [BALAS_VELX+1*2]
    mov [BALA_VELX], ax

    call mover_bala_horizontal

    mov ax,[BALA_X]
    mov [BALAS_X+1*2],ax
    mov ax, [BALA_Y]
    mov [BALAS_Y+1*2],ax

    mov ax,[BALAS_X+2*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+2*2]
    mov [BALA_Y],ax
    mov ax, [BALAS_VELX+2*2]
    mov [BALA_VELX], ax

    call mover_bala_horizontal_neg

    mov ax,[BALA_X]
    mov [BALAS_X+2*2],ax
    mov ax, [BALA_Y]
    mov [BALAS_Y+2*2],ax

    mov ax,[BALAS_X+3*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+3*2]
    mov [BALA_Y],ax
    mov ax, [BALAS_VELY+0]
    mov [BALA_VELY], ax

    call mover_bala_vertical

    mov ax,[BALA_X]
    mov [BALAS_X+3*2],ax
    mov ax, [BALA_Y]
    mov [BALAS_Y+3*2],ax
    
    mov ax,[BALAS_X+4*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+4*2]
    mov [BALA_Y],ax
    mov ax, [BALAS_VELY+1*2]
    mov [BALA_VELY], ax

    call mover_bala_vertical_neg

    mov ax,[BALA_X]
    mov [BALAS_X+4*2],ax
    mov ax, [BALA_Y]
    mov [BALAS_Y+4*2],ax

    ret

atribui_draw_bala:
    mov ax,[BALAS_X+0]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+0]
    mov [BALA_Y],ax
    mov ax, [BALA_SIZE_HORIZONTAL_X]
    mov [BALA_SIZE_X], ax
    mov ax, [BALA_SIZE_HORIZONTAL_Y]
    mov [BALA_SIZE_Y], ax

    call draw_bala

    mov ax,[BALAS_X+1*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+1*2]
    mov [BALA_Y],ax
    mov ax, [BALA_SIZE_HORIZONTAL_X]
    mov [BALA_SIZE_X], ax
    mov ax, [BALA_SIZE_HORIZONTAL_Y]
    mov [BALA_SIZE_Y], ax

    call draw_bala

    mov ax,[BALAS_X+2*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+2*2]
    mov [BALA_Y],ax
    mov ax, [BALA_SIZE_HORIZONTAL_X]
    mov [BALA_SIZE_X], ax
    mov ax, [BALA_SIZE_HORIZONTAL_Y]
    mov [BALA_SIZE_Y], ax

    call draw_bala

    mov ax,[BALAS_X+3*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+3*2]
    mov [BALA_Y],ax
    mov ax, [BALA_SIZE_VERTICAL_X]
    mov [BALA_SIZE_X], ax
    mov ax, [BALA_SIZE_VERTICAL_Y]
    mov [BALA_SIZE_Y], ax

    call draw_bala

    mov ax,[BALAS_X+4*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+4*2]
    mov [BALA_Y],ax
    mov ax, [BALA_SIZE_VERTICAL_X]
    mov [BALA_SIZE_X], ax
    mov ax, [BALA_SIZE_VERTICAL_Y]
    mov [BALA_SIZE_Y], ax

    call draw_bala

    ret

atribui_compara_colisao:
    mov ax,[BALAS_X+0]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+0]
    mov [BALA_Y],ax

    call compara_pos_X
    cmp byte [VAR_COLISAO], 1
    je .finished

    mov ax,[BALAS_X+1*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+1*2]
    mov [BALA_Y],ax

    call compara_pos_X
    cmp byte [VAR_COLISAO], 1
    je .finished

    mov ax,[BALAS_X+2*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+2*2]
    mov [BALA_Y],ax

    call compara_pos_X
    cmp byte [VAR_COLISAO], 1
    je .finished

    mov ax,[BALAS_X+3*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+3*2]
    mov [BALA_Y],ax

    call compara_pos_X
    cmp byte [VAR_COLISAO], 1
    je .finished

    mov ax,[BALAS_X+4*2]
    mov [BALA_X],ax
    mov ax, [BALAS_Y+4*2]
    mov [BALA_Y],ax

    call compara_pos_X
    cmp byte [VAR_COLISAO], 1
    je .finished
    
    .finished:
        ret

compara_pos_X:
    mov ax, [BALL_X]
    add ax, [BALL_SIZE]
    cmp ax, [BALA_X]
    jg .compara_pos_X2
    ret
    .compara_pos_X2:
    mov ax, [BALL_X]
    cmp ax, [BALA_X]
    jng compara_pos_Y
    ret

compara_pos_Y:
    mov ax, [BALL_Y]
    add ax, [BALL_SIZE]
    cmp ax, [BALA_Y]
    jg .compara_pos_Y2
    ret
    .compara_pos_Y2:
    mov ax, [BALL_Y]
    cmp ax, [BALA_Y]
    jg .no_colision
    mov byte [VAR_COLISAO], 1

    .no_colision:
        ret 

draw_bala:
    mov ax,0
    cmp [BALA_X],ax
    jng .naodesenha

    mov ax,310
    cmp [BALA_X],ax
    jg .naodesenha

    mov ax, 0
    cmp [BALA_Y], ax
    jng .naodesenha

    mov ax, 190
    cmp [BALA_Y], ax
    jg .naodesenha

    mov cx, [BALA_X]
    mov dx, [BALA_Y]

    call draw_bala_loop
    .naodesenha:
        ret

draw_bala_loop:
    xor ax, ax
    mov ah, 0Ch
    mov al, 0Fh
    mov bh, 00h
    int 10h

    inc cx
    mov ax, cx
    sub ax, [BALA_X]
    cmp ax, [BALA_SIZE_X]
    jng draw_bala_loop

    mov cx, [BALA_X]
    inc dx
    mov ax, dx
    sub ax, [BALA_Y]
    cmp ax, [BALA_SIZE_Y]
    jng draw_bala_loop

    ret

mover_bala_horizontal:
    mov ax, [BALA_VELX]
    sub [BALA_X], ax
    mov ax, -10
    cmp [BALA_X], ax
    jg .finished

    mov ax, 340
    mov [BALA_X], ax

    call compara_count

    call get_system_time
    mov ax,dx

    mov bx , ARRAY_PRIMO
    add bx, [COUNT]
    mov bx, [bx]

    mul bl
    mov bl,190
    div bl
    add ah,40
    mov [BALA_Y],ah

    .finished:
        ret

mover_bala_horizontal_neg:
    mov ax, [BALA_VELX]
    sub [BALA_X], ax
    mov ax, 340
    cmp [BALA_X], ax
    jl .finished

    mov ax, -10
    mov [BALA_X], ax

    call compara_count

    call get_system_time
    mov ax,dx

    mov bx , ARRAY_PRIMO
    add bx, [COUNT]
    mov bx, [bx]

    mul bl
    mov bl,190
    div bl
    add ah,5
    mov [BALA_Y],ah

    .finished:
        ret

mover_bala_vertical:
    mov ax, [BALA_VELY]
    sub [BALA_Y], ax
    mov ax, -10
    cmp [BALA_Y], ax
    jg .finished

    mov ax, 220
    mov [BALA_Y], ax

    call compara_count

    call get_system_time
    mov ax,dx

    mov bx , ARRAY_PRIMO
    add bx, [COUNT]
    mov bx, [bx]

    mul bl
    mov bl,190
    div bl
    add ah,5
    mov [BALA_X],ah

    .finished:
        ret

mover_bala_vertical_neg:
    mov ax, [BALA_VELY]
    sub [BALA_Y], ax
    mov ax, 220
    cmp [BALA_Y], ax
    jl .finished

    mov ax, -10
    mov [BALA_Y], ax

    call compara_count

    call get_system_time
    mov ax,dx

    mov bx , ARRAY_PRIMO
    add bx, [COUNT]
    mov bx, [bx]

    mul bl
    mov bl,190
    div bl
    add ah,5
    mov [BALA_X],ah

    .finished:
        ret

compara_count:
    inc word [COUNT]
    mov ax, 8
    cmp [COUNT], ax
    jl .finished

    xor ax, ax
    mov [COUNT], ax

    .finished:
        ret

get_system_time:
    mov ah,00h
    int 1ah

    ret
print_char:
    mov ah, 0eh
    mov bl, 0Fh
    int 10h

    ret

print_string:
    lodsb       
    cmp al, 0
    je .end
    call print_char
    jmp print_string
    
    .end:
        ret

set_cursor:
    mov ah, 02h
    mov bh, 00h
    int 10h

    ret

wait_char:
    mov ah, 01h
    int 16h
    jnz get_char

    ret

get_char:
    mov ah, 00h
    int 16h

    ret

mover_ponde:
    cmp al, 's'
    je move_ball_down

    cmp al, 'w'
    je move_ball_up

    cmp al, 'a'
    je move_ball_left

    cmp al, 'd'
    je move_ball_right

    ret

move_ball_down:
    mov ax, [BALL_VELY]
    add [BALL_Y], ax

    mov ax, 198
    sub ax, [BALL_SIZE]
    cmp [BALL_Y], ax
    jng .finished
    mov ax, 198
    sub ax, [BALL_SIZE]
    mov [BALL_Y], ax

    .finished:
        ret

move_ball_up:
    mov ax, [BALL_VELY]
    sub [BALL_Y], ax

    mov ax, 0
    cmp [BALL_Y], ax
    jg .finished
    mov ax, 0
    mov [BALL_Y], ax

    .finished:
        ret

move_ball_right:
    mov ax, [BALL_VELX]
    add [BALL_X], ax

    mov ax, 318
    sub ax, [BALL_SIZE]
    cmp [BALL_X], ax
    jng .finished
    mov ax, 318
    sub ax, [BALL_SIZE]
    mov [BALL_X], ax

    .finished:
        ret
    
move_ball_left:
    mov ax, [BALL_VELX]
    sub [BALL_X], ax


    mov ax, 0
    cmp [BALL_X], ax
    jg .finished
    mov ax, 0
    mov [BALL_X], ax

    .finished:
        ret

clear_screen:

    mov ah, 00h
    mov al, 13h
    int 10h


    ret

draw_ball:
    mov cx, [BALL_X]
    mov dx, [BALL_Y]

    call draw_ball_loop
    
    ret

draw_ball_loop:
    xor ax, ax
    mov ah, 0Ch
    mov al, 0Fh
    mov bh, 00h
    int 10h

    inc cx
    mov ax, cx
    sub ax, [BALL_X]
    cmp ax, [BALL_SIZE]
    jng draw_ball_loop

    mov cx, [BALL_X]
    inc dx
    mov ax, dx
    sub ax, [BALL_Y]
    cmp ax, [BALL_SIZE]
    jng draw_ball_loop
    
    ret

start:

    mov ah, 00h
    mov al, 13h
    int 10h

    call clear_screen
    
    call menu

    ret

jmp $ 