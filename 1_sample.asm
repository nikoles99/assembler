.model small 
.stack 
.data                  

file_1     db 'file1.txt',0     

file_2     db 'file2.txt',0    

file_3     db 'file3.txt',0 

file_result      db 'result.txt',0            

error      db 'Error!',13,10,'$'       

buffer_1     db 4096 dup(0)     

buffer_2     db 4096 dup(0)   

buffer_3     db 4096 dup(0)   
        
handle     dw 0   

str2        db 5 dup(?) , '$'
len         = $ - str1
mess        db 'yes$'    
mess2        db 'no$'   

.code          
     jmp begin 

begin:
    mov ax, @data
    mov ds, ax
    call initFile1
    call initFile2           
    call compareFile
    call openFileResult
    jmp exit

initFile1:
    lea dx, file_1
    call openFile 
    lea dx,buffer_1
    call readFile
    lea bx,buffer_1 
    call buffToStr 
    call closeFile
    ret

initFile2:
    lea dx, file_2
    call openFile  
    lea dx,buffer_2
    call readFile 
    lea bx,buffer_2 
    call buffToStr
    call closeFile
    ret
    
openFile:   
    mov ah,3Dh              
    xor al,al
    int 21h 
    ret 
    
readFile:
    mov [handle],ax         
    mov bx,ax               
    mov ah,3Fh                        
    mov cx,80               
    int 21h 
    ret                                
     
buffToStr:
    add bx,ax               
    mov byte[bx],'$'
    ret
     
compareFile:
    mov ax,@data
    mov ds,ax
    mov es,ax      
    mov cx,len
    lea si, buffer_1
    lea di, buffer_2
    repe cmpsb
    jne NO
    
Yes:    
    cld
    lea si, mess 
    lea di, str2 
    mov cx, 3  
    rep movsb   
    ret  
    
NO:   
    cld
    lea si, mess 
    lea di, str2 
    mov cx, 3  
    rep movsb   
    ret 
    
openFileResult:
    mov ah,3Dh              
    mov al,1               
    lea dx, file_result
    int 21h     
    jnc printFileResult                  
    call error_msg 
    
printFileResult:  
    mov [handle],ax         
    mov bx,ax  
    mov ah, 40h  
    lea dx,str2 
    mov cx,3
    int 21h           
    jmp closeFile  

closeFile:
    mov ah,3Eh              
    mov bx,[handle]         
    int 21h
    xor dx,dx
    xor bx,bx
    ret 
exit:      
    mov ah,8                
    int 21h                 
    mov ax,4C00h            
    int 21h    
  
error_msg:
    mov ah,9
    lea dx,error
    int 21h                 
    ret

