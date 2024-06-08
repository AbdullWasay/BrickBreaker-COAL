;GROUP MEMBER 1: ABDUL WASAY I210834
;GROUP MEMBER 2: TALHA ZAHOR I210867


.model small
.stack 100H
.data
	;-----------------BRICK---------------------
	
	temp dw 0
	temp1 dw 0
	temp2 dw 0
	temp3 dw 0
	clr db 0
	lengthstorer db 0
	;-------------------MENU-----------------------------
	NameStorer db 60 dup (?)
	string db '------->  BRICK BREAKER  <-------','$'
	string1 db '--> ENTER YOUR NAME : ','$'
	string2 db 'BRICK GAME' , '$'
	string3 db '. START GAME' , '$'
	string4 db '. INSTRUCTIONS' , '$'
	string5 db '. EXIT' , '$'
	;--------------------INSTRUCTIONS------------------------
	in1 db '-------------------------------- INSTRUCTIONS ----------------------------------','$'
	ins1 db '---> Welcome To Brick Breaker <---','$'
	ins2 db '. Use Left and Right Arrow Keys To Move the Paddle','$'
	ins3 db '. There Are 3 Levels Of The Game ','$'
	ins4 db '. Each Brick Hit Is Worth 10 Points ','$'
	ins5 db '. Press Esc To Exit ','$'
	ins6 db '-- Press Enter To Go To Main Menu --','$'
	ins7 db '--------------------------------------------------------------------------------','$'
	;------------------------------------------------------------
	cursor1 dw 0
	cursor2 dw 0
	scoree dw 0
	score dB 'Score : ' , '$'
	namee dB 'NAME  : ' , '$'
	easy11 dB    'LEVEL : 1' , '$'
	mediumm11 dB 'LEVEL : 2' , '$'
	hard11 dB    'LEVEL : 3' , '$'
	heart1 db 3
	p db 'PAUSED','$'
	h1 dw 300
	h2 dw 320
	gameover db ' GAME OVER ','$'
	;------------------------------------LEVELS-------------------------------
	easy db '. LEVEL 01','$'
	mediumm db '. LEVEL 02','$'
	hard db '. LEVEL 03','$'
	
	easy1 db 'LEVEL 01','$'
	mediumm1 db 'LEVEL 02','$'
	hard1 db 'LEVEL 03','$'
	;--------------------------------------GAME WORKING------------------------------------------
	x dw 155        ;starting x of ball
	y dw 160		;starting y of ball
	x_ball dw 160	;ending x of ball
	y_ball dw 165	;ending y of ball
	ball_speed dw 500 
	gamewin db ' !!! YOU WON !!!','$'
	totScore db 'SCORE : 140','$'
	totScore2 db 'SCORE : 170','$'

	f1 db "file.txt", 0
	fileinfo dw 0
	
	bar_start dw 150
	bar_end dw 205
	bar_y dw 195	
	brick_hits dw 0
	BREAK_COLOR DB 0
	SB DW 0
	
	counter dw 0
	initial dw 115
	
	direction dw 3      ;1= right 2=top 3=left 4=bottom
	lives dw 3
	angle_horizontal dw 1 ; 1=right->left 2=left->right
	angle_vertical dw 1   ; 1=top->bottom 2=bottom->top
	
	check_up dw 0
	ball_color db 0
	
	brick_x_start dw 0
	brick_x_end dw 0
	brick_y_start dw 0
	brick_y_end dw 0
	LEVELS dw 0
	
	special_reward_x dw 20
	special_reward_y dw 85
	special_reward_x_end dw 30
	special_reward_y_end dw 95
	sb2 dw 0
	single_hit_reward dw 0
	
	c1 dw 0
	c2 dw 0
	
.code

jmp main

;--------------------------------------------------- BEEP PROCEDURE --------------------------------------------------------
BEEP PROC 

        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 1000        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 35         ; Pause for duration of note.
pause1:
        mov     cx, 1000
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 10001100b   ; Reset bits 1 and 0.
        out     61h, al 

RET
BEEP ENDP



;----------------------------------------------------- REWARD -----------------------------------------------------
delete_reward proc

mov cx,special_reward_x
mov dx,special_reward_y

L1:

MOV CX,special_reward_x

	L2:

	MOV AL, 0
	MOV AH, 0CH
	INT 10H

	INC CX
	CMP CX,special_reward_x_end
	JNE L2

	INC DX

	CMP DX,special_reward_y_end
	JNE L1
ret
delete_reward endp

reward proc

mov ah,0dh
int 10h

cmp al,0
je no

mov bar_end,80
mov single_hit_reward,1
no:
ret
reward endp

special_reward proc

mov cx,special_reward_x
mov dx,special_reward_y

cmp special_reward_y,195
jae lost
L1:

MOV CX,special_reward_x

	L2:

	MOV AL, 0dh
	MOV AH, 0CH
	INT 10H

	INC CX
	CMP CX,special_reward_x_end
	JNE L2

	INC DX

	CMP DX,special_reward_y_end
	JNE L1
jmp done		
lost:
mov sb2,0
done:
ret 
special_reward endp


;---------------------------------------------- SPECIAL BRICK BREAK ------------------------------------------
SPECIAL_BREAK  PROC
CALL BEEP
mov dx,brick_y_start
	LLL1:
		MOV CX, brick_x_start
		LLL2:
			MOV AL, 0
			MOV AH, 0CH
			INT 10H
			
			INC CX
			CMP CX,brick_x_end
		JNE LLL2
		
		INC DX
		
		CMP DX,brick_y_end
	JNE LLL1
	
	mov clr,0
	mov temp1,6
	mov bx,temp1
	mov temp,51
	mov temp2,35
	mov temp3,45
	call brick
	
	mov clr,0
	mov temp1,83
	mov bx,temp1
	mov temp,128
	mov temp2,55
	mov temp3,65
	call brick
	
	mov clr,0
	mov temp1,112
	mov bx,temp1
	mov temp,157
	mov temp2,75
	mov temp3,85
	call brick
	
	mov clr,0
	mov temp1,185
	mov bx,temp1
	mov temp,240
	mov temp2,55
	mov temp3,65
	call brick
	
	mov clr,0
	mov temp1,271
	mov bx,temp1
	mov temp,316
	mov temp2,35
	mov temp3,45
	call brick
	
	add scoree,60
