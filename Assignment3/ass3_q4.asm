section .data
zero: db '0'
l1: equ $-zero
space: db ' '
l2: equ $-space
newline: db '',10
l3: equ $-newline

msg1: db 'Enter size of the array: '
m1: equ $-msg1
msg2: db 'Enter the numbers: ',10
m2: equ $-msg2
msg3: db 'Frequency of the numbers are: ',10
m3: equ $-msg3

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
count: resd 1
arr1: resd 100
key: resd 1


section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,m1
int 80h

call read_num
mov eax,dword[just_read]
mov dword[n],eax

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,m2
int 80h

call read_array
mov dword[i],0

for:
	mov eax,dword[i]
	cmp eax,dword[n]
	je end_for
	mov ebx,arr
	mov ecx,dword[ebx+eax*4]
	mov dword[key],ecx
	mov dword[j],0
	mov dword[count],0
	for1:
		mov eax,dword[j]
		cmp eax,dword[n]
		je end_for1
		cmp ecx,dword[ebx+eax*4]
		je inc_count
		inc dword[j]
		jmp for1
inc_count:
	inc dword[count]
	inc dword[j]
	jmp for1

end_for1:
	mov eax,dword[i]
	mov ebx,arr1
	mov ecx,dword[count]
	mov dword[ebx+eax*4],ecx
	inc dword[i]
	jmp for
	
end_for:
	mov eax,4
	mov ebx,1
	mov ecx,msg3
	mov edx,m3
	int 80h

	mov ebx,arr1
	call print_array
	
	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,l3
	int 80h

	jmp end

end:
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
	
		

