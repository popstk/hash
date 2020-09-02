;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Hash��md5�Ĳ���ѭ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_FF proc ta,tb,tc,td,M,ts,k
      mov eax,tb    ;F(tb,tc,td)
      mov ecx,eax
      and eax,tc
      not ecx
      and ecx,td
      or eax,ecx

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_FF endp
_GG proc ta,tb,tc,td,M,ts,k
      mov eax,td     ;G(tb,tc,td)
      mov ecx,eax
      and eax,tb
      not ecx
      and ecx,tc
      or eax,ecx

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_GG endp
_HH proc ta,tb,tc,td,M,ts,k
      mov eax,tb        ;H(tb,tc,td)
      xor eax,tc
      xor eax,td

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_HH endp
_II proc ta,tb,tc,td,M,ts,k
      mov eax,td       ;I(tb,tc,td)
      not eax
      or eax,tb
      xor eax,tc

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_II endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>		

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;_MD5to64  ebx��edx�̶�������state_md5�ʹ��任���ַ�lpMemory
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>		
_MD5to64 proc uses eax ebx ecx edx lpMemory
     local @aa,@bb,@cc,@dd          
                                            
     mov ebx,offset state_md5
     mov edx,lpMemory        
     push dword ptr [ebx]
     pop @aa
     push dword ptr [ebx+4]
     pop @bb
     push dword ptr [ebx+8]
     pop @cc
     push dword ptr [ebx+12]
     pop @dd

     invoke _FF,@aa,@bb,@cc,@dd,[edx+0],7,0d76aa478h;��1��
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+4],12,0e8c7b756h;��2��
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+8],17,0242070dbh;��3��
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+12],22,0c1bdceeeh;��4��
     mov @bb,eax
     invoke _FF,@aa,@bb,@cc,@dd,[edx+16],7,0f57c0fafh;��5��
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+20],12,04787c62ah;��6��
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+24],17,0a8304613h;��7��
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+28],22,0fd469501h;��8��
     mov @bb,eax
     invoke _FF,@aa,@bb,@cc,@dd,[edx+32],7,0698098d8h;��9��
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+36],12,08b44f7afh;��10��
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+40],17,0ffff5bb1h;��11��
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+44],22,0895cd7beh;��12��
     mov @bb,eax
     invoke _FF,@aa,@bb,@cc,@dd,[edx+48],7,06b901122h;��13��
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+52],12,0fd987193h;��14��
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+56],17,0a679438eh;��15��
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+60],22,049b40821h;��16��
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+4],5,0f61e2562h;��17��
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+24],9,0c040b340h;��18��
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+44],14,0265e5a51h;��19��
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+0],20,0e9b6c7aah;��20��
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+20],5,0d62f105dh;��21��
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+40],9,002441453h;��22��
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+60],14,0d8a1e681h;��23��
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+16],20,0e7d3fbc8h;��24��
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+36],5,021e1cde6h;��25��
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+56],9,0c33707d6h;��26��
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+12],14,0f4d50d87h;��27��
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+32],20,0455a14edh;��28��
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+52],5,0a9e3e905h;��29��
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+8],9,0fcefa3f8h;��30��
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+28],14,0676f02d9h;��31��
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+48],20,08d2a4c8ah;��32��
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+20],4,0fffa3942h;��33��
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+32],11,08771f681h;��34��
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+44],16,06d9d6122h;��35��
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+56],23,0fde5380ch;��36��
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+4],4,0a4beea44h;��37��
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+16],11,04bdecfa9h;��38��
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+28],16,0f6bb4b60h;��39��
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+40],23,0bebfbc70h;��40��
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+52],4,0289b7ec6h;��41��
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+0],11,0eaa127fah;��42��
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+12],16,0d4ef3085h;��43��
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+24],23,004881d05h;��44��
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+36],4,0d9d4d039h;��45��
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+48],11,0e6db99e5h;��46��
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+60],16,01fa27cf8h;��47��
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+8],23,0c4ac5665h;��48��
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+0],6,0f4292244h;��49��
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+28],10,0432aff97h;��50��
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+56],15,0ab9423a7h;��51��
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+20],21,0fc93a039h;��52��
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+48],6,0655b59c3h;��53��
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+12],10,08f0ccc92h;��54��
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+40],15,0ffeff47dh;��55��
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+4],21,085845dd1h;��56��
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+32],6,06fa87e4fh;��57��
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+60],10,0fe2ce6e0h;��58��
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+24],15,0a3014314h;��59��
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+52],21,04e0811a1h;��60��
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+16],6,0f7537e82h;��61��
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+44],10,0bd3af235h;��62��
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+8],15,02ad7d2bbh;��63��
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+36],21,0eb86d391h;��64��
     mov @bb,eax

     mov eax,@aa
     add dword ptr [ebx],eax
     mov eax,@bb
     add dword ptr [ebx+4],eax
     mov eax,@cc
     add dword ptr [ebx+8],eax
     mov eax,@dd
     add dword ptr [ebx+12],eax

     ret 
_MD5to64 endp