call UpdateScore
mov sb2,1
	
ret	
SPECIAL_BREAK ENDP



;--------------------------------------------------- BRICK BREAK --------------------------------------------------------
BREAK PROC

mov dx,brick_y_start



	LLL1:
		MOV CX, brick_x_start
		LLL2:
			MOV AL, BREAK_COLOR
			MOV AH, 0CH
			INT 10H
			
			INC CX
			CMP CX,brick_x_end
		JNE LLL2
		
		INC DX
		
		CMP DX,brick_y_end
	JNE LLL1
	call BEEP
ret	
BREAK ENDP
		
		
;------------------------------- FINDING Y -----------------------------		
FIND_BRICK_Y PROC

find_y:
	mov dx,brick_y_start

	mov ah,0dh	
	int 10h
	
	cmp al,0
	je y_found
dec brick_y_start
jmp find_y
y_found:
ret
FIND_BRICK_Y ENDP		
		

;------------------------------- FINDING X -----------------------------		
FIND_BRICK_X PROC
add dx,2
find_x:
	mov cx,brick_x_start

	mov ah,0dh	
	int 10h
	
	cmp al,0
	je x_found
dec brick_x_start
jmp find_x
x_found:
ret
FIND_BRICK_X ENDP





;-----------------------------------------------------------------------------------------------------------------------
;------------------------------------------------ BRICK COLLISION PROCEDURES -------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------



;------------------------------------------------------- BOTTOM HIT -----------------------------------------------------
BOTTOM_HIT PROC

MOV DIRECTION,2
cmp angle_vertical,1
je P1

cmp angle_vertical,2
je P2

P1:
call TOP_BORDER_LEFT_TO_RIGHT
jmp A
P2:
call TOP_BORDER_RIGHT_TO_LEFT

A:
CMP AL,0FH
JE subscore
mov ax,y
MOV brick_y_end , ax
mov brick_y_start,ax
sub brick_y_start,10

mov ax,x_ball

mov brick_x_start,ax
mov dx,brick_y_start

CALL FIND_BRICK_X

inc brick_x_start
mov ax, brick_x_start
mov brick_x_end,ax
add brick_x_end,46

CMP brick_x_end,319
je donee
cmp sb,1
je special
call BREAK 
jmp donee

special:

call SPECIAL_BREAK 
jmp donee 
subscore:
sub scoree,10
call UpdateScore
donee:                 
RET
BOTTOM_HIT ENDP

;------------------------------------------------------- TOP HIT -----------------------------------------------------
TOP_HIT PROC


			mov direction,4
			
			cmp angle_vertical,2
			je Q1
			
			cmp angle_vertical,1
			je Q2
			
			Q1:
			call BOTTOM_BORDER_RIGHT_TO_LEFT
			JMP B
		
			Q2:
			call BOTTOM_BORDER_LEFT_TO_RIGHT
			
B:
CMP AL,0FH
JE subscore

mov ax,y_ball
MOV brick_y_start , ax
mov brick_y_end,ax
add brick_y_end,11

mov ax,x

mov brick_x_start,ax
mov dx,brick_y_start

CALL FIND_BRICK_X

mov ax, brick_x_start
mov brick_x_end,ax
add brick_x_end,46
cmp sb,1
je special
call BREAK 
jmp donee

special:

call SPECIAL_BREAK  
CALL BREAK

jmp donee 
subscore:
sub scoree,10
call UpdateScore
donee:                             
RET		

TOP_HIT ENDP

;------------------------------------------------------- LEFT HIT -----------------------------------------------------

LEFT_HIT PROC

			mov direction,1
			cmp angle_horizontal,1
			je R1
			
			cmp angle_horizontal,2
			je R2
			
			R1:
			call RIGHT_BORDER_BOTTOM_TO_TOP
			JMP D
			
			R2:
			call RIGHT_BORDER_TOP_TO_BOTTOM
			JMP D
			
			
			
D:
CMP AL,0FH
JE subscore

mov ax,x_ball
MOV brick_x_start , ax
mov brick_x_end,ax
add brick_x_end,46

mov ax,y

mov brick_y_start,ax
mov cx,brick_x_start
INC CX
CALL FIND_BRICK_Y

mov ax, brick_y_start
mov brick_y_end,ax
add brick_y_end,11
cmp sb,1
je special
call BREAK 
jmp donee

special:

call SPECIAL_BREAK  
CALL BREAK
jmp donee 
subscore:
sub scoree,10
call UpdateScore
donee:                             
RET		

LEFT_HIT ENDP

;------------------------------------------------------- RIGHT HIT -----------------------------------------------------

RIGHT_HIT PROC

			mov direction,3
			cmp angle_horizontal,1
			je S1
			
			cmp angle_horizontal,2
			je S2
			
			
			S1:
			call LEFT_BORDER_BOTTOM_TO_TOP
			JMP E
			
			S2:
			call LEFT_BORDER_TOP_TO_BOTTOM
			JMP E
			
E:

CMP AL,0FH
JE subscore
			
mov ax,x
MOV brick_x_end , ax
mov brick_x_start,ax
sub brick_x_start,46

mov ax,y_ball

mov brick_y_start,ax
mov cx,brick_x_start

CALL FIND_BRICK_Y

mov ax, brick_y_start
mov brick_y_end,ax
add brick_y_end,11
cmp sb,1
je special
call BREAK 
jmp donee

special:

call SPECIAL_BREAK  
CALL BREAK
jmp donee 
subscore:
sub scoree,10
call UpdateScore
donee:                           
RET		


