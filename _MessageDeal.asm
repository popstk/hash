;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;������
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Calcing proc

           	invoke	CreateThread,NULL,0,offset _Thread_Calcing,addr szFiledir,NULL,addr hCalc_Thread
          	invoke  CloseHandle,eax
            ret
_Calcing endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;�����а�����������һ�ε�У�������ȶ�
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
             xor ebx,ebx                                ;ebx�Ǽ��а��ı��ֽ������������ַ���β��0
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
;��У���븴�Ƶ����а�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CopytoClp proc uses eax
         local @Clip,@Temp

         invoke OpenClipboard,hWinMain
         invoke EmptyClipboard
         invoke GlobalAlloc,GMEM_MOVEABLE,33       ;GMEM_MOVEABLE�ķ���ֵ�Ǿ�������������ݳ���+1
         mov @Temp,eax                                     
         invoke GlobalLock,@Temp                              ;GlobalLock�����Ǿ��������ֵ��ָ��
         mov @Clip,eax
          invoke RtlMoveMemory,@Clip,offset szmd5toascill,32
          invoke SetClipboardData,CF_TEXT,@Clip
          invoke GlobalUnlock,@Clip                            ;GlobalUnlock������ָ��
          invoke CloseClipboard
          invoke	MessageBox,NULL,addr szCopy,addr szCaption,MB_OK
          
        ret
_CopytoClp endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����¼���浽�ļ�
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
;�����Ļ�ļ�¼
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ClearRecord proc uses eax
		  	    mov nbRcdBf,0
		  	    invoke SetDlgItemText,hWinMain,IDC_EDIT,0
		  	    
		  	    ret
_ClearRecord endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;�������������
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ChooseFile proc uses eax
              local	@stOF:OPENFILENAME
              
      		  	invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
	          	mov	@stOF.lStructSize,sizeof @stOF   ;�ṹ�ĳ���
	          	push	hWinMain
		          pop	@stOF.hwndOwner                     ;�������� 
		          mov	@stOF.lpstrFilter,offset szFilter     ;�ļ�ɸѡ�ַ���
	          	mov	@stOF.lpstrFile,offset szFiledir      ;ȫ·�����ļ���������
	           	mov	@stOF.nMaxFile,sizeof szFiledir      ;�ļ�������������
	          	mov	@stOF.Flags,OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST
		          invoke	GetOpenFileName,addr @stOF
		          .if eax
                  invoke _Calcing
              .endif
              
              ret
_ChooseFile endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;������ק��Ϣ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_DropFiles proc uses eax ecx wParam 
           local @dwNum
           
		       invoke   DragQueryFile, wParam, 0FFFFFFFFh, NULL, 0        ;��ȡ�϶��ļ���Ŀ
           mov      @dwNum, eax
           mov     ecx, @dwNum                                                         ;��ȡ�϶��ļ�·��
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
;����Ԥ������������Ƿ�Ϊ����������
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