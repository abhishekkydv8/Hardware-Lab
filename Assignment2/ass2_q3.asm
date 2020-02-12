section .data
zero: db '0'
l1: equ $-zero
space: db ' '
l2: equ $-space
msg3: db 'Largest number is: '
l3: equ $-msg3
msg4: db 'Smallest number is: '
l4: equ $-msg4
newline: db '',10
l5: equ $-newline
msg6: db 'Enter the value of n: '
l6: equ $-msg6
msg7: db 'Enter the numbers: '
l7: equ $-msg7

section .bss
just_read: resd 1
temp: resd 1
just_print: resd 1
counter: resd 1
arr: resd 100
i: resd 1
n: resd 1
j: resd 1
k: resd 1

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg6
mov edx,l6
int 80h

call read_num
mov eax,dword[just_read]
mov dword[n],eax

mov eax,4
mov ebx,1
mov ecx,msg7
mov edx,l7
int 80h

call read_array
;call print_array

mov ebx,arr
mov dword[i],1
label1:
	mov eax,dword[i]
	cmp eax,dword[n]
	je end_label1
	mov ecx,dword[ebx+eax*4]
	mov dword[k],ecx
	mov eax,dword[i]
	sub eax,1
	mov dword[j],eax

label2:
	cmp dword[j],0
	jb label3
	mov eax,dword[j]
	mov ecx,dword[ebx+eax*4]
	cmp ecx,dword[k]
	jna label3
	mov dword[ebx+eax*4+4],ecx
	mov ecx,dword[k]
	mov dword[ebx+eax*4],ecx
	dec dword[j]
	jmp label2
	
label3:
	inc dword[i]
	jmp label1

end_label1:
	;call print_array
	mov eax,4
        mov ebx,1
        mov ecx,msg3
        mov edx,l3
        int 80h
	
        mov ebx,arr
        mov eax,dword[n]
        dec eax
        mov ecx,dword[ebx+eax*4]
        mov dword[just_print],ecx
        call print_num

        mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,l5
        int 80h

        mov eax,4
        mov ebx,1
        mov ecx,msg4
        mov edx,l4
        int 80h

        mov ebx,arr
        mov ecx,dword[ebx]
        mov dword[just_print],ecx
        call print_num

	mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,l5
        int 80h

	mov eax,1
	mov ebx,0
	int 80h

read_array:
pusha
mov ebx,arr
mov dword[i],0
	read:
		mov eax,dword[i]
		cmp eax,dword[n]
		je end_readarray
		call read_num
		mov ecx,dword[just_read]
		mov dword[ebx+eax*4],ecx
		inc dword[i]
		jmp read

print_array:
pusha
mov ebx,arr
mov dword[i],0
        print:
                mov eax,dword[i]
                cmp eax,dword[n]
                je end_printarray
                mov ecx,dword[ebx+eax*4]
		mov dword[just_print],ecx
		call print_num
		
		pusha
	        mov eax,4
       	        mov ebx,1
       	        mov ecx,space
      	 	mov edx,l2
       		int 80h
		popa

                inc dword[i]
                jmp print
end_printarray:
popa
ret

end_readarray:
popa
ret
	

read_num:
	pusha
	mov dword[just_read],0
	reading:
		mov eax,3
		mov ebx,0
		mov ecx,temp
		mov edx,1
		int 80h
		cmp dword[temp],10
		je end_read
		mov eax,dword[just_read]
		sub dword[temp],30h
		mov ebx,10
		mov edx,0
		mul ebx
		add eax,dword[temp]
		mov dword[just_read],eax
		jmp reading
end_read:
	popa
	ret

print_num:
	pusha
	mov dword[counter],0
	cmp dword[just_print],0
	jne extracting
	mov eax,4
	mov ebx,1
	mov ecx,zero
	mov edx,l1
	int 80h
	jmp end_print

	extracting:
		cmp dword[just_print],0
		je printing
		mov eax,dword[just_print]
		mov ebx,10
		mov edx,0
		div ebx
		push edx
		mov dword[just_print],eax
		inc dword[counter]
		jmp extracting
printing:
	cmp dword[counter],0
	je end_print
	pop edx
	add edx,30h
	mov dword[temp],edx
	mov  eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,1
	int 80h
	dec dword[counter]
	jmp printing

end_print:
	popa
	ret
	
		
