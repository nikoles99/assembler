.model small 
.stack 
.data                  

file_1     db 'file1.txt',0    
p_file_1   dd file_1  

file_2     db 'file2.txt',0    
p_file_2   dd file_2  

file_3     db 'file3.txt',0    
p_file_3   dd file_3       

error      db 'Error!',13,10,'$' 
p_error    dd error       

buffer_1     db 4096 dup(0)   
p_buffer_1   dd buffer_1   

buffer_2     db 4096 dup(0)   
p_buffer_2   dd buffer_2 

buffer_3     db 4096 dup(0)   
p_buffer_3   dd buffer_3 
        
handle     dw 0   

str1        db 'qwsdsderty'
str2        db 'qwerty'
len         = $ - str2
mess        db 'yes$'    
mess2        db 'no$'   

.code          
     jmp begin 

begin:
    mov ax, @data
    mov ds, ax
    call openFile1
    call openFile2
    call openFile3            
    jmp exit
    
openFile1:   
    mov ah,3Dh              
    xor al,al               
    lea dx, file_1
    int 21h
    jnc readFile1                  
    call error_msg          
    jmp exit  

openFile2:   
    mov ah,3Dh              
    xor al,al               
    lea dx, file_2
    int 21h
    jnc readFile2                  
    call error_msg          
    jmp exit 
    
openFile3:   
    mov ah,3Dh              
    xor al,al               
    lea dx, file_3
    int 21h 
    jnc readFile3                  
    call error_msg          
    jmp exit      
                
readFile1:
    mov [handle],ax         
    mov bx,ax               
    mov ah,3Fh              
    mov dx,p_buffer_1           
    mov cx,80               
    int 21h                 
    jnc printFile                
    call error_msg          
    jmp close_file  
    
readFile2:
    mov [handle],ax         
    mov bx,ax               
    mov ah,3Fh              
    mov dx,p_buffer_2           
    mov cx,80               
    int 21h                 
    jnc printFile                
    call error_msg          
    jmp close_file
    
readFile3:
    mov [handle],ax         
    mov bx,ax               
    mov ah,3Fh              
    mov dx,p_buffer_3           
    mov cx,80               
    int 21h                 
    jnc compareFile               
    call error_msg          
    jmp close_file        
 
printFile:
    mov bx,p_buffer_1
    add bx,ax               
    mov byte[bx],'$'         
    mov ah,9
    mov dx,p_buffer_1
    int 21h 

close_file:
    mov ah,3Eh              
    mov bx,[handle]         
    int 21h
    xor dx,dx
    ret                           


compareFile:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
    
    mov     cx,len
    mov     si,offset p_buffer_1
    mov     di, offset p_buffer_2
    repe cmpsb
    jne     NO
    
Yes:    
    mov     ah,9
    mov     dx,offset mess
    int     21h   
    call    exit  
    
NO:   
    mov     ah,9
    mov     dx,offset mess2
    int     21h  
    mov     ax,4c00h
    int     21h      
    
    
exit:      
    mov ah,8                
    int 21h                 
    mov ax,4C00h            
    int 21h    
  
error_msg:
    mov ah,9
    mov dx,p_error
    int 21h                 
    ret

