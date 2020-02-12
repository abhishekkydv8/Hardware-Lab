section .data
newline: db '',10
l1: equ $-newline
msg2: db 'Average of given numbers is: '
l2: equ $-msg2
msg3: db 'Count of numbers that are above the average is:'
l3: equ $-msg3
msg4: db 'Enter the value of n :',10
l4: equ $-msg4
msg5: db 'Enter the numbers :',10
l5: equ $-msg5

section .bss
just_read: resd 1
temp: resd 1
just_print: resd 1
counter: resd 1
arr: resd 100
i: resd 1
n: resd 1
sum: resd 1
avg1: resd 1

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg4
mov edx,l4
int 80h

call read_num
mov eax,dword[just_read]
mov dword[n],eax

mov eax,4
mov ebx,1
mov ecx,msg5
mov edx,l5
int 80h

call read_array

mov ebx,arr
mov dword[i],0
mov dword[sum],0

avg:
	mov eax,dword[i]
	cmp dword[n],eax
	je end_avg
	mov ecx,dword[ebx+eax*4]
	add dword[sum],ecx
	inc dword[i]
	jmp avg

end_avg:
	mov eax,dword[sum]
	mov ebx,dword[n]
	mov edx,0
	div ebx
	mov dword[just_print],eax
	
	pusha
	mov eax,4
	mov ebx,1
	mov ecx,msg2
	mov edx,l2
	int 80h
	popa

	call print_num
	mov dword[avg1],eax

	mov dword[i],0
	mov dword[counter],0
	mov ebx,arr

count:
	mov eax,dword[i]
	cmp eax,dword[n]
	je end_count
	mov ecx,dword[avg1]
	cmp dword[ebx+eax*4],ecx
	ja inc_count
	inc dword[i]
	jmp count

inc_count:
	inc dword[counter]
	inc dword[i]
	jmp count

end_count:
	mov eax,dword[counter]
	mov dword[just_print],eax
	
	mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,l1
        int 80h	

	mov eax,4
	mov ebx,1
	mov ecx,msg3
	mov edx,l3
	int 80h

	call print_num

	mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,l1
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
	
		
