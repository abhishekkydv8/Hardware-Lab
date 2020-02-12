section .data
zero: db '0',10
l1: equ $-zero
space: db ' '
l2: equ $-space
newline: db '',10
l3: equ $-newline
msg1: db 'Enter the value of m: '
m1: equ $-msg1
msg2: db 'Enter the value of n: '
m2: equ $-msg2
msg3: db 'Enter the elements of matrix: ',10
m3: equ $-msg3
msg4: db 'Transpose of given matrix matrix is: ',10
m4: equ $-msg4

section .bss
i: resd 1
j: resd 1
k: resd 1
m: resd 1
n: resd 1
temp: resd 1
just_read: resd 1
just_print: resd 1
count: resd 1
matrix: resd 200


section .text
global _start
_start:

pusha
mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,m1
int 80h
popa

call read_num
mov eax,dword[just_read]
mov dword[m],eax

pusha
mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,m2
int 80h
popa

call read_num
mov eax,dword[just_read]
mov dword[n],eax
mov eax,dword[m]
mov ebx,dword[n]

mov edx,0
mul ebx
mov dword[k],eax
mov ebx,matrix

pusha
mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,m3
int 80h
popa

call read_matrix

pusha
mov eax,4
mov ebx,1
mov ecx,msg4
mov edx,m4
int 80h
popa

call print_matrix
jmp end

read_matrix:
pusha
mov dword[i],0
for:
	mov eax,dword[i]
	cmp eax,dword[k]
	je end_for
	call read_num
	mov ecx,dword[just_read]
	mov dword[ebx+4*eax],ecx
	inc dword[i]
	jmp for

end_for:
	popa
	ret

print_matrix:
pusha
mov dword[i],0
for1:
	mov eax,dword[i]
	cmp eax,dword[n]
	je end_for1
	mov dword[j],0
	for2:
		mov eax,dword[j]
		cmp eax,dword[m]
		je end_for2
		push ebx
		mov eax,dword[n]
		mov ebx,dword[j]
		mov edx,0
		mul ebx
		pop ebx
		mov edx,dword[i]
		add eax,edx
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
		inc dword[j]
		jmp for2

end_for2:
	inc dword[i]
	pusha
	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,l3
	int 80h
	popa
	jmp for1

end_for1:
popa
ret

end:
mov eax,1
mov ebx,0
int 80h

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
		sub dword[temp],30h
		mov eax,dword[just_read]
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
	mov dword[count],0
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
		inc dword[count]
		jmp extracting
	printing:
		cmp dword[count],0
		je end_print
		pop edx
		add edx,30h
		mov dword[temp],edx
		mov eax,4
		mov ebx,1
		mov ecx,temp
		mov edx,1
		int 80h
		dec dword[count]
		jmp printing
end_print:
	popa
	ret
