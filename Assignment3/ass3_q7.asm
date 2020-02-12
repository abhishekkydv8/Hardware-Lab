section .data
zero: db '0'
l1: equ $-zero
space: db ' '
l2: equ $-space
newline: db '',10
l3: equ $-newline
msg1: db 'Enter the value of m: '
m1: equ $-msg1
msg2: db 'Emter the value of n: '
m2: equ $-msg2
msg3: db 'Enter the elements of first matrix',10
m3: equ $-msg3
msg4: db 'Enter the elements of second matrix',10
m4: equ $-msg4
msg5: db 'Resultant matrix is: ',10
m5: equ $-msg5

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
matrix1: resd 200
matrix2: resd 200

section .text
global _start
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,m1
int 80h

call read_num
mov eax,dword[just_read]
mov dword[m],eax

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,m2
int 80h

call read_num
mov eax,dword[just_read]
mov dword[n],eax
mov eax,dword[m]
mov ebx,dword[n]

mov edx,0
mul ebx
mov dword[k],eax

mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,m3
int 80h

mov ebx,matrix
call read_matrix

mov eax,4
mov ebx,1
mov ecx,msg4
mov edx,m4
int 80h

mov ebx,matrix1
call read_matrix
call add_matrix

mov eax,4
mov ebx,1
mov ecx,msg5
mov edx,m5
int 80h

mov ebx,matrix2
call print_matrix
jmp end

add_matrix:
pusha
mov dword[i],0
add:
        mov eax,dword[i]
        cmp eax,dword[k]
        je end_add
	mov ebx,matrix
        mov ecx,dword[ebx+4*eax]
	mov ebx,matrix1
	mov edx,dword[ebx+eax*4]
	add ecx,edx
	mov ebx,matrix2
	mov dword[ebx+eax*4],ecx
        inc dword[i]
        jmp add
end_add:
	popa
	ret

read_matrix:
pusha
mov dword[i],0
;mov ebx,matrix
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
;mov ebx,matrix
for1:
	mov eax,dword[i]
	cmp eax,dword[m]
	je end_for1
	mov dword[j],0
	for2:
		mov eax,dword[j]
		cmp eax,dword[n]
		je end_for2
		push ebx
		mov eax,dword[n]
		mov ebx,dword[i]
		mov edx,0
		mul ebx
		pop ebx
		mov edx,dword[j]
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
