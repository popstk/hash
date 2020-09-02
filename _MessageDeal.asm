;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;任务处理
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Calcing proc

           	invoke	CreateThread,NULL,0,offset _Thread_Calcing,addr szFiledir,NULL,addr hCalc_Thread
          	invoke  CloseHandle,eax
            ret
_Calcing endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;将剪切板的数据与最后一次的校检码作比对
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CompwtClp proc uses eax
       local @Temp,@Clip
       
        invoke IsClipboardFormatAvailable,CF_TEXT
		    .if eax!=0
		  	   invoke OpenClipboard,hWinMain
		  	  .if eax!=0
             invoke GetClipboardData,CF_TEXT
             mov @Temp,eax
             invoke GlobalLock,@Temp
             mov @Clip,eax
             
             mov edi,@Clip
             mov esi,offset szmd5toascill
             xor ebx,ebx                                ;ebx是剪切板文本字节数，不包含字符结尾的0
             .repeat 
             inc ebx
             mov al,[edi+ebx]
             .until !al
             mov ecx,8
              CLD
              REPZ CMPSD
              .if (ZERO?)&&(ebx==32)
                           invoke	MessageBox,NULL,addr szCompwtClpYes,addr szCaption,MB_OK
              .else 
                           invoke	MessageBox,NULL,addr szCompwtClpNo,addr szCaption,MB_OK
             .endif
             invoke GlobalUnlock,@Clip
		  	   .endif
		  .else 
		   invoke	MessageBox,NULL,addr szClipnotext,addr szCaption,MB_OK
		 .endif
		     invoke CloseClipboard
		     
		 ret
_CompwtClp endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;将校检码复制到剪切板
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CopytoClp proc uses eax
         local @Clip,@Temp

         invoke OpenClipboard,hWinMain
         invoke EmptyClipboard
         invoke GlobalAlloc,GMEM_MOVEABLE,33       ;GMEM_MOVEABLE的返回值是句柄，长度是数据长度+1
         mov @Temp,eax                                     
         invoke GlobalLock,@Temp                              ;GlobalLock参数是句柄，返回值是指针
         mov @Clip,eax
          invoke RtlMoveMemory,@Clip,offset szmd5toascill,32
          invoke SetClipboardData,CF_TEXT,@Clip
          invoke GlobalUnlock,@Clip                            ;GlobalUnlock参数是指针
          invoke CloseClipboard
          invoke	MessageBox,NULL,addr szCopy,addr szCaption,MB_OK
          
        ret
_CopytoClp endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;将记录保存到文件
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SaveasFile proc uses eax ecx
       local @dwSaveFile,@temp
       
       invoke GetDlgItemText,hWinMain,IDC_EDIT,offset szRcdBf,sizeof szRcdBf
       invoke	CreateFile,addr szSaveFile,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
       mov @dwSaveFile,eax
       invoke	GetWindowTextLength,hDlgEdit
       mov ecx,eax
       invoke	WriteFile,@dwSaveFile,offset szRcdBf,ecx,addr @temp,0
        invoke	CloseHandle,@dwSaveFile
        
        ret 
_SaveasFile endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;清除屏幕的记录
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ClearRecord proc uses eax
		  	    mov nbRcdBf,0
		  	    invoke SetDlgItemText,hWinMain,IDC_EDIT,0
		  	    
		  	    ret
_ClearRecord endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;处理‘浏览’动作
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ChooseFile proc uses eax
              local	@stOF:OPENFILENAME
              
      		  	invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
	          	mov	@stOF.lStructSize,sizeof @stOF   ;结构的长度
	          	push	hWinMain
		          pop	@stOF.hwndOwner                     ;所属窗口 
		          mov	@stOF.lpstrFilter,offset szFilter     ;文件筛选字符串
	          	mov	@stOF.lpstrFile,offset szFiledir      ;全路径的文件名缓冲区
	           	mov	@stOF.nMaxFile,sizeof szFiledir      ;文件名缓冲区长度
	          	mov	@stOF.Flags,OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST
		          invoke	GetOpenFileName,addr @stOF
		          .if eax
                  invoke _Calcing
              .endif
              
              ret
_ChooseFile endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;处理拉拽消息
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_DropFiles proc uses eax ecx wParam 
           local @dwNum
           
		       invoke   DragQueryFile, wParam, 0FFFFFFFFh, NULL, 0        ;获取拖动文件数目
           mov      @dwNum, eax
           mov     ecx, @dwNum                                                         ;获取拖动文件路径
@@:    cmp    @dwNum, 0
           je    @F
           dec    @dwNum
           invoke   DragQueryFile, wParam, @dwNum, addr szFiledir, 1000
           invoke _Calcing                                              
           jmp    @B
@@:   invoke    DragFinish, hWinMain

           ret 
_DropFiles endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;程序预处理，包括检测是否为带参数运行
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 _InitDialog proc hWnd
 
        		 push	hWnd
			       pop	hWinMain
			       invoke	GetDlgItem,hWnd,BUTTON_TIME
		       	 mov	hDlgTime,eax
			       invoke	GetDlgItem,hWnd,BUTTON_CHOOSE
		       	 mov	hDlgChoose,eax
		       	 invoke	GetDlgItem,hWnd,IDC_EDIT
		       	 mov	hDlgEdit,eax
             invoke	GetDlgItem,hWnd,IDC_PGB1
		       	 mov	hDlgRange,eax
             invoke	_argc
             	.if eax==2
                   invoke	_argv,1,addr szFiledir,sizeof szFiledir
                   invoke _Calcing
             	.endif
             	 invoke  DragAcceptFiles, hWinMain, TRUE
             	 ret
_InitDialog endp