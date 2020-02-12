section .data
msg1: db 'There is no such number which is equal to sum of the other two',10
l1: equ $-msg1

section .bss
just_read: resd 1
just_print: resd 1
temp: resd 1
counter: resd 1
zero: resd 1
sum1: resd 1
sum2: resd 1
sum3: resd 1
a: resd 1
b: resd 1
c: resd 1

section .text
global _start:
_start:

call read_num
mov eax,dword[just_read]
mov dword[a],eax

call read_num
mov eax,dword[just_read]
mov dword[b],eax

call read_num
mov eax,dword[just_read]
mov dword[c],eax

mov eax,dword[a]
add eax,dword[b]
mov dword[sum1],eax

mov eax,dword[b]
add eax,dword[c]
mov dword[sum2],eax

mov eax,dword[c]
add eax,dword[a]
mov dword[sum3],eax

mov eax,dword[c]
cmp dword[sum1],eax
je print1

label1:
mov eax,dword[a]
cmp dword[sum2],eax
je print2

label2:
mov eax,dword[b]
cmp dword[sum3],eax
je print3

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,l1
int 80h

label3:
mov eax,1
mov ebx,0
int 80h

print1:
	mov eax,dword[sum1]
	mov dword[just_print],eax
	call print_num
	jmp label3
	
print2:
        mov eax,dword[sum2]
        mov dword[just_print],eax
        call print_num
        jmp label3

print3:
        mov eax,dword[sum3]
        mov dword[just_print],eax
        call print_num
        jmp label3


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
		mov edx,0
		mov ebx,10
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
	mov dword[zero],30h
	mov eax,4
	mov eax,1
	mov ecx,zero
	mov edx,1
	int 80h
	jmp end_print

	extracting:
		cmp dword[just_print],0
		je printing
		mov eax,dword[just_print]
		mov edx,0
		mov ebx,10
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
	mov eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,1
	int 80h
	dec dword[counter]
	jmp printing

end_print:
	popa
	ret
