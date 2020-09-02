;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;重写优化速度 进度条细化
;增加SHA1支持\增加耗时显示
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat, stdcall 
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 数据
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include   shell32.inc
includelib shell32.lib
include     comdlg32.inc
includelib  comdlg32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; equ 数据
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DLG_MAIN	equ	2000
IDC_EDIT equ 2001
IDC_PGB1 equ 2002
BUTTON_TIME equ 2005
BUTTON_COPY equ 2006
BUTTON_CLEAR equ 2007
BUTTON_CHOOSE equ 2008
BUTTON_SAVE equ 2009
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段     
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data
hWinMain	dd	?
szCaption   db 'Hash校检',0
szFilter        db 'All Files(*.*)',0,'*.*',0,0
szFileError   db '无法打开文件%s',0
szFilenfud  db '错误',0
szClipnotext db '剪切板无文本数据',0
szCompare      db '比对结果！',0
szCompwtClpYes db '与剪切板的内容完全匹配',0
szCompwtClpNo db '与剪切板的内容不匹配',0
szCalcing         db '计算中',0
szCopy             db '已复制信息到剪切板',0
szWpriftoascilA db '%08X',0
szWpriftoascilB db '%02X',0
szCalcTime db '%dms',0
szSaveFile db '校检码.txt',0
szTemp  db '剪切板包含%d个字节',0
szBsInfmation   db '文件路径：%s',0dh,0ah,\
                             '文件大小：%s字节',0dh,0ah,\
                             'MD5 ： %s',0dh,0ah,\
                             'SHA1： %s',0dh,0ah,0dh,0ah,0
    .data? 
szRcdBf  db  4096 dup(?)     ;缓存记录区
szCalcTimeBf db 20 dup(?) 
szBuffer  db 512 dup(?) 
szFiledir   db  256 dup(?)
szFilebyte db 21 dup (?)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
hDlgChoose dd ?
hDlgTime     dd ?
hDlgEdit      dd ?
hDlgRange  dd ?
hFile            dd ?
hCalc_Thread dd ?
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>MD5使用空间>>>>>>>>>>>>>>>>>>
state_md5  dd  4 dup(?) 
buffer_md5     db  64 dup(?)
szmd5toascill  db 33 dup (?)
;>>>>>>>>>>>>>>>>>>SHA1使用空间>>>>>>>>>>>>>>>>>>
state_sha1  dd  5 dup(?) 
_Hash_Sha1_w dd 80 dup(?) 
szsha1toascill  db 41 dup (?)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Sremainder dd ?
Squotient dd ?
Bremainder dd ?
Bquotient dd ?
count0 dd ?
count1 dd  ?
hFileMap dd ?
dwTickcount dd ?
len0  dd ?
len1  dd ?
RangMax dd ?
nbRcdBf dd ?    ;当前记录的条数
    .const
FileMapSize dd 8000000h   ;内存映射文件默认大小128M，必须是64byte的倍数
added db 80h,63 dup(0)
Init_data dd 67452301h,0EFCDAB89h,98BADCFEh,10325476h,0C3D2E1F0h
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
include		_Cmdline.asm
include		_Thread_Calcing_Hash_MD5.asm
include		_Thread_Calcing_Hash_SHA1.asm
include		_Thread_Calcing_Hash.asm
include   _Thread_Calcing.asm
include   _MessageDeal.asm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 主窗口程序
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx hWnd,wMsg,wParam,lParam

		mov	eax,wMsg
    	.if eax == WM_COMMAND
		   	mov	eax,wParam
		  	.if	ax ==	IDOK                                         ;与剪切板对比
		  	       invoke _CompwtClp
		  	.elseif ax==BUTTON_CLEAR
               invoke _ClearRecord                           ;清除记录
		  	.elseif ax==BUTTON_CHOOSE
               invoke _ChooseFile
		  	.elseif ax== BUTTON_COPY                      ;复制MD5到剪切板
		           invoke 	_CopytoClp
		    .elseif ax == BUTTON_SAVE
               invoke  _SaveasFile                            ;保存记录到文件
        .endif        
		.elseif	eax ==	WM_DROPFILES
        invoke _DropFiles,wParam                         ;拉拽动作处理
		.elseif	eax ==	WM_CLOSE
			invoke	EndDialog,hWinMain,NULL
		.elseif	eax ==	WM_INITDIALOG
      invoke _InitDialog,hWnd
		.else
			mov	eax,FALSE                                        ;返回FALSE表示没有处理，交给对话框管理器处理
			ret
		.endif
		
		mov	eax,TRUE                                           ;返回TRUE表示已经处理，对话框管理器则不再处理
		ret
_ProcDlgMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		invoke	GetModuleHandle,NULL
		invoke	DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,0
		invoke	ExitProcess,NULL
		end	start