RIGHT_HIT ENDP


;---------------------------------------------------------------------------------------------------------
;---------------------------------------- BREAK BRICK LEVEL 1 --------------------------------------------
;---------------------------------------------------------------------------------------------------------

BREAK_BRICK_LEVEL_1 PROC

cmp y_ball,150
ja nobrick
;--------------------------------- BOTTOM CHECK ------------------------------------
mov cx,x
mov dx,y

mov ah,0dh
int 10h

cmp al,0
jne bottom_hitt




;---------------------------------- TOP CHECK ---------------------------------------

mov cx,x
mov dx,y_ball

mov ah,0dh
int 10h

cmp al,0
jne top_hitt


;---------------------------------- LEFT CHECK ------------------------------------

mov cx,x_ball
mov dx,y

mov ah,0dh
int 10h

cmp al,0
jne left_hitt 

;---------------------------------- RIGHT CHECK ---------------------------------

mov cx,x
mov dx,y

mov ah,0dh
int 10h

cmp al,0
jne right_hitt 

mov cx,x
mov dx,y_ball

mov ah,0dh
int 10h

cmp al,0
jne right_hitt 
;---------------------------------------------------------------------------


jmp nobrick

bottom_hitt:
add scoree,10
call UpdateScore
CALL BOTTOM_HIT
jmp nobrick

top_hitt:
add scoree,10
call UpdateScore
CALL TOP_HIT
jmp nobrick

left_hitt:
add scoree,10
call UpdateScore
CALL LEFT_HIT
jmp nobrick

right_hitt:
add scoree,10
call UpdateScore
CALL RIGHT_HIT
jmp nobrick

nobrick:
ret
BREAK_BRICK_LEVEL_1 ENDP






;---------------------------------------------------------------------------------------------------------
;---------------------------------------- BREAK BRICK LEVEL 2 --------------------------------------------
;---------------------------------------------------------------------------------------------------------



BREAK_BRICK_LEVEL_2 PROC

cmp y_ball,150
ja nobrick
;---------------------------------- BOTTOM CHECK ---------------------------------
mov cx,x
mov dx,y


mov ah,0dh
int 10h

cmp al,0
je nobrick

cmp al,7
je break_completely_bottom

MOV BREAK_COLOR,7
CALL BOTTOM_HIT
jmp nobrick

break_completely_bottom:
add scoree,10
call UpdateScore
MOV BREAK_COLOR,0
CALL BOTTOM_HIT
jmp nobrick

;---------------------------------- TOP CHECK ---------------------------------

mov cx,x
mov dx,y_ball

mov ah,0dh
int 10h

cmp al,0
je nobrick

cmp al,7
je break_completely_top

MOV BREAK_COLOR,7
CALL TOP_HIT
jmp nobrick

break_completely_top:
add scoree,10
call UpdateScore
MOV BREAK_COLOR,0
CALL TOP_HIT
jmp nobrick


;---------------------------------- LEFT CHECK ---------------------------------

mov cx,x_ball
mov dx,y

mov ah,0dh
int 10h

cmp al,0
je nobrick

cmp al,7
je break_completely_left

MOV BREAK_COLOR,7
CALL LEFT_HIT
jmp nobrick

break_completely_left:
add scoree,10
call UpdateScore
MOV BREAK_COLOR,0
CALL LEFT_HIT
jmp nobrick


;---------------------------------- RIGHT CHECK ---------------------------------

mov cx,x
mov dx,y

mov ah,0dh
int 10h

cmp al,0
je nobrick

cmp al,7
je break_completely_right

MOV BREAK_COLOR,7
CALL RIGHT_HIT
jmp nobrick

break_completely_right:
add scoree,10
call UpdateScore
MOV BREAK_COLOR,0
CALL RIGHT_HIT
jmp nobrick

nobrick:
ret
BREAK_BRICK_LEVEL_2 ENDP




;---------------------------------------------------------------------------------------------------------
;---------------------------------------- BREAK BRICK LEVEL 3 --------------------------------------------
;---------------------------------------------------------------------------------------------------------



BREAK_BRICK_LEVEL_3 PROC
cmp y_ball,150
ja nobrick
;---------------------------------- BOTTOM CHECK ---------------------------------
mov cx,x
mov dx,y

mov ah,0dh
int 10h

cmp al,0Bh
je special_brick


cmp al,0
je nobrick

cmp al,8
je break_2_bottom

cmp al,7
je break_3_bottom

cmp single_hit_reward,1
je reward1

MOV BREAK_COLOR,8
jmp noreward1
reward1:
add scoree,10
call UpdateScore
MOV BREAK_COLOR,0
noreward1:
CALL BOTTOM_HIT
jmp nobrick

break_2_bottom:
cmp single_hit_reward,1
je reward2
mov BREAK_COLOR,7
jmp noreward2
reward2:
add scoree,10
call UpdateScore
mov BREAK_COLOR,0
noreward2:
CALL BOTTOM_HIT
jmp nobrick

break_3_bottom:
add scoree,10
call UpdateScore
mov BREAK_COLOR,0
CALL BOTTOM_HIT
jmp nobrick


special_brick:
mov sb,1
CALL BOTTOM_HIT
mov sb,0
jmp nobrick
;---------------------------------- TOP CHECK ---------------------------------

mov cx,x_ball
mov dx,y_ball

mov ah,0dh
int 10h

cmp al,0Bh
je special_brick_2


cmp al,0
je nobrick

cmp al,8
je break_2_top

cmp al,7
je break_3_top


MOV BREAK_COLOR,8
CALL TOP_HIT
jmp nobrick

break_2_top:
mov BREAK_COLOR,7
CALL TOP_HIT
jmp nobrick

break_3_top:
mov BREAK_COLOR,0
add scoree,10
call UpdateScore
CALL TOP_HIT
jmp nobrick


