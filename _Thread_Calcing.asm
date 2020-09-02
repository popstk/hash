;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 文件大小十六进制转换十进制显示
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_FileSizeChange proc

    invoke RtlZeroMemory,addr szFilebyte,sizeof szFilebyte
    xor ecx,ecx
    mov ebx,0Ah
    @@:
    xor edx,edx
    mov eax,len1
    div ebx
    mov len1,eax
    mov eax, len0
    div ebx
    mov len0,eax
    push dx
    inc ecx
    cmp len0,0
    jnz @B
    cmp len1,0
    jnz @B
    
   lea ebx,szFilebyte
   @@:
   pop dx
   add dl,48          ;转为相应数字的ASCII
   mov [ebx],dl
   inc ebx
   loop @B
   
   ret
_FileSizeChange endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ;判断缓存的记录
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_RecordDeal proc 

   mov eax,nbRcdBf
   .if eax>=10  
      invoke _ClearRecord
   .endif
   inc nbRcdBf
   invoke	GetWindowTextLength,hDlgEdit
	 invoke	SendMessage,hDlgEdit,EM_SETSEL,eax,eax
   invoke	SendMessage,hDlgEdit,EM_REPLACESEL,FALSE,addr szBuffer
   ret
_RecordDeal endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;创建线程计算
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Thread_Calcing proc uses eax ebx ecx edx lpFiledir

    invoke  CreateFile,lpFiledir,GENERIC_READ or GENERIC_WRITE, 0,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
     .if eax== INVALID_HANDLE_VALUE 
          invoke  wsprintf,addr szBuffer ,addr szFileError, lpFiledir
          invoke MessageBox,NULL,offset szBuffer,offset szFilenfud,MB_OK or MB_ICONEXCLAMATION
		     ret
	    .endif
	    mov hFile,eax
	   	invoke  GetFileSize,hFile,addr len1    ; 获取文件大小
      mov len0,eax
 ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>    
      invoke SendMessage,hDlgRange,PBM_SETPOS,0,0  
      invoke	EnableWindow,hDlgChoose,FALSE
      invoke  DragAcceptFiles, hWinMain, FALSE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;调用计算MD5
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     invoke	SetWindowText,hDlgTime,addr szCalcing
     invoke GetTickCount
     mov dwTickcount,eax   
     invoke _Thread_Calcing_Hash
     invoke GetTickCount
     sub eax,dwTickcount
     invoke  wsprintf,offset szCalcTimeBf,addr szCalcTime, eax
     invoke	SetWindowText,hDlgTime,addr szCalcTimeBf
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
    invoke EnableWindow,hDlgChoose,TRUE
    invoke  DragAcceptFiles, hWinMain, TRUE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;将MD5转为字符串
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  mov esi,offset state_md5
  mov edi,offset szmd5toascill                  
  invoke RtlZeroMemory,edi,sizeof szmd5toascill   ;将szmd5toascill重置
  mov ecx,16
@@:   
   movzx ebx,byte ptr [esi]
   push ecx
   invoke  wsprintf,edi,addr szWpriftoascilB, ebx    ;没有保存ecx将被覆盖
   pop ecx
   inc esi
   add edi,2
  loop @B
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;将SHA1转为字符串
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  mov esi,offset state_sha1
  mov edi,offset szsha1toascill      
  invoke RtlZeroMemory,edi,sizeof szsha1toascill   ;重置
   xor edx,edx
   .while edx<5
   push edx
   invoke  wsprintf,edi,addr szWpriftoascilA, dword ptr [esi] ;没有保存ecx将被覆盖
   pop edx
   inc edx
   add edi,8
   add esi,4
  .endw
;********************************************************************
   invoke  _FileSizeChange
   invoke  wsprintf,offset szBuffer,addr szBsInfmation, lpFiledir,offset szFilebyte,offset szmd5toascill ,offset szsha1toascill
   invoke  _RecordDeal
   ret
_Thread_Calcing endp
