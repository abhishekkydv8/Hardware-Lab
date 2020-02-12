section .data
zero: db '0'
l1: equ $-zero


section .bss
just_read: resd 1
temp: resd 1
i: resd 1
sum1: resd 1
sum2: resd 1
counter: resd 1
just_print: resd 1
n: resd 1
arr: resd 100
l:resd 1
r: resd 1
x: resd 1
m: resd 1

section .text
global _start:
_start:
call read_num
mov eax,dword[just_read]
mov dword[n],eax
call read_array
call read_num
mov eax,dword[just_read]
mov dword[x],eax
mov ebx,arr
cmp eax,dword[ebx]
jb end_while


mov dword[l],0
mov eax,dword[n]
sub eax,1
mov dword[r],eax
mov ebx,arr

while:
	mov eax,dword[l]
	cmp eax,dword[r]
	ja end_while
	mov eax,dword[l]
	add eax,dword[r]
	mov edx,0
	mov ebx,2
	div ebx
	mov dword[m],eax
	mov ebx,arr
	mov ecx,dword[ebx+eax*4]
	cmp ecx,dword[x]
	je if_equal
	cmp ecx,dword[x]
	jb if_less
	dec eax
	mov dword[r],eax
	jmp while

end_while:
	mov dword[just_print],0
	call print_num
end:
	mov eax,1
	mov ebx,0
	int 80h
if_equal:
	mov eax,dword[m]
	mov dword[just_print],eax
	call print_num
	jmp end
if_less:
	add eax,1
	mov dword[l],eax
	jmp while



read_array:
pusha 
mov dword[i],0
mov ebx,arr
read:
	mov eax,dword[i]
	cmp eax,dword[n]
	je end_read_array
	call read_num
	mov ecx,dword[just_read]
	mov dword[ebx+4*eax],ecx
	inc dword[i]
	jmp read

end_read_array:
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