special_brick_2:
mov sb,1
CALL TOP_HIT
mov sb,0
jmp nobrick
;---------------------------------- LEFT CHECK ---------------------------------

mov cx,x_ball
mov dx,y

mov ah,0dh
int 10h

cmp al,0Bh
je special_brick_3

cmp al,0
je nobrick

cmp al,8
je break_2_left

cmp al,7
je break_3_left


MOV BREAK_COLOR,8
CALL LEFT_HIT
jmp nobrick

break_2_left:
mov BREAK_COLOR,7
CALL LEFT_HIT
jmp nobrick

break_3_left:
mov BREAK_COLOR,0
add scoree,10
call UpdateScore
CALL LEFT_HIT
jmp nobrick

special_brick_3:
mov sb,1
CALL LEFT_HIT
mov sb,0
jmp nobrick

;---------------------------------- RIGHT CHECK ---------------------------------

mov cx,x
mov dx,y

mov ah,0dh
int 10h

cmp al,0Bh
je special_brick_4

cmp al,0
je nobrick

cmp al,8
je break_2_right

cmp al,7
je break_3_right


MOV BREAK_COLOR,8
CALL RIGHT_HIT
jmp nobrick

break_2_right:
mov BREAK_COLOR,7
CALL RIGHT_HIT
jmp nobrick

break_3_right:
mov BREAK_COLOR,0
add scoree,10
call UpdateScore
CALL RIGHT_HIT
jmp nobrick



special_brick_4:
mov sb,1
CALL RIGHT_HIT
mov sb,0
jmp nobrick

nobrick:
ret
BREAK_BRICK_LEVEL_3 ENDP




;---------------------------------------------------------------------------------------------------------
;---------------------------------------------- BAR WORKING ----------------------------------------------
;---------------------------------------------------------------------------------------------------------

make_bar proc 
	
		mov cx,bar_start
		mov dx,bar_y
		mov si,0
		bar1:
			mov ah,0ch
			mov al,6
			int 10h
			inc cx 
			cmp cx,bar_end
		jne bar1
		ret
	make_bar endp
	
	remove_bar proc 
	
		mov cx,bar_start
		mov dx,bar_y
		mov si,0
		bar1:
			mov ah,0ch
			mov al,0
			int 10h
			inc cx 
			cmp cx,bar_end
		jne bar1
		ret
	remove_bar endp
	

move_bar proc
	
		mov ah,00
		int 16h
	
		cmp ah,4dh
		je right
		
		cmp ah,4bh
		je left
		
		cmp al,70h
		je pauseee
			
		cmp al,32
		je exit
		
			right:
			cmp bar_end,316
			ja exit
				call remove_bar
				inc bar_start
				inc bar_end
				call make_bar
				
				call remove_bar
				inc bar_start
				inc bar_end
				call make_bar
				
				call remove_bar
				inc bar_start
				inc bar_end
				call make_bar

			
				
				jmp exit
			
			left:
			cmp bar_start,4
			jb exit
				call remove_bar
				dec bar_start
				dec bar_end
				call make_bar
				
				call remove_bar
				dec bar_start
				dec bar_end
				call make_bar
				
				call remove_bar
				dec bar_start
				dec bar_end
				call make_bar


				jmp exit

			pauseee:
					call PAUSEE
					
				play:
					mov ah,00
					int 16h
					
					mov clr,0
					mov temp1,120
					mov bx,temp1
					mov temp,190
					mov temp2,110
					mov temp3,130
					call brick
					mov ah,00
					int 16h
					;jmp pauseee
					cmp al,70h
					je exit
					jne pauseee
					
				jmp play
	exit:
		
	ret	
	move_bar endp
	
	
;--------------------------------------------------------------------------------------------------------
;----------------------------------- INCREMENT / DECREMENT PROCEDURES -----------------------------------
;--------------------------------------------------------------------------------------------------------



;---------------------------------------- RIGHT BORDER ---------------------------------------------

RIGHT_BORDER_TOP_TO_BOTTOM PROC
		
		SUB x,1
		SUB x_ball,1
		ADD y,1
		ADD y_ball,1
ret
RIGHT_BORDER_TOP_TO_BOTTOM ENDP


RIGHT_BORDER_BOTTOM_TO_TOP PROC
		
		SUB x,1
		SUB x_ball,1
		sub y,1
		sub y_ball,1
ret
RIGHT_BORDER_BOTTOM_TO_TOP ENDP

;---------------------------------------- TOP BORDER ---------------------------------------------


TOP_BORDER_RIGHT_TO_LEFT PROC
	
		SUB x,1
		SUB x_ball,1
		ADD y,1
		ADD y_ball,1
ret
TOP_BORDER_RIGHT_TO_LEFT ENDP


TOP_BORDER_LEFT_TO_RIGHT PROC
	
		ADD x,1
		ADD x_ball,1
		ADD y,1
		ADD y_ball,1
ret
TOP_BORDER_LEFT_TO_RIGHT ENDP

;---------------------------------------- LEFT BORDER ---------------------------------------------

LEFT_BORDER_TOP_TO_BOTTOM PROC
	
		ADD x,1
		ADD x_ball,1
		ADD y,1
		ADD y_ball,1
ret
LEFT_BORDER_TOP_TO_BOTTOM ENDP


LEFT_BORDER_BOTTOM_TO_TOP PROC
		
		ADD x,1
		ADD x_ball,1
		sub y,1
		sub y_ball,1
ret
LEFT_BORDER_BOTTOM_TO_TOP ENDP


;---------------------------------------- BOTTOM BORDER ---------------------------------------------


BOTTOM_BORDER_RIGHT_TO_LEFT PROC
	
		ADD x,1
		ADD x_ball,1
		SUB y,1
		SUB y_ball,1
ret
BOTTOM_BORDER_RIGHT_TO_LEFT ENDP


BOTTOM_BORDER_LEFT_TO_RIGHT PROC
		
		SUB x,1
		SUB x_ball,1
		SUB y,1
		SUB y_ball,1
