org 0x7e00
jmp 0x0000:start

BALA1_X dw 100
BALA1_Y dw 100
BALA_SIZE_X dw 07h
BALA_SIZE_Y dw 03h
BALA_VELX dw 05h
BALL_X dw 0Ah
BALL_Y dw 0Ah
BALL_SIZE dw 09h
BALL_VELX dw 05h
BALL_VELY dw 05h
TIME db 0
VAR_COLISAO db 0

timer:
    ;mov ah, 2Ch
    ;int 21h

    mov cx, 0             ;delay
    mov dx, 30000         ;delay 
    mov ah, 86h           ;delay
    int 15h               ;delay

    mov ah, 0Ch
    int 21h

    call clear_screen


    mov bh,0
    mov dh,0
    mov dl,0
    mov ah,02h
    int 10h
    mov al, 'a'
    call print_char

    mov ah,6
    mov dl,'d'
    int 21h

    call mover_bala

    call draw_bala

    call wait_char

    call mover_ponde

    mov ah, 0Ch
    int 21h

    call draw_ball

    call compara_pos_X

    cmp byte [VAR_COLISAO], 0
    je timer

    ret

compara_pos_X:
    mov ax, [BALL_X]
    add ax, [BALL_SIZE]
    cmp ax, [BALA1_X]
    jng .compara_pos_X2
    ret
    .compara_pos_X2:
    mov ax, [BALL_X]
    cmp ax, [BALA1_X]
    jg compara_pos_Y
    ret

compara_pos_Y:
    mov ax, [BALL_Y]
    add ax, [BALL_SIZE]
    cmp ax, [BALA1_Y]
    jng .compara_pos_Y2
    ret
    .compara_pos_Y2:
    mov ax, [BALL_Y]
    cmp ax, [BALA1_Y]
    jng .no_colision
    mov byte [VAR_COLISAO], 1

    .no_colision:
        ret 

draw_bala:
    mov cx, [BALA1_X]
    mov dx, [BALA1_Y]

    call draw_bala_loop

    ret

draw_bala_loop:
    xor ax, ax
    mov ah, 0Ch
    mov al, 0Fh
    mov bh, 00h
    int 10h

    inc cx
    mov ax, cx
    sub ax, [BALA1_X]
    cmp ax, [BALA_SIZE_X]
    jng draw_bala_loop

    mov cx, [BALA1_X]
    inc dx
    mov ax, dx
    sub ax, [BALA1_Y]
    cmp ax, [BALA_SIZE_Y]
    jng draw_bala_loop

    ret

mover_bala:
    mov ax, [BALA_VELX]
    sub [BALA1_X], ax
    mov ax, 0
    cmp [BALA1_X], ax
    jg .finished
    mov ax, 330
    mov [BALA1_X], ax

    .finished:
        ret

print_char:
    mov ah, 0eh
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
    
    call timer

    call clear_screen

    ret

jmp $ 