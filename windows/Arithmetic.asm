; Arithmetic NASM |  ADD()/SUB() functions
; Compile with: nasm -f win32 Arithmetic.asm && GoLink.exe /entry _main kernel32.dll -o Arithmetic.obj && Arithmetic.exe

%define NULL 0 

global _main

section .data
	extern ExitProcess

section .text

_main:
	
	xor eax, eax
	push 0x10 			  ; add(0x00, 0x10)
	push 0x20  			  ; add(0x20, 0x10)  -> Values gonna be on inverted order 
	call add_func 	      ; result: eax=0x30
	
	push 0x10 			  ; sub(0x10) 		 -> substract 0x10 from current EAX register 
	call sub_function 	  ; result: eax=0x20
	call exit             ; Exit program


;add(n1, n2)
add_func:
	push ebp			  ; Point EBP to ESP ( our current stack )		
	mov ebp, esp 		  ;				        EBP+4    	     EBP+8     EBP+12     EBP+16
 	mov al, [ebp+8]       ; 0xdeadbeef:    <current_EBP_addr> 0x00000020 0x00000000 0x00000000
	add al, [ebp+12]	  ; 0xdeadbeef:    <current_EBP_addr> 0x00000020 0x00000010 0x00000000 -> EBP+8 + EBP+12 = 0x30
	pop ebp  			  ; free EBP    					  ^^^^^^^^^^ ^^^^^^^^^^
	ret					  ; return to _main

;sub(n1, 0x10)
sub_function:			
	push ebp        	  
	mov ebp, esp     	  ; 					   EBP+4        EBP+8      EBP+12     EBP+16
	sub al, [ebp+8]		  ; 0xdeadbeef:    <current_EBP_addr> 0x00000010 0x00000000 0x00000000 -> (EAX=0x30) - 0x10  = 0x20
	pop ebp               ; free ebp 						  ^^^^^^^^^^ ^^^^^^^^^^
	ret                   ; return to _main 

exit:
	push NULL
	call ExitProcess
