.model small 
.stack 
.data                  

file_name db 'file.txt',0    
p_fname   dd file_name   

s_error   db 'Error!',13,10,'$' 
p_s_error   dd s_error       

buffer    db 2048 dup(0)   
p_buff    dd buffer 
        
handle    dw 0 
.code          
     jmp start 

start:
    mov ax, @data
    mov ds, ax
    mov ah,3Dh              
    xor al,al               
    mov dx,p_fname  
    int 21h                 
    jnc openFile                  
    call error_msg          
    jmp exit    
                
openFile: mov [handle],ax         
    mov bx,ax               
    mov ah,3Fh              
    mov dx,p_buff           
    mov cx,80               
    int 21h                 
    jnc printPile                
    call error_msg          
    jmp close_file          
 
printPile: mov bx,p_buff
    add bx,ax               
    mov byte[bx],'$'         
    mov ah,9
    mov dx,p_buff
    int 21h 

close_file:
    mov ah,3Eh              
    mov bx,[handle]         
    int 21h                 
    jnc exit                
    call error_msg          
 
exit:      
    mov ah,8                
    int 21h                 
    mov ax,4C00h            
    int 21h    
  
error_msg:
    mov ah,9
    mov dx,p_s_error
    int 21h                 
    ret
