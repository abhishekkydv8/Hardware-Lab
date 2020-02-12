section .data
msg1: db 'Enter the value of n :'
l1: equ $-msg1
msg2: db 'Enter the numbers',10
l2: equ $-msg2
msg3: db 'Enter the value of k :'
l3: equ $-msg3
newline: db '',10
l4: equ $-newline

section .bss
just_read: resd 1
temp: resd 1
just_print: resd 1
counter: resd 1
arr: resd 100
i: resd 1
n: resd 1
k: resd 1

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,l1
int 80h

call read_num
mov eax,dword[just_read]
mov dword[n],eax

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,l2
int 80h

call read_array

mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,l3
int 80h

call read_num
mov eax,dword[just_read]
mov dword[k],eax

mov dword[i],0
mov ebx,arr

search:
	mov eax,dword[i]
	cmp eax,dword[n]
	je end_search
	mov ecx,dword[k]
	cmp dword[ebx+4*eax],ecx
	je equal
	inc dword[i]
	jmp search
	
equal:
	mov dword[just_print],1
	call print_num
	jmp end

end_search:
	mov dword[just_print],0
	call print_num
	jmp end

end:
	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,l4
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

	mov dword[temp],0
	add dword[temp],30h
	mov eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,1
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
	
		