ret
BOTTOM_BORDER_LEFT_TO_RIGHT ENDP

;----------------------------------------- RECREATE BALL ---------------------------------------

RECREATE_BALL PROC

		call RemoveHeart
		SUB h1,20
		sub h2,20
		MOV x, 155
		MOV y, 160
		MOV x_ball, 160
		MOV y_ball, 165
		MOV direction,3
		DEC lives
		
		CMP LIVES,0
		JNE DONEEEEEE 
		CALL OVER
		DONEEEEEE:
	RET	
RECREATE_BALL ENDP



;----------------------------------------------------------------------------------------
;-------------------------- CHANGING DIRECTION PROCEDURE --------------------------------
;----------------------------------------------------------------------------------------




BOUNDARY proc

cmp x,310
je right_border_touch

cmp y,25
je top_border_touch

cmp x,5
je left_border_touch

cmp y,190
je bottom_border_touch


cmp direction,1             
je right_border_touch

cmp direction,2
je top_border_touch

cmp direction,3
je left_border_touch

cmp direction,4
je move_after_bounce

cmp direction,5
je go_up

cmp direction,6
je go_down



;----------------------------- right border touch ------------------------------------

		right_border_touch:
			
		
			mov angle_vertical,1
			mov direction,1
			
			
			cmp angle_horizontal,1
			je right_bottom_to_top
			
			cmp angle_horizontal,2
			je right_top_to_bottom
			
			jmp DONE
			
			right_bottom_to_top:
			call RIGHT_BORDER_BOTTOM_TO_TOP
			JMP DONE
			
			right_top_to_bottom:
			call RIGHT_BORDER_TOP_TO_BOTTOM
			JMP DONE
		
			
			
			
;----------------------------- top border touch ------------------------------------

		top_border_touch:
			
			cmp check_up,1
			je go_down 
			
			mov angle_horizontal,2
			mov direction,2
			
			cmp angle_vertical,1
			je top_right_to_left
		
			cmp angle_vertical,2
			je top_left_to_right
			
			top_right_to_left:
			call TOP_BORDER_RIGHT_TO_LEFT
			JMP DONE
			
			top_left_to_right:
			call TOP_BORDER_LEFT_TO_RIGHT
			JMP DONE
			
			go_down:
			mov check_up,0
			mov direction,6
			inc y
			inc y_ball
			jmp DONE
			

;----------------------------- left border touch ------------------------------------

		left_border_touch:
		
	
			mov angle_vertical,2
			mov direction,3
			
			cmp angle_horizontal,1
			je left_bottom_to_top
			
			cmp angle_horizontal,2
			je left_top_to_bottom
			
			jmp DONE
			
			left_bottom_to_top:
			call LEFT_BORDER_BOTTOM_TO_TOP
			JMP DONE
			
			left_top_to_bottom:
			call LEFT_BORDER_TOP_TO_BOTTOM
			JMP DONE
			
;----------------------------- bottom border touch ------------------------------------

		bottom_border_touch:
		
		
			mov angle_horizontal,1
			mov direction,4
			
			MOV ax,bar_start
			mov bx,bar_end
			
			cmp x,ax
			jaE check_end
			
			JMP DECREASE_LIFE
			check_end:
			cmp x_ball,bx
			jbE hit

			jmp DECREASE_LIFE
			hit:
					
				
				
			mov ax,bar_start
			add ax, 16
			
			mov bx,bar_end
			sub bx,16
			
			cmp x,ax
			jae find_direction
			
			jmp go_left_or_right
			
			find_direction:
			cmp x_ball,bx
			jbe go_up
			
			jmp go_left_or_right
			
			go_up:
			mov check_up,1
			MOV direction,5
			dec y
			dec y_ball
			jmp DONE
			
			go_left_or_right:
			cmp angle_vertical,2
			je bottom_right_to_left
			
			cmp angle_vertical,1
			je bottom_left_to_right
			
			bottom_right_to_left:
			call BOTTOM_BORDER_RIGHT_TO_LEFT
			JMP DONE
		
			bottom_left_to_right:
			call BOTTOM_BORDER_LEFT_TO_RIGHT
			JMP DONE


			DECREASE_LIFE:
			CALL RECREATE_BALL
			JMP DONE
;------------------------------------------------------------------------
			move_after_bounce:

			mov angle_horizontal,1
			mov direction,4
			
			
				cmp angle_vertical,2
				je bottom_right_to_left_again
				
				cmp angle_vertical,1
				je bottom_left_to_right_again
				
				bottom_right_to_left_again:
				call BOTTOM_BORDER_RIGHT_TO_LEFT
				JMP DONE
			
				bottom_left_to_right_again:
				call BOTTOM_BORDER_LEFT_TO_RIGHT
				JMP DONE


;------------------------------------------------------------------------

DONE:

ret
BOUNDARY endp




;----------------------------------------------------------------------------------------
;------------------------------------ BALL WORKING --------------------------------------
;----------------------------------------------------------------------------------------

destroy_ball proc
	
	mov dx,y
		LL1:
			MOV CX, x
			LL2:
			
			mov ah,0dh
			int 10h
				MOV AL, 0
				MOV AH, 0CH
				INT 10H
				
				INC CX
				CMP CX,x_ball
			JNE LL2
			
			INC DX
			
			CMP DX,y_ball
		JNE LL1
	ret	
destroy_ball endp


create_ball proc

inc counter
mov cx,x
mov dx,y


L1:

MOV CX,x

	L2:

	MOV AL, 14
	MOV AH, 0CH
	INT 10H

	INC CX
	CMP CX,x_ball
	JNE L2

	INC DX

	CMP DX,y_ball
