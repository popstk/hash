;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;��д�Ż��ٶ� ������ϸ��
;����SHA1֧��\���Ӻ�ʱ��ʾ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat, stdcall 
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include ����
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
; equ ����
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
; ���ݶ�     
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data
hWinMain	dd	?
szCaption   db 'HashУ��',0
szFilter        db 'All Files(*.*)',0,'*.*',0,0
szFileError   db '�޷����ļ�%s',0
szFilenfud  db '����',0
szClipnotext db '���а����ı�����',0
szCompare      db '�ȶԽ����',0
szCompwtClpYes db '����а��������ȫƥ��',0
szCompwtClpNo db '����а�����ݲ�ƥ��',0
szCalcing         db '������',0
szCopy             db '�Ѹ�����Ϣ�����а�',0
szWpriftoascilA db '%08X',0
szWpriftoascilB db '%02X',0
szCalcTime db '%dms',0
szSaveFile db 'У����.txt',0
szTemp  db '���а����%d���ֽ�',0
szBsInfmation   db '�ļ�·����%s',0dh,0ah,\
                             '�ļ���С��%s�ֽ�',0dh,0ah,\
                             'MD5 �� %s',0dh,0ah,\
                             'SHA1�� %s',0dh,0ah,0dh,0ah,0
    .data? 
szRcdBf  db  4096 dup(?)     ;�����¼��
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
;>>>>>>>>>>>>>>>>>>MD5ʹ�ÿռ�>>>>>>>>>>>>>>>>>>
state_md5  dd  4 dup(?) 
buffer_md5     db  64 dup(?)
szmd5toascill  db 33 dup (?)
;>>>>>>>>>>>>>>>>>>SHA1ʹ�ÿռ�>>>>>>>>>>>>>>>>>>
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
nbRcdBf dd ?    ;��ǰ��¼������
    .const
FileMapSize dd 8000000h   ;�ڴ�ӳ���ļ�Ĭ�ϴ�С128M��������64byte�ı���
added db 80h,63 dup(0)
Init_data dd 67452301h,0EFCDAB89h,98BADCFEh,10325476h,0C3D2E1F0h
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
include		_Cmdline.asm
include		_Thread_Calcing_Hash_MD5.asm
include		_Thread_Calcing_Hash_SHA1.asm
include		_Thread_Calcing_Hash.asm
include   _Thread_Calcing.asm
include   _MessageDeal.asm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����ڳ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx hWnd,wMsg,wParam,lParam

		mov	eax,wMsg
    	.if eax == WM_COMMAND
		   	mov	eax,wParam
		  	.if	ax ==	IDOK                                         ;����а�Ա�
		  	       invoke _CompwtClp
		  	.elseif ax==BUTTON_CLEAR
               invoke _ClearRecord                           ;�����¼
		  	.elseif ax==BUTTON_CHOOSE
               invoke _ChooseFile
		  	.elseif ax== BUTTON_COPY                      ;����MD5�����а�
		           invoke 	_CopytoClp
		    .elseif ax == BUTTON_SAVE
               invoke  _SaveasFile                            ;�����¼���ļ�
        .endif        
		.elseif	eax ==	WM_DROPFILES
        invoke _DropFiles,wParam                         ;��ק��������
		.elseif	eax ==	WM_CLOSE
			invoke	EndDialog,hWinMain,NULL
		.elseif	eax ==	WM_INITDIALOG
      invoke _InitDialog,hWnd
		.else
			mov	eax,FALSE                                        ;����FALSE��ʾû�д��������Ի������������
			ret
		.endif
		
		mov	eax,TRUE                                           ;����TRUE��ʾ�Ѿ������Ի�����������ٴ���
		ret
_ProcDlgMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		invoke	GetModuleHandle,NULL
		invoke	DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,0
		invoke	ExitProcess,NULL
		end	start
