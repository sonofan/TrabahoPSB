extern printf
extern scanf

section .data
	inputPrompt: db "Enter an array to sort:", 10, 0
	inputFormat: db "%s", 0
	outputFormat: db "Sorted array: %s", 10, 0
	
section .bss
	data: resb 128
	size: resq 1

global main

section .text
main:
    mov rbp, rsp; for correct debugging
	; Setup
	push rbp

	; Input prompt
	mov rdi, inputPrompt
	xor rsi, rsi
	xor rax, rax
	call printf

	; Input
	mov rdi, inputFormat
	mov rsi, data
	xor rax, rax
	call scanf

	; Call function
	mov rdi, data
	call .bubbleSort

	; Print
	mov rdi, outputFormat
	mov rsi, rax
	xor rax, rax
	call printf	

	; Exit
	pop rbp
	xor rax, rax
	ret

; Bubble sort
; Input:
; 	%rdi - Address to data
; Output:
; 	%rax - Address to sorted data (original address)
.bubbleSort:
	; Init
	mov rsi, rdi
	xor rax, rax
	xor rdx, rdx
; Get the length of the array to know how many times to loop
.length:
	lodsb
	cmp al, 0
	inc rax
	jz .length
	dec rax     ; Length N
	mov qword [size], rax
	
	; Setup for first loop
	xor rdx, rdx
	xor rax, rax
.loop1:
	; If (i >= size) break
	cmp rdx, [size]
	jge .endLoop1
	inc rdx
	
	; Setup for second loop
	mov rsi, rdi
.loop2:
	; Compare two neighbors and do another looping
	lodsb
	cmp al, 0
	jz .endLoop2
	mov bl, al
	mov byte bh, [rsi]
	cmp bh, 0
	jz .endLoop2
	cmp bl, bh
	jg .swap
	jmp .loop2	
.swap:
	mov cl, bl
	mov bl, bh
	mov bh, cl
	mov byte [rsi-1], bl
	mov byte [rsi], bh
	jmp .loop2

.endLoop2:
	jmp .loop1

.endLoop1:
	; Exit function
	mov rax, data
	ret