JNE L1
		mov ax,ball_speed
		cmp counter,ax
		jne skip
		call destroy_ball
		mov counter,0
		CALL BOUNDARY
		
		
		cmp LEVELS,1
		je call_1
		cmp LEVELS,2
		je call_2
		cmp LEVELS,3
		je call_3
		
		call_1:
		call BREAK_BRICK_LEVEL_1
		jmp skip
		
		call_2:
		call BREAK_BRICK_LEVEL_2
		jmp skip
		
		call_3:
		call BREAK_BRICK_LEVEL_3
		cmp sb2,1
		jne skip
		call delete_reward
		inc special_reward_y
		inc special_reward_y_end
		call reward
		call special_reward
		

	skip:
ret

create_ball endp


;----------------------------- GAME OVER ------------------------------
Over proc

	mov ah, 0
	mov al, 13h
	int 10h	
	
	mov ah,02h
	mov bx,0
	mov dh,15
	mov dl,16
	int 10h
	lea dx,gameover  ; string
	mov ah,09h
	int 21h
	ret
Over endp


;----------------------------- GAME WIN ------------------------------
Win proc
	mov ah, 0
	mov al, 13h
	int 10h	
	
	
	
	mov ah,02h
	mov bx,0
	mov dh,11
	mov dl,12
	int 10h
	lea dx,gamewin  ; string
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,14
	mov dl,14
	int 10h
	lea dx,namee  ; string
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,14
	mov dl,22
	int 10h
	
	mov di,0
	mov al,lengthstorer
	mov ah,0
	mov cx,ax
	dispname:
	mov dl,NameStorer[di]
	inc di
	mov ah,2
	int 21h
	loop dispname
	
	
		cmp LEVELS,1
		je call_1
		cmp LEVELS,2
		je call_2
		cmp LEVELS,3
		je call_3
		
		call_1:
	mov ah,02h
	mov bx,0
	mov dh,16
	mov dl,14
	int 10h
	lea dx,totScore2  ; string
	mov ah,09h
	int 21h
		mov ah,02h
		mov bx,0
		mov dh,18
		mov dl,14
		int 10h
		lea dx,EASY11 ; string
		mov ah,09h
		int 21h
		jmp DONE
		
		call_2:
			mov ah,02h
	mov bx,0
	mov dh,16
	mov dl,14
	int 10h
	lea dx,totScore2  ; string
	mov ah,09h
	int 21h
		mov ah,02h
		mov bx,0
		mov dh,18
		mov dl,14
		int 10h
		lea dx,MEDIUMM11  ; string
		mov ah,09h
		int 21h
		jmp DONE
		
		call_3:
			mov ah,02h
	mov bx,0
	mov dh,16
	mov dl,14
	int 10h
	lea dx,totScore  ; string
	mov ah,09h
	int 21h
		mov ah,02h
		mov bx,0
		mov dh,18
		mov dl,14
		int 10h
		lea dx,HARD11  ; string
		mov ah,09h
		int 21h
		jmp DONE
	
	DONE:
	
	ret
Win endp
;--------------------------- BRICK LOOP ---------------------------------
brick proc

	mov dx, temp2 ; y start
	L1:
		mov cx, bx   ;temp1 // x start
	L2:
		mov al, clr
		mov ah, 0ch
		int 10h
		inc cx
		cmp cx,temp  ; x ending
		jne L2
		inc dx
		cmp dx,temp3   ; y end
		jne L1
		ret
	brick endp
	
;----------------------------------PRINTING BRICKS--------------------------------
level proc
	
	mov ah, 0
	mov al, 13h
	int 10h	
	;------------------------------------ HEARTS ------------------------------  
	mov ah,02h
	mov bx,0
	mov dh,1
	mov dl,154
	int 10h
	
	mov dl,3
	mov ah,2
	int 21h
	
	mov dl, ' '
    mov ah, 2
    int 21h
	
	mov dl,3
	mov ah,2
	int 21h
	
	mov dl, ' '
    mov ah, 2
    int 21h
	
	mov dl,3
	mov ah,2
	int 21h

	
	
	;--------------------------- DISPLAYING LINE ---------------------------
	mov clr,0Ch
	mov si,0
	mov temp1,00
	mov bx,temp1
	mov temp,320
	mov temp2,22
	mov temp3,24
	call brick
	;===================== SCORE-------------------------
	
	mov ah,02h
	mov bx,0
	mov dh,1
	mov dl,2
	int 10h
	lea dx,score
	mov ah,09h
	int 21h
	
	
	;------------------------ FIRST ROW-----------------------------
	mov clr,12
	mov temp1,06
	mov bx,temp1
	mov temp,51
	mov temp2,35
	mov temp3,45
	mov di,0
	l1:
	call brick
	add bx,53
	add temp,53
	inc di
	cmp di,5
	jbe l1
	
	;------------------------ SECOND ROW-----------------------------
	
	mov clr,14
	mov temp1,30
	mov bx,temp1
	mov temp,75
	mov temp2,55
	mov temp3,65
	mov si,0
	l3:
	call brick
	add bx,53
	add temp,53
	inc si
	cmp si,4
	jbe l3
	
	;------------------------THIRD ROW-----------------------------
	mov clr,10
	mov temp1,06
	mov bx,temp1
	mov temp,51
	mov temp2,75
	mov temp3,85
	mov si,0
	l4:
	call brick
	add bx,53
	add temp,53
	inc si
	cmp si,5
	jbe l4
	
	cmp LEVELS,3
	JNE NOT_LEVEL_3
	call random

	NOT_LEVEL_3:
	;------------------------------------ NAME DISPLAYER--------------------------------------
	mov ah,02h
	mov bx,0
	mov dh,1
	mov dl,16
	int 10h
	
		cmp LEVELS,1
		je call_1
		cmp LEVELS,2
		je call_2
		cmp LEVELS,3
		je call_3
		
		call_1:
		lea dx, easy1
		mov ah,09h
		int 21h
		jmp skip
		
		call_2:
		lea dx, mediumm1
		mov ah,09h
		int 21h
		jmp skip
		
		call_3:
		lea dx, hard1
		mov ah,09h
		int 21h
	skip:
	ret
	level endp
	
