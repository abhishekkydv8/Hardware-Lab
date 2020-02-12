section .data
msg1:db 'Enter two numbers',10
len1:equ $-msg1
msg2:db '',10
len2:equ $-msg2

zero:db '0'
l:equ $-zero

section .bss
a:resd 1
b:resd 1
c:resd 1
s1:resd 1
s2:resd 1
s3:resd 1
jr:resd 1
jp:resd 1
temp:resd 1

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,len1
int 80h


call read_num
mov eax,dword[jr]
mov dword[a],eax

call read_num
mov eax,dword[jr]
mov dword[b],eax

mov eax,dword[a]
mov ebx,100
mul ebx
mov ebx,dword[b]
add eax,ebx

mov dword[jp],eax
call print_num

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,len2
int 80h

mov eax,dword[a]
mov ebx,10
mov edx,0
div ebx

mov dword[s1],eax
mov dword[s2],edx
mov ebx,10
mov eax,edx
mov edx,0
mul ebx
add eax,dword[s1]

mov dword[jp],eax
call print_num

mov eax,dword[b]
mov ebx,10
div ebx

mov dword[s1],eax
mov dword[s2],edx
mov ebx,10
mov eax,edx
mov edx,0
mul ebx
add eax,dword[s1]

mov dword[jp],eax
call print_num

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,len2
int 80h

mov eax,dword[b]
mov dword[jp],eax
call print_num
mov eax,dword[a]
mov dword[jp],eax
call print_num

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,len2
int 80h

mov eax,dword[a]
mov ebx,10
mov edx,0
div ebx
mov dword[s1],eax
mov dword[s2],edx
mov ebx,10
mov edx,0
mul ebx
mov dword[s1],eax
mov eax,dword[s2]
mov ebx,1000
mov edx,0
mul ebx
add eax,dword[s1]
mov dword[s1],eax
mov eax,dword[b]
mov ebx,100
mov edx,0
mul ebx
add eax,dword[s1]
mov dword[jp],eax
call print_num

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,len2
int 80h

mov eax,1
mov ebx,0
int 80h


read_num:
pusha
mov dword[jr],0
reading:
mov eax,3
mov ebx,1
mov ecx,temp
mov edx,1
int 80h

cmp dword[temp],10
je end_read

sub dword[temp],30h
mov eax,dword[jr]
mov edx,0
mov ebx,10
mul ebx

add eax,dword[temp]
mov dword[jr],eax
jmp reading

end_read:
popa
ret



print_num:
pusha
mov dword[c],0
cmp dword[jp],0
jne move

mov dword[zero],30h
mov eax,4
mov ebx,1
mov ecx,zero
mov edx,1
int 80h
jmp end_print


move:
cmp dword[jp],0
je printing
mov eax,dword[jp]
mov edx,0
mov ebx,10
div ebx
push edx
mov dword[jp],eax
add dword[c],1
jmp move


printing:
cmp dword[c],0
je end_print
pop edx
add edx,30h
mov dword[temp],edx

mov eax,4
mov ebx,1
mov ecx,temp
mov edx,1
int 80h
sub dword[c],1
jmp printing

end_print:
popa
ret
