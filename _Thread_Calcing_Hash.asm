;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;处理过程，需要考虑速度及初始值
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ClearRecord proto

_Thread_Calcing_Hash    proc  uses  eax ebx ecx edx
    local @lpMemory 
;==============初始状态调整============================
  invoke  RtlMoveMemory,offset state_md5,offset Init_data,16
  invoke  RtlMoveMemory,offset state_sha1,offset Init_data,20 
  invoke	CreateFileMapping,hFile,NULL,PAGE_READONLY,0,0,NULL
	mov	hFileMap,eax
;==============初始状态调整============================
	mov edx,len1
	mov eax,len0
	mov ebx,FileMapSize
	div ebx
	inc eax
	shl eax,16
	invoke SendMessage,hDlgRange,PBM_SETRANGE,0,eax 
  invoke SendMessage,hDlgRange,PBM_SETSTEP,1,0  
  
	mov  edx,len1
	mov eax,len0
	mov ecx,FileMapSize
	div ecx
	mov Bquotient,eax
	mov Bremainder,edx
	
	xor edx,edx
	mov eax,FileMapSize
	mov ecx,64
	div ecx
	mov Squotient,eax
	
	push len0
  pop Sremainder
	and Sremainder,3Fh 
;===============================大部分消耗=======================
mov count1,0
mov count0,0
mov esi,Bquotient
mov ebx,FileMapSize

.while esi!=0
    invoke	MapViewOfFile,hFileMap,FILE_MAP_READ,count1,count0,FileMapSize
    mov @lpMemory,eax
    mov edi,Squotient
    .while edi!=0
    
           invoke _MD5to64,eax   ;子循环===========================================
           invoke _SHA1to80,eax
           
           add eax,64
           dec edi
     .endw
     add count0,ebx
     adc count1,0
     dec esi
     invoke	UnmapViewOfFile,@lpMemory
     invoke SendMessage,hDlgRange,PBM_STEPIT,0,0
.endw
;===============================大部分消耗=======================
xor edx,edx
mov eax,Bremainder
mov ecx,64
div ecx
mov edi,eax
 invoke	MapViewOfFile,hFileMap,FILE_MAP_READ,count1,count0,Bremainder
 mov @lpMemory,eax
 .while edi!=0
 
      invoke _MD5to64,eax                          ;子循环===========================================
      invoke _SHA1to80,eax
      
      add eax,64
      dec edi
.endw
invoke RtlMoveMemory,offset buffer_md5,eax,Sremainder    ;将剩余不足64字节的数据存入buffer_md5
invoke	UnmapViewOfFile,@lpMemory
mov eax,Sremainder
  .if eax>=56                                                         
         mov ebx,offset buffer_md5
         add ebx,Sremainder
         mov ecx,64
         sub ecx,Sremainder                                             ;ecx=64-Sremainder 
         invoke RtlMoveMemory,ebx,offset added,ecx
         
         invoke _MD5to64,offset buffer_md5    ;子循环===========================================
         invoke _SHA1to80,offset buffer_md5
         
         mov eax,offset added
         add eax,64                                                       
         sub eax,Sremainder
         invoke RtlMoveMemory,offset buffer_md5,eax,56
  .else                                                                             ;<56则只会变换一轮
         mov ebx,offset buffer_md5
         add ebx,Sremainder
         mov ecx,56
         sub ecx,Sremainder
         invoke RtlMoveMemory,ebx,offset added,ecx
  .endif  
   
   push len0  
   pop count0               
   push len1
   pop count1                 
   mov eax,0E0000000h                             ;将64位数乘以8
   and eax,count0
   shr eax,29
   shl count0,3
   shl count1,3
   add count1,eax
   
   mov ebx,offset buffer_md5    ;填充输入信息长度，并进行最后一次变换
   ;md5的按照小端排序
   mov eax,count0  
   mov dword ptr [ebx+56],eax
   mov eax,count1
   mov dword ptr [ebx+60],eax
   invoke _MD5to64,offset buffer_md5   ;子循环===========================================
   ;sha1的按照大端端排序
   xor ecx,ecx
   lea edx,[ebx+59]
   mov eax,count1
   .while ecx<4
   mov [edx],al
   shr eax , 8
   inc ecx
   dec edx
   .endw
   xor ecx,ecx
   lea edx,[ebx+63]
   mov eax,count0
   .while ecx<4
   mov [edx],al
   shr eax ,8
   inc ecx
   dec edx
   .endw
   invoke _SHA1to80,offset buffer_md5
   
   invoke SendMessage,hDlgRange,PBM_STEPIT,0,0
		invoke	CloseHandle,hFileMap
		invoke	CloseHandle,hFile
		
   ret
_Thread_Calcing_Hash endp