;----------------------------------DISPLAY FUNCTION--------------------------------




FirstScreen proc
	
	mov ah, 00h
	mov al,03
	int 10h
	mov ah,09h
	mov bh, 00h
	mov al, 20h
	mov cx,800h
	mov bl, 03eh  ; This is Blue & White.
	int 10h
	;------------------------------------------------------------------------------
	mov ah,02h
	mov bx,0
	mov dh,8
	mov dl,20
	int 10h
	lea dx,string
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,12
	mov dl,25
	int 10h
	lea dx,string1
	mov ah,09h
	int 21h
	
	;-------------------- NAME INPUT ---------------------------
	mov si,0
	mov si,offset NameStorer
	l1:
	mov cx, 2
	mov ah, 01h 		
	int 21h
	cmp al,0dh		
	je helper
	mov [si], al
	inc si
	inc lengthstorer
	jmp l1

	helper:
	mov si,0
	ret
FirstScreen endp

;----------------------------------------------------------------------------------------------
Instructions proc
	mov ah, 0
	mov al, 13h  ; Display 
	int 10h
	;----------------------------------------------------
	
	mov ah, 00h
	mov al,03
	int 10h
	mov ah,09h
	mov bh, 00h
	mov al, 20h
	mov cx,800h
	mov bl, 0fh  ; This is Blue & White.
	int 10h
	;--------------------------------------------------------------
	
	mov ah,02h
	mov bx,0
	mov dh,3
	mov dl,0
	int 10h
	lea dx,in1
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,7
	mov dl,21
	int 10h
	lea dx,ins1
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,10
	mov dl,15
	int 10h
	lea dx,ins2
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,12
	mov dl,15
	int 10h
	lea dx,ins3
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,14
	mov dl,15
	int 10h
	lea dx,ins4
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,16
	mov dl,15
	int 10h
	lea dx,ins5
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,21
	mov dl,15
	int 10h
	lea dx,ins6
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,24
	mov dl,0
	int 10h
	lea dx,ins7
	mov ah,09h
	int 21h
	ret
Instructions endp

;----------------------------------------------------------------------
;----------------------------------------------------------------------------------------------
Difficulty proc
	mov ah, 0
	mov al, 13h  ; Display 
	int 10h
	;----------------------------------------------------
	mov ah, 00h
	int 10h
	mov ah,09h
	mov bh, 00h
	mov al, 20h
	mov cx,800h
	mov bl, 40h  ; This is Blue & White.
	int 10h
	;--------------------------------------------------------------
	mov clr,10
	mov temp1,100
	mov bx,temp1
	mov temp,110
	mov dx,cursor1
	mov temp2,dx   ;cursor1
	mov ax,cursor2
	mov temp3,ax	;cursor2
	call brick
	
	mov ah,02h
	mov bx,0
	mov dh,5
	mov dl,15
	int 10h
	lea dx,string2
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,10
	mov dl,15
	int 10h
	lea dx,easy
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,12
	mov dl,15
	int 10h
	lea dx,mediumm
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,14
	mov dl,15
	int 10h
	lea dx,hard
	mov ah,09h
	int 21h
	ret
Difficulty endp
;------------------------------------------------------------------------
;------------------------------------------------------------------------

Pausee proc
	
	mov ah,02h
	mov bx,0
	mov dh,15
	mov dl,15
	int 10h
	lea dx,p  ; string
	mov ah,09h
	int 21h
	ret
Pausee endp

;----------------------------REMOVE HEART --------------------
RemoveHeart proc
	
	mov clr,0
	mov ax,h1
	mov temp1,ax
	mov bx,temp1
	
	mov dx,h2
	mov temp,dx
	
	mov temp2,5
	mov temp3,20
	call brick
	ret
RemoveHeart endp
;----------------------------------------------------------------------------------------------
Cursor proc
	mov ah, 0
	mov al, 13h  ; Display 
	int 10h
	;----------------------------------------------------
	mov ah, 00h
	int 10h
	mov ah,09h
	mov bh, 00h
	mov al, 20h
	mov cx,800h
	mov bl, 40h  ; This is Blue & White.
	int 10h
	;--------------------------------------------------------------
	mov clr,10
	mov temp1,100
	mov bx,temp1
	mov temp,110
	mov dx,cursor1
	mov temp2,dx   ;cursor1
	mov ax,cursor2
	mov temp3,ax	;cursor2
	call brick
	
	mov ah,02h
	mov bx,0
	mov dh,5
	mov dl,15
	int 10h
	lea dx,string2
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,10
	mov dl,15
	int 10h
	lea dx,string3
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,12
	mov dl,15
	int 10h
	lea dx,string4
	mov ah,09h
	int 21h
	
	mov ah,02h
	mov bx,0
	mov dh,14
	mov dl,15
	int 10h
	lea dx,string5
	mov ah,09h
	int 21h
	ret
Cursor endp
;-----------------------------------------------------------------------------------------------------------------
UpdateScore proc
	push ax
	push bx
	push cx
	push dx

	mov cx,0
	mov ax,scoree
	l1:
	mov bx,10
	mov dx,0
	div bx
	push dx
	inc cx
	cmp ax,0
	jne l1
	
	mov ah,02h
	mov bx,0
	mov dh,1
	mov dl,9
	int 10h
	
	l2:
	pop dx
	mov ah,2
	add dl,'0'
	int 21h
	loop l2
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
UpdateScore endp


