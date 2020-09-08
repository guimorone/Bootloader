org 0x7c00
jmp 0x0000:start

BALL_X dw 0Ah
BALL_Y dw 0Ah
BALL_SIZE dw 09h
BALL_VELX dw 05h
BALL_VELY dw 05h
TIME db 0

timer:
    ;mov ah, 2Ch
    ;int 21h

    ;mov cx, 0             ;delay
    ;mov dx, 20000             ;delay 
    ;mov ah, 86h           ;delay
    ;int 15h               ;delay

    ;call clear_screen

    call wait_char

    ;call mover_ponde

    ;call draw_ball

    jmp timer

    ret

print_char:
    mov ah, 0xe
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

    call mover_ponde

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

    call draw_ball

    ret

move_ball_up:
    mov ax, [BALL_VELY]
    sub [BALL_Y], ax

    call draw_ball

    ret

move_ball_right:
    mov ax, [BALL_VELX]
    add [BALL_X], ax

    call draw_ball

    ret
    
move_ball_left:
    mov ax, [BALL_VELX]
    sub [BALL_X], ax

    call draw_ball

    ret

clear_screen:
    mov ah, 00h
    mov al, 13h
    int 10h

    mov ah, 0Bh
    mov bh, 00h
    mov bl, 00h
    int 10h

    ret

draw_ball:
    mov cx, [BALL_X]
    mov dx, [BALL_Y]

    call clear_screen
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

    call clear_screen

    call draw_ball
    
    call timer



    ret


times 510 - ($ - $$) db 0
dw 0xaa55