FileHandling proc
	
	;open a file
	mov ah, 3dh
	mov al, 2
	mov dx, offset f1
	int 21h
	
	;;Appending File
	;mov bx,ax
	;mov cx,0
	;mov ah,42h
	;mov al,02h
	;int 21h
	
	;write to a file
	mov fileinfo, ax
	
	mov cx, 0
	mov dx, 0
	mov ah, 42h
	mov al, 2
	int 21h
	
	
	mov ah, 40h
	mov bx, fileinfo
	mov cx, lengthof namee-1
	mov dx, offset namee
	int 21h
	
	mov cx, 0
	mov dx, 0
	mov ah, 42h
	mov al, 2
	int 21h
	
	mov ah, 40h
	mov bx, fileinfo
	mov cx, 10
	mov dx, offset NameStorer
	int 21h
	
	mov cx, 0
	mov dx, 0
	mov ah, 42h
	mov al, 2
	int 21h
	
	cmp LEVELS,1
	je call_1
	cmp LEVELS,2
	je call_2
	cmp LEVELS,3
	je call_3
	
	call_1:
	mov ah, 40h
	mov bx, fileinfo
	mov cx, lengthof easy11-1
	mov dx, offset easy11
	add score,48
	int 21h
		jmp skip
		
		call_2:
		mov ah, 40h
	mov bx, fileinfo
	mov cx, lengthof mediumm11-1
	mov dx, offset mediumm11
	add score,48
	int 21h
		jmp skip
		
		call_3:
		mov ah, 40h
	mov bx, fileinfo
	mov cx, lengthof hard11-1
	mov dx, offset hard11
	add score,48
	int 21h
	
	
	skip:
	
	;close a file
	mov ah, 3eh
	mov bx, fileinfo
	int 21h	
	
	ret

FileHandling endp




random proc
	mov clr,0fh
	mov temp1,30
	mov bx,temp1
	mov temp,75
	mov temp2,55
	mov temp3,65
	call brick
	
	mov clr,0fh
	mov temp1,59
	mov bx,temp1
	mov temp,104
	mov temp2,35
	mov temp3,45
	call brick
	
	mov clr,0fh
	mov temp1,165
	mov bx,temp1
	mov temp,210
	mov temp2,35
	mov temp3,45
	call brick
	

	
	
	;----------SPECIAL-BRICK---------
	mov clr,0Bh
	mov temp1,6
	mov bx,temp1
	mov temp,51
	mov temp2,75
	mov temp3,85
	call brick
	
	
	ret

random endp
;-----------------------------------------------------------------------------------------------------------------
;----------------------------------MAIN FUNCTION --------------------------------

main proc
mov ah, 0
	mov al, 13h
	int 10h
	
	mov ax,@data
	mov ds,ax
	mov ax,0
	;-------------------------- NAME INPUT PANEL ----------------------------------
	game_start:
	mov cx,0
	mov dx,400
	call FirstScreen
	;------------------------------- MENU ---------------------------------	
	cmp al,13
	je x1
	x1:
	mov cursor1,82
	mov cursor2,87
	call Cursor
	
	mov ah,00h
	int 16h
	cmp al,13
	
	je dif   ; ----- level 1----
	jne x2
	dif:
	call Difficulty
	mov ah,00h
	int 16h
	cmp al,13
	je newscreen
	jne lv2
	;-------------------------------------- LEVEL 01-------------------------------------------------------
	
	newscreen:
	call level
	
	game_loop_1:
	cmp scoree,170
	jne continue1
	
	call WIN
	jmp exit
	continue1:
	cmp lives,0
	je exit

	
	mov ah,01	
	int 16h
	jz no_key_1
	call create_ball
	call move_bar
	
	no_key_1:
	call create_ball
	
	jmp game_loop_1
	
	
	;------------------------------------LEVEL 02--------------------------------------------------------------
	
	
	mov ah,00h
	int 16h
	cmp ah,50h
	je lv2
	lv2:
	mov cursor1,100
	mov cursor2,105
	call Difficulty
	
	mov ah,00h
	int 16h
	cmp al,13
	mov LEVELS,2
	mov ball_speed,400
	mov bar_end,193
	je mlv2         ;--------------
	jne lv3
	mlv2:
	
	CALL level
	game_loop_2:
	
	cmp scoree,170
	jne continue2
	
	call WIN
	jmp exit
	continue2:
	cmp lives,0
	je exit
	
	mov ah,01	
	int 16h
	jz no_key_2
	call create_ball
	call move_bar
	
	no_key_2:
	call create_ball
	
	jmp game_loop_2
	mov ah,00h
	int 16h
	cmp ah,48h
	jmp dif
;------------------------------------LEVEL 03---------------------------------------------------------------
		
	
	mov ah,00h
	int 16h
	cmp ah,50h
	jmp lv3
	lv3:
	mov cursor1,115
	mov cursor2,120
	call Difficulty
	;---------------------------------------------------------------
	
	mov ah,00h
	int 16h
	cmp al,13
	mov LEVELS,3
	mov ball_speed,200
	mov bar_end,193
	je llv3
	jne dif
	llv3:
	call level
	game_loop_3:
	
	cmp scoree,140
	jne continue3
	
	call WIN
	jmp exit
	continue3:
	cmp lives,0
	je exit
	
	mov ah,01	
	int 16h
	jz no_key_3
	call create_ball
	call move_bar
	
	no_key_3:
	call create_ball
	
	jmp game_loop_3
		
		;----------------==	
		
	mov ah,00h
	int 16h
	cmp ah,50h
	je x2

	x2:
	mov cursor1,100
	mov cursor2,105
	call Cursor
	
	mov ah,00h
	int 16h
	cmp ah,48h
	je x1
	
	cmp al,13
	je x4
	
	jne x3
	x4:
	call Instructions
	
	mov ah,00h
	int 16h
	cmp al,13
	je x1
	
	mov ah,00h
	int 16h
	cmp ah,48h
	je x1
	
	cmp ah,50h
	je x3
	x3:
	mov cursor1,115
	mov cursor2,120
	call Cursor
	
	mov ah,00h
	int 16h
	cmp al,13
	je main
	
	cmp ah,48h
	je x2
	
	cmp al,32
	je exit
exit:

main endp
call FileHandling
mov ah,4ch
int 